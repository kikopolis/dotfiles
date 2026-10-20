-- Pins for plugins whose latest versions require Neovim 0.12+.
-- Remove these once Neovim is upgraded to 0.12.
return {
  -- aerial master errors with "aerial is deprecated for Neovim <0.12".
  { "stevearc/aerial.nvim", branch = "nvim-0.11" },
  -- refactoring.nvim master requires Neovim 0.12.5 and async.nvim; this is the last
  -- commit supporting 0.10/0.11 with the API the LazyVim refactoring extra uses.
  { "ThePrimeagen/refactoring.nvim", commit = "74b608dfee827c2372250519d433cc21cb083407" },
}
