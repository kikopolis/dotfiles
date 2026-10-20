-- PHP formatters and linters (pint, php-cs-fixer, phpcs, phpstan) are configured in style.lua.
return {
  {
    -- Installs php-debug-adapter and sets up the "Listen for Xdebug" (port 9003) configuration.
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = {
      ensure_installed = { "php" },
    },
  },
  {
    -- Class-level PHP refactorings (import class, generate constructor, move class, ...).
    -- Uses the Mason phpactor binary for RPC only; intelephense stays the LSP.
    "gbprod/phpactor.nvim",
    ft = "php",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      install = {
        -- phpactor.nvim runs `php <bin>`, so this must be the phar, not Mason's bash wrapper in mason/bin.
        bin = vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
        check_on_startup = "none",
      },
      lspconfig = { enabled = false },
    },
    keys = {
      { "<leader>P", "", desc = "+phpactor", ft = "php" },
      { "<leader>Pm", "<cmd>PhpActor context_menu<cr>", desc = "Context Menu", ft = "php" },
      { "<leader>Pi", "<cmd>PhpActor import_class<cr>", desc = "Import Class", ft = "php" },
      { "<leader>PI", "<cmd>PhpActor import_missing_classes<cr>", desc = "Import Missing Classes", ft = "php" },
      { "<leader>Pt", "<cmd>PhpActor transform<cr>", desc = "Transform", ft = "php" },
      { "<leader>Pa", "<cmd>PhpActor generate_accessor<cr>", desc = "Generate Accessor", ft = "php" },
      { "<leader>Pn", "<cmd>PhpActor new_class<cr>", desc = "New Class", ft = "php" },
      { "<leader>Pv", "<cmd>PhpActor move_class<cr>", desc = "Move Class", ft = "php" },
      { "<leader>Pc", "<cmd>PhpActor copy_class<cr>", desc = "Copy Class", ft = "php" },
      { "<leader>Pe", "<cmd>PhpActor expand_class<cr>", desc = "Expand Class Name", ft = "php" },
      { "<leader>Px", "<cmd>PhpActor change_visibility<cr>", desc = "Change Visibility", ft = "php" },
      { "<leader>Pf", "<cmd>PhpActor copy_fcqn<cr>", desc = "Copy FQCN", ft = "php" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "phpactor" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade", "vue" } },
  },
  -- neotest-pest and neotest-phpunit are configured by the lazyvim.plugins.extras.lang.php extra.
}
