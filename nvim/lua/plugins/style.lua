-- Formatters and linters use the project's own config files first and fall back to the
-- defaults in ~/.config/nvim/style-defaults/. See lua/config/style.lua for the lookup rules.
local style = require("config.style")

local function bufname()
  return vim.api.nvim_buf_get_name(0)
end

-- nvim-lint's phpstan parser matches result paths to the buffer name exactly, which fails when the
-- path's case differs from the real folder name (e.g. ~/git/pbbg vs ~/git/PBBG), so compare real paths.
local function phpstan_parser(output, bufnr)
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" or type(decoded.files) ~= "table" then
    if vim.trim(output) == "" then
      return {}
    end
    return {
      {
        lnum = 0,
        col = 0,
        severity = vim.diagnostic.severity.WARN,
        source = "phpstan",
        message = "Could not parse phpstan output: " .. output:sub(1, 300),
      },
    }
  end

  local bufpath = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(bufnr))
  local diagnostics = {}
  for path, file in pairs(decoded.files) do
    if vim.uv.fs_realpath(path) == bufpath then
      for _, message in ipairs(file.messages or {}) do
        table.insert(diagnostics, {
          lnum = type(message.line) == "number" and (message.line - 1) or 0,
          col = 0,
          severity = vim.diagnostic.severity.ERROR,
          source = "phpstan",
          code = message.identifier,
          message = message.message,
        })
      end
    end
  end
  return diagnostics
end

local function phpstan_root(path)
  local project = style.project_file("phpstan", path)
  return project and vim.fs.dirname(project) or style.root(path)
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- PHP: the project's pint or php-cs-fixer setup, otherwise pint with the default pint.json.
      opts.formatters_by_ft.php = { "pint", "php_cs_fixer", "pint_default", stop_after_first = true }
      opts.formatters.pint = {
        condition = function(_, ctx)
          return style.project_file("pint", ctx.filename) ~= nil
            or style.find_upward({ "vendor/bin/pint" }, ctx.filename) ~= nil
        end,
        -- Pint reads pint.json from its working directory.
        cwd = function(_, ctx)
          local project = style.project_file("pint", ctx.filename)
          return project and vim.fs.dirname(project) or style.root(ctx.filename)
        end,
      }
      opts.formatters.php_cs_fixer = {
        condition = function(_, ctx)
          return style.project_file("php_cs_fixer", ctx.filename) ~= nil
        end,
        args = function(_, ctx)
          return { "fix", "--config=" .. style.project_file("php_cs_fixer", ctx.filename), "$FILENAME" }
        end,
      }
      opts.formatters.pint_default = {
        command = "pint",
        args = function()
          return { "--config", style.default_file("pint"), "$FILENAME" }
        end,
        stdin = false,
        condition = function(_, ctx)
          return not style.php_project_style(ctx.filename) and style.default_file("pint") ~= nil
        end,
      }

      -- Prettier: project config as-is, otherwise --config with the default .prettierrc.json.
      local prettier = opts.formatters.prettier or {}
      prettier.condition = function(_, ctx)
        return style.config_file("prettier", ctx.filename) ~= nil
      end
      prettier.prepend_args = function(_, ctx)
        local file, is_project = style.config_file("prettier", ctx.filename)
        if is_project or not file then
          return {}
        end
        return { "--config", file }
      end
      opts.formatters.prettier = prettier

      -- sqlfluff: no forced dialect, so the project's .sqlfluff (or the default) decides it.
      opts.formatters.sqlfluff = {
        args = function(_, ctx)
          return { "format", "--config", style.config_file("sqlfluff", ctx.filename), "-" }
        end,
        cwd = function(_, ctx)
          return style.root(ctx.filename)
        end,
        require_cwd = false,
        condition = function(_, ctx)
          return style.config_file("sqlfluff", ctx.filename) ~= nil
        end,
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters_by_ft = opts.linters_by_ft or {}

      -- Separate names from nvim-lint's built-in phpcs/phpstan/sqlfluff, because LazyVim merges
      -- overrides into built-in linters by list index, which would mix up their args.
      opts.linters_by_ft.php = { "phpstan_resolved", "phpcs_resolved" }
      for ft, linters in pairs(opts.linters_by_ft) do
        opts.linters_by_ft[ft] = vim.tbl_map(function(name)
          return name == "sqlfluff" and "sqlfluff_resolved" or name
        end, linters)
      end

      opts.linters.phpcs_resolved = {
        cmd = function()
          return style.php_bin("phpcs", bufname())
        end,
        stdin = true,
        args = {
          "-q",
          "--report=json",
          function()
            return "--standard=" .. style.config_file("phpcs", bufname())
          end,
          function()
            return "--stdin-path=" .. bufname()
          end,
          "-",
        },
        ignore_exitcode = true,
        parser = function(...)
          return require("lint.linters.phpcs").parser(...)
        end,
        condition = function(ctx)
          if style.project_file("phpcs", ctx.filename) then
            return true
          end
          -- A project styled with pint/php-cs-fixer owns its style; a default phpcs standard would contradict it.
          return not style.php_project_style(ctx.filename) and style.default_file("phpcs") ~= nil
        end,
      }

      -- phpstan must run from the project root to find the project's autoloader,
      -- so it is started through `sh -c 'cd <root> && exec phpstan ...'`.
      opts.linters.phpstan_resolved = {
        cmd = "sh",
        stdin = false,
        args = {
          "-c",
          'cd "$1" && shift && exec "$@"',
          "sh",
          function()
            return phpstan_root(bufname())
          end,
          function()
            return style.php_bin("phpstan", bufname())
          end,
          "analyse",
          "--error-format=json",
          "--no-progress",
          "--memory-limit=1G",
          function()
            return "--configuration=" .. style.config_file("phpstan", bufname())
          end,
        },
        ignore_exitcode = true,
        parser = phpstan_parser,
        condition = function(ctx)
          return style.config_file("phpstan", ctx.filename) ~= nil
        end,
      }

      opts.linters.sqlfluff_resolved = {
        cmd = "sqlfluff",
        stdin = false,
        args = {
          "lint",
          "--format=json",
          function()
            return "--config=" .. style.config_file("sqlfluff", bufname())
          end,
        },
        ignore_exitcode = true,
        parser = function(...)
          return require("lint.linters.sqlfluff").parser(...)
        end,
        condition = function(ctx)
          return style.config_file("sqlfluff", ctx.filename) ~= nil
        end,
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    -- Global pint and phpstan, used with the defaults when a project has no vendor/bin copy.
    opts = { ensure_installed = { "pint", "phpstan" } },
  },
}
