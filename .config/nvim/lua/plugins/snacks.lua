return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true, -- Show hidden files (dotfiles)
          git_ignored = true, -- Show Git-ignored files
          respect_gitignore = false, -- Don't let Git hide files
          allow_patterns = { ".*" }, -- Ensure all files are included
        },
      },
    },
  },
}
