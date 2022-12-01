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
  use 'natecraddock/sessions.nvim'
  use 'machakann/vim-sandwich' -- replace surrounding brackets/parentheses
  use { 'ojroques/vim-oscyank', branch = 'main' }
  use { 'nmac427/guess-indent.nvim', config = function() require('guess-indent').setup {} end }

  -- Dumb code
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-treesitter/nvim-treesitter-context' }
  use { 'nvim-treesitter/nvim-treesitter-refactor' } -- used for treesitter highlight
  use { 'ThePrimeagen/refactoring.nvim', requires = { {'nvim-lua/plenary.nvim'}, {'nvim-treesitter/nvim-treesitter'} } }
  use 'honza/vim-snippets' -- snippets database
  use 'simrat39/symbols-outline.nvim'

  -- Smart code
  use { 'neoclide/coc.nvim', branch = 'release' }

  -- C++
  use { requires = { 'nvim-treesitter/nvim-treesitter' }, 'Badhi/nvim-treesitter-cpp-tools', }
end)
