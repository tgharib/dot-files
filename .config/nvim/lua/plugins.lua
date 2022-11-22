return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Cosmetic
  use 'overcache/NeoSolarized'
  use 'itchyny/lightline.vim'

  -- Regular
  use 'folke/which-key.nvim'
  use 'phaazon/hop.nvim'
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets' -- Snippets database
  use 'natecraddock/sessions.nvim'
  use 'machakann/vim-sandwich' -- Replace surrounding brackets/parentheses
  use { 'ojroques/vim-oscyank', branch = 'main' }

  -- Dumb code
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-context' }

  -- Smart code
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- C++
  use { requires = { "nvim-treesitter/nvim-treesitter" }, "Badhi/nvim-treesitter-cpp-tools", }
end)