-- <leader>l is taken by LazyVim (:Lazy), so Laravel lives under <leader>j.
return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    keys = {
      { "<leader>j", "", desc = "+laravel" },
      { "<leader>jj", function() Laravel.pickers.laravel() end, desc = "Laravel Picker" },
      { "<leader>ja", function() Laravel.pickers.artisan() end, desc = "Artisan" },
      { "<leader>jr", function() Laravel.pickers.routes() end, desc = "Routes" },
      { "<leader>jm", function() Laravel.pickers.make() end, desc = "Make" },
      { "<leader>jc", function() Laravel.pickers.commands() end, desc = "Custom Commands" },
      { "<leader>jo", function() Laravel.pickers.resources() end, desc = "Resources" },
      { "<leader>jv", function() Laravel.commands.run("view:finder") end, desc = "View Finder" },
      { "<leader>jt", function() Laravel.commands.run("actions") end, desc = "Code Actions" },
      { "<leader>ju", function() Laravel.commands.run("hub") end, desc = "Artisan Hub" },
      { "<leader>jp", function() Laravel.commands.run("command_center") end, desc = "Command Center" },
      { "<leader>jh", function() Laravel.run("artisan docs") end, desc = "Documentation" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        ft = { "php", "blade" },
        desc = "Laravel: Go to resource",
      },
    },
    opts = {
      features = {
        pickers = { provider = "snacks" },
      },
    },
  },
  {
    -- gf on views/components/routes in Blade and PHP, plus completion for their names.
    "ricardoramirezr/blade-nav.nvim",
    ft = { "blade", "php" },
    opts = {
      -- Completion goes through blink.cmp (provider below); skip the nvim-cmp/coq setup and its warning.
      integrations = { cmp = false, coq = false },
      -- Keep K as LSP hover.
      annotations = { create_keymaps = false },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          blade = { inherit_defaults = true, "blade-nav" },
          php = { inherit_defaults = true, "blade-nav" },
        },
        providers = {
          ["blade-nav"] = {
            name = "blade-nav",
            module = "blade-nav.integrations.blink",
          },
        },
      },
    },
  },
}
