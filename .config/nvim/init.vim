" For editing multiple lines in vim, use 1. `V:! sd` 2. macros 3. `V:norm`.
" Vim motion options: f/F/t/T for horizontal, <CR> for vertical, */#, search, goto definition, ripgrep
" Paste text vertically using visual block mode https://stackoverflow.com/a/27542895

" Options
let mapleader = " "
set nowrap " Turn off line wrap
set nohlsearch " Turn off search highlighting
set clipboard=unnamedplus " Use system clipboard for copy and paste
set ignorecase " Search with smart case
set smartcase " Search with smart case
set timeoutlen=0 " Immediately show which-key
let $BASH_ENV = "~/.bash-aliases"
set sessionoptions=buffers " Session = buffers only (to avoid bugs with abduco)
set hidden " Allow buffers to be hidden without saving
set number " Enable line numbers by default
set expandtab " Spaces-only indenation https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd
set softtabstop=-1 " Spaces-only indenation
syntax off " Rely on treesitter only for syntax highlighting
let g:suda_smart_edit = 1 " suda.nvim smart write
set mouse= " Disable mouse support

"" Don't touch unnamed register when pasting over visual selection
xnoremap p P

"" bootstrap lazy.nvim
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true, -- should plugins be lazy-loaded?
  },
})
EOF

"" Set colorscheme
lua << EOF
require("tokyonight").setup({
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
  },
})
EOF
colorscheme tokyonight
set termguicolors " Force colorscheme colors with 24-bit support

"" Highlight unwanted characters (whitespace, unicode)
"" https://vi.stackexchange.com/a/29458
"" https://superuser.com/a/211965

augroup HighlightUnwanted
  autocmd!

  highlight extrawhitespace ctermbg=red guibg=red
  match extrawhitespace /\s\+$\| \+\ze\t/

  highlight nonascii ctermbg=red guibg=red
  2match nonascii "[^\x00-\x7F]"
augroup END

"" Auto-reload file changes outside of vim
augroup autoreload
  autocmd!
  """ trigger `autoread` when files changes on disk
  set autoread
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  """ notification after file change
  autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup end

"" Markdown macros
let @i ="o![](images/){width=60%}\<Esc>11hi"
let @e ="o$$\<Enter>$$\<Esc>O"

"" Restore cursor to position in file from last time file was opened
lua << EOF
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})
EOF

" Helper functions
augroup helper_funcs
  autocmd!
  "" Trim trailing whitespace function
  function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endfunction
augroup end

" Plugins

"" auto-dark-mode.nvim
lua << EOF
require("auto-dark-mode").setup()
EOF

"" aerial.nvim
lua << EOF
require("aerial").setup({
  layout = {
    default_direction = "left",
  },
  manage_folds = true,
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  open_automatic = false,
  disable_max_lines = 50000,
  disable_max_size = 2000000, -- 2MB
  -- set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})
EOF

"" remote-nvim.nvim
lua << EOF
require("remote-nvim").setup({
  client_callback = function(port, _)
    require("remote-nvim.ui").float_term(("kitty nvim --server localhost:%s --remote-ui"):format(port), function(exit_code)
      if exit_code ~= 0 then
        vim.notify(("Local client failed with exit code %s"):format(exit_code), vim.log.levels.ERROR)
      end
    end)
  end,
})
EOF

"" gitsigns.nvim
lua << EOF
require('gitsigns').setup {}
EOF

"" mini.nvim

" mini.align: gA to start, s for split pattern, t for trimming whitespace
" https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-align.txt

" mini.cursorword: highlight word under cursor

" mini.bufremove: close windows while saving window layout

" mini.jump2d: hop.nvim clone

lua << EOF
require('mini.align').setup()
require('mini.cursorword').setup()
require('mini.bufremove').setup()
require('mini.jump2d').setup({
  view = {
    dim = true,
    n_steps_ahead = 10,
  },
  mappings = {
    start_jumping = '',
  },
})
EOF

"" guess-indent.nvim
lua << EOF
require('guess-indent').setup()
EOF

"" refactoring.nvim
lua << EOF
require('refactoring').setup()
EOF

"" sessions.nvim
lua << EOF
require("sessions").setup()
EOF

