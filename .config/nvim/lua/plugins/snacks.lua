return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
  },
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
      },
    },
    -- explorer = { enabled = false },
  },
}
