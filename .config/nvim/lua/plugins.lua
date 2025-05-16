-- Don't forget to disable lazy loading when installing new plugin!

return {
  -- Cosmetic
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Regular
  "folke/which-key.nvim",
  { "junegunn/fzf", lazy = false },
  { "junegunn/fzf.vim", lazy = false },
  "natecraddock/sessions.nvim",
  "nmac427/guess-indent.nvim",
  { "dstein64/vim-startuptime", lazy = false },
  "nathom/filetype.nvim",
  { "lambdalisue/suda.vim", lazy = false },
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" }, lazy = false },
  "lewis6991/gitsigns.nvim",
  { "tpope/vim-fugitive", lazy = false },
  { "f-person/auto-dark-mode.nvim", opts = {} },

  -- Doesn't require LSP
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  { "ThePrimeagen/refactoring.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" } },
  { "echasnovski/mini.nvim", version = false },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },

  -- Requires LSP
  { "neoclide/coc.nvim", branch = "release", lazy = false },

  -- C++
  { "Badhi/nvim-treesitter-cpp-tools", dependencies = { "nvim-treesitter/nvim-treesitter" } },

  -- Remote nvim
  {
   "amitds1997/remote-nvim.nvim",
   version = "*", -- Pin to GitHub releases
   dependencies = {
       "nvim-lua/plenary.nvim", -- For standard functions
       "MunifTanjim/nui.nvim", -- To build the plugin UI
       "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
   },
   config = true,
  },
}
