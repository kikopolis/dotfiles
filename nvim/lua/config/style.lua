-- Resolves which config file a formatter/linter should use for a buffer:
--   1. the nearest project config file (searched upward from the file), otherwise
--   2. a default from ~/.config/nvim/style-defaults/, if that file exists, otherwise
--   3. nothing, and the tool is skipped.
local M = {}

M.defaults_dir = vim.fn.stdpath("config") .. "/style-defaults"

-- Project config file names per tool, in the order the tools themselves look for them.
M.files = {
  pint = { "pint.json" },
  php_cs_fixer = { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" },
  phpcs = { "phpcs.xml", ".phpcs.xml", "phpcs.xml.dist", ".phpcs.xml.dist" },
  phpstan = { "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" },
  prettier = {
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.ts",
    ".prettierrc.cts",
    ".prettierrc.mts",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
    "prettier.config.cts",
    "prettier.config.mts",
  },
  sqlfluff = { ".sqlfluff" },
}

-- Default file name in style-defaults/ per tool.
M.default_names = {
  pint = "pint.json",
  phpcs = "phpcs.xml",
  phpstan = "phpstan.neon",
  prettier = ".prettierrc.json",
  sqlfluff = ".sqlfluff",
}

---@param path string a file or directory
local function dir_of(path)
  return vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
end

---@param names string[]
---@param path string
---@return string?
function M.find_upward(names, path)
  return vim.fs.find(names, { path = dir_of(path), upward = true, stop = vim.uv.os_homedir() })[1]
end

---@param tool string key of M.files
---@param path string
---@return string? nearest project config file for the tool
function M.project_file(tool, path)
  local found = M.find_upward(M.files[tool], path)
  if found or tool ~= "prettier" then
    return found
  end
  -- Prettier can also be configured with a "prettier" key in package.json.
  local pkg = M.find_upward({ "package.json" }, path)
  if pkg then
    local ok, json = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
    if ok and type(json) == "table" and json.prettier ~= nil then
      return pkg
    end
  end
end

---@param tool string key of M.default_names
---@return string? default config file, only if it exists
function M.default_file(tool)
  local name = M.default_names[tool]
  local file = name and (M.defaults_dir .. "/" .. name)
  return file and vim.uv.fs_stat(file) and file or nil
end

---@param tool string
---@param path string
---@return string? file, boolean? is_project
function M.config_file(tool, path)
  local project = M.project_file(tool, path)
  if project then
    return project, true
  end
  return M.default_file(tool), false
end

---@param path string
---@return string project root (nearest composer.json/package.json/.git), or the file's directory
function M.root(path)
  local marker = M.find_upward({ "composer.json", "package.json", ".git" }, path)
  return marker and vim.fs.dirname(marker) or dir_of(path)
end

---@param path string
---@return boolean whether the project defines its own PHP code style (with any of the PHP style tools)
function M.php_project_style(path)
  return M.project_file("pint", path) ~= nil
    or M.project_file("php_cs_fixer", path) ~= nil
    or M.project_file("phpcs", path) ~= nil
    or M.find_upward({ "vendor/bin/pint" }, path) ~= nil
end

---@param name string executable name in the project's vendor/bin
---@param path string
---@return string project's vendor/bin/<name> if present, otherwise <name> from PATH (Mason)
function M.php_bin(name, path)
  return M.find_upward({ "vendor/bin/" .. name }, path) or name
end

return M