"" nvim-treesitter
""" Do NOT use treesitter for folding as it cannot be disabled for large files
lua << EOF
disable_for_large_files = function(lang, bufnr) -- Disable in large buffers
  return vim.api.nvim_buf_line_count(bufnr) > 50000
end

require'nvim-treesitter.configs'.setup {
  -- Install all languages for treesitter except for rnoweb, phpdoc
  ensure_installed = { "bash", "beancount", "c", "cmake", "comment", "cpp", "dockerfile", "glsl", "java", "lua", "make", "markdown", "ninja", "nix", "python", "rust", "verilog" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = disable_for_large_files,
    additional_vim_regex_highlighting = false,
  },
  -- nvim-treesitter-cpp-tools
  nt_cpp_tools = {
      enable = true,
      preview = {
          quit = '<Esc>',
          accept = '<CR>'
      },
  }
}

-- nvim-treesitter-context
require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      disable = disable_for_large_files,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },
  },
}
EOF

"" which-key.nvim
" Some coc commands can be found in:
" https://github.com/neoclide/coc.nvim/blob/master/data/schema.json
" https://github.com/neoclide/coc.nvim/blob/master/doc/coc-config.txt
lua << EOF
require("which-key").setup {
}
local wk = require("which-key")
wk.add({
  { "<CR>", ":lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  { "<leader>b", group = "buffers" },
  { "<leader>bQ", ":bufdo bw<CR>", desc = "quit all buffers" },
  { "<leader>bb", ":Buffers<CR>", desc = "select buffer" },
  { "<leader>bf", ":Files<CR>", desc = "open file" },
  { "<leader>bl", ":SessionsLoad! ", desc = "load session" },
  { "<leader>bq", ":lua MiniBufremove.wipeout()<CR>", desc = "quit current buffer" },
  { "<leader>bs", ":SessionsSave! ", desc = "save session" },
  { "<leader>bt", ":tabonly<CR>", desc = "tabs -> buffers" },
  { "<leader>f", group = "fix error" },
  { "<leader>fe", ":<C-u>CocList diagnostics<CR>", desc = "list errors/diagnostics (coc)" },
  { "<leader>fl", "<Plug>(coc-fix-current)", desc = "fix error on current line (coc)" },
  { "<leader>g", group = "go to" },
  { "<leader>gs", "<Plug>(coc-implementation)", desc = "go to subclasses (coc)" },
  { "<leader>gd", "<Plug>(coc-definition)", desc = "go to definition (coc)" },
  { "<leader>gg", ":CocCommand clangd.switchSourceHeader<CR>", desc = "go to source/header (coc)" },
  { "<leader>gr", "<Plug>(coc-references)", desc = "go to references (coc)" },
  { "<leader>gt", "<Plug>(coc-type-definition)", desc = "go to type definition (coc)" },
  { "<leader>k", ":call ShowDocumentation()<CR>", desc = "show documentation (coc)" },
  { "<leader>p", group = "paths" },
  { "<leader>pc", ":cd %:h<CR>", desc = "cd into current buffer working directory" },
  { "<leader>pf", ":echo expand('%:p')<CR>", desc = "show file path" },
  { "<leader>po", ":Oil<CR>", desc = "oil (file manager)" },
  { "<leader>r", group = "refactor/transform" },
  { "<leader>rf", ":call CocActionAsync('format')<CR>", desc = "format buffer (coc)" },
  { "<leader>ro", ":call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>", desc = "organize imports (coc)" },
  { "<leader>rp", group = "print debug" },
  { "<leader>rpc", ":lua require('refactoring').debug.cleanup({})<CR>", desc = "cleanup (refactoring.nvim)" },
  { "<leader>rpl", ":lua require('refactoring').debug.printf({below = true})<CR>", desc = "print line (refactoring.nvim)" },
  { "<leader>rpv", ":lua require('refactoring').debug.print_var()<CR>", desc = "print variable (refactoring.nvim)" },
  { "<leader>rz", ":lua require('refactoring').select_refactor({prefer_ex_cmd = true}) <CR>", desc = "refactoring.nvim prompts" },
  { "<leader>rr", "<Plug>(coc-rename)", desc = "rename symbol (coc)" },
  { "<leader>rw", group = "whitespace" },
  { "<leader>rw2", ":set tabstop=2 shiftwidth=2 | set expandtab | set softtabstop=-1<CR>", desc = "set tabs to 2 spaces" },
  { "<leader>rw4", ":set tabstop=4 shiftwidth=4 | set expandtab | set softtabstop=-1<CR>", desc = "set tabs to 4 spaces" },
  { "<leader>rwr", ":retab<CR>", desc = "replace tabs with spaces" },
  { "<leader>rwt", ":call TrimWhitespace()<CR>", desc = "trim whitespace" },
  { "<leader>s", group = "search" },
  { "<leader>sD", "<cmd>AerialToggle!<CR>", desc = "open document outline in split window" },
  { "<leader>sS", ":<C-u>CocList -I symbols<CR>", desc = "search symbol in workspace (coc)" },
  { "<leader>sT", ":Lines!<CR>", desc = "search text in all buffers" },
  { "<leader>sc", ":let @/ = \"\"<CR>", desc = "clear search buffer" },
  { "<leader>sd", ":CocOutline<CR>", desc = "open document outline in split window (coc)" },
  { "<leader>sr", ":Rg! ", desc = "rg text in current working directory" },
  { "<leader>ss", ":<C-u>CocList outline<CR>", desc = "search symbol in document outline (coc)" },
  { "<leader>st", ":BLines!<CR>", desc = "search text in current buffer" },
  { "<leader>t", group = "toggles" },
  { "<leader>td", ":Gitsigns toggle_signs<CR>", desc = "toggle git diff signs" },
  { "<leader>th", ":set hlsearch!<CR>", desc = "toggle search highlight" },
  { "<leader>tl", ":set number!<CR>", desc = "toggle line numbers" },
  { "<leader>tn", ":TSContext toggle<CR>", desc = "toggle context (nested statements)" },
  { "<leader>tt", ":CocCommand document.toggleInlayHint<CR>", desc = "toggle inlay hints (coc)" },
  { "<leader>tw", ":set wrap!<CR>", desc = "toggle line wrap" },
  })
wk.add({
  {
  mode = { "x" },
  { "<CR>", ":lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  { "<leader>r", group = "refactor/transform" },
  { "<leader>r3", ":TSCppRuleOf3<CR>", desc = "modify class to obey Rule of 3 (nvim-treesitter-cpp)" },
  { "<leader>r5", ":TSCppRuleOf5<CR>", desc = "modify class to obey Rule of 5 (nvim-treesitter-cpp)" },
  { "<leader>rm", ":TSCppDefineClassFunc<CR>", desc = "implement class member functions (nvim-treesitter-cpp)" },
  { "<leader>rp", ":TSCppMakeConcreteClass<CR>", desc = "implement pure virtual functions (nvim-treesitter-cpp)" },
  { "<leader>rz", ":lua require('refactoring').select_refactor({prefer_ex_cmd = true}) <CR>", desc = "refactoring.nvim prompts" },
  },
  })
wk.add({
  {
  mode = { "o" },
  { "<CR>", ":lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  },
  })
EOF

" :nmap - Display normal mode maps
" :imap - Display insert mode maps
" :vmap - Display visual and select mode maps
" :smap - Display select mode maps <-- select mode is never used
" :xmap - Display visual mode maps
" :cmap - Display command-line mode maps i.e. after pressing :
" :omap - Display operator pending mode maps e.g. deletion after pressing d

" For Rust, as per https://github.com/neoclide/coc.nvim/wiki/Language-servers#rust, rust-analyzer binary needs to be compiled from source
let g:coc_global_extensions = ['coc-clangd', 'coc-pyright', 'coc-rust-analyzer']
"" COC START
set nobackup " Some servers have issues with backup files, see #649.
set nowritebackup
set updatetime=300 " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set signcolumn=number " Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.

""" Use tab for trigger completion with characters ahead and navigate. NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

""" Make <CR> to accept selected completion item or notify coc.nvim to format. <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh() " Use <c-space> to trigger completion

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

augroup coc_signature
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp') " Update signature help on jump placeholder
augroup end

" Remap <C-f> and <C-b> to scroll floating windows/popups (such as when
" showing a coc documentation popup)
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

lua << END
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END

"" COC END
