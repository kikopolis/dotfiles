-- <leader>n is taken by LazyVim (notification history), so package-info lives under <leader>k.
return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufRead package.json" },
    opts = {},
    keys = {
      { "<leader>k", "", desc = "+packages", ft = "json" },
      { "<leader>kt", "<cmd>PackageInfoToggle<cr>", desc = "Toggle Versions", ft = "json" },
      { "<leader>ks", "<cmd>PackageInfoShowForce<cr>", desc = "Show Latest Versions", ft = "json" },
      { "<leader>ku", "<cmd>PackageInfoUpdate<cr>", desc = "Update Package", ft = "json" },
      { "<leader>kd", "<cmd>PackageInfoDelete<cr>", desc = "Delete Package", ft = "json" },
      { "<leader>ki", "<cmd>PackageInfoInstall<cr>", desc = "Install Package", ft = "json" },
      { "<leader>kv", "<cmd>PackageInfoChangeVersion<cr>", desc = "Change Version", ft = "json" },
    },
  },
}
