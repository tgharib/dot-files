-- Don't forget to disable lazy loading when installing new plugin!

return {
  -- Cosmetic
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Regular
  "folke/which-key.nvim",
  "phaazon/hop.nvim",
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end, lazy = false },
  { "junegunn/fzf.vim", lazy = false },
  "natecraddock/sessions.nvim",
  "nmac427/guess-indent.nvim",
  { "dstein64/vim-startuptime", lazy = false },
  "nathom/filetype.nvim",
  { "lambdalisue/suda.vim", lazy = false },
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" }, lazy = false },
  "lewis6991/gitsigns.nvim",
  { "tpope/vim-fugitive", lazy = false },

  -- Dumb code
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  { "ThePrimeagen/refactoring.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
  { "honza/vim-snippets", lazy = false }, -- snippets database
  "simrat39/symbols-outline.nvim",
  { 'echasnovski/mini.cursorword', version = false }, -- highlight word under cursor

  -- Smart code
  { "neoclide/coc.nvim", branch = "release", lazy = false },

  -- C++
  { "Badhi/nvim-treesitter-cpp-tools", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}
