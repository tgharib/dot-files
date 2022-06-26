" Automatically install Vim-Plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'overcache/NeoSolarized'
Plug 'itchyny/lightline.vim'
Plug 'folke/which-key.nvim'
Plug 'phaazon/hop.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
syntax off " Vim-Plug enables vim's syntax highlighting but we use treesitter instead

""""" Options
let mapleader = " "
set nowrap " Turn off line wrap
set nohlsearch " Turn off search highlighting
set clipboard=unnamedplus " Use system clipboard for copy and paste
set ignorecase " Search with smart case
set smartcase " Search with smart case
set timeoutlen=0 " Immediately show which-key
set noshowmode " Hide mode prompt (insert, etc) since we are using lightline

" Set colorscheme to NeoSolarized
colorscheme NeoSolarized
set background=dark
" Force colorscheme colors with 24-bit support
set termguicolors

""""" Markdown macros
let @i ="o![](images/.png){width=60%}\<Esc>15hi"
let @e ="o$$\<Enter>$$\<Esc>O"

""""" Helper functions
" Trim trailing whitespace function
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

""""" Plugins

" Hop
lua << EOF
require'hop'.setup()
EOF

" " Treesitter
" Fold based on treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" Unfold all by default
set foldlevel=99
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "vim", "bash", "latex", "nix", "c", "cmake", "cpp", "rust", "verilog", "python" },
  sync_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF

" symbols-outline
lua << EOF
vim.g.symbols_outline = {
    highlight_hovered_item = false,
    auto_preview = false,
    position = 'left',
}
EOF

" fzf.nvim
command! -bang -nargs=* Rgi call fzf#vim#grep('rg -i --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

" Which-key
lua << EOF
require("which-key").setup {
}
local wk = require("which-key")
wk.register({
  f = {
    name = "fzf",
    f = { ":Files<cr>", "fzf files" },
    g = { ":GFiles<cr>", "fzf git files" },
    b = { ":Buffers<cr>", "fzf buffers" },
    r = { ":Rg! ", "rg" },
    i = { ":Rgi! ", "rg -i" },
  },
  w = {
    name = "fix whitespace",
    r = { ":retab<cr>", "replace tabs with spaces" },
    ["2"] = { ":setlocal expandtab ts=2 sw=2<cr>", "set tabs to 2 spaces" },
    ["4"] = { ":setlocal expandtab ts=4 sw=4<cr>", "set tabs to 4 spaces" },
    t = { ":call TrimWhitespace()<cr>", "trim whitespace" },
  },
  m = {
    name = "misc",
    w = { ":set wrap!<cr>", "toggle line wrap" },
    l = { ":set number!<cr>", "toggle line numbers" },
    s = { ":SymbolsOutlineOpen<cr>", "toggle symbols outline" },
    t = { ":tabonly<CR>", "tabs --> buffers" },
    o = { ":w <bar> %bd <bar> e# <bar> bd# <CR>", "close all buffers except current" },
  },
  c = {
    name = "coc",
    n = {
      name = "navigation",
      d = { "<Plug>(coc-definition)", "go to definition" },
      t = { "<Plug>(coc-type-definition)", "go to type definition" },
      i = { "<Plug>(coc-implementation)", "go to implementation" },
      r = { "<Plug>(coc-references)", "go to references" },
      o = { ":<C-u>CocList outline<cr>", "go to symbol in document outline" },
      w = { ":<C-u>CocList -I symbols<cr>", "go to symbol in workspace" },
    },
    a = {
      name = "actions",
      s = { "<Plug>(coc-codeaction-selected)", "code action on selected" },
      b = { "<Plug>(coc-codeaction)", "code action on current buffer" },
      q = { "<Plug>(coc-fix-current)", "quick fix on current line" },
      l = { "<Plug>(coc-codelens-action)", "codelens action on current line" },
    },
    d = {
      name = "diagnostics",
      d = { ":<C-u>CocList diagnostics<cr>", "show all diagnostics" },
      ["["] = { "<Plug>(coc-diagnostic-prev)", "quick-navigate previous diagnostic" },
      ["]"] = { "<Plug>(coc-diagnostic-next)", "quick-navigate next diagnostic" },
    },
    s = {
      name = "select",
      i = { "<Plug>(coc-funcobj-i)", "select inner function" },
      f = { "<Plug>(coc-funcobj-a)", "select all function" },
      n = { "<Plug>(coc-classobj-i)", "select inner class" },
      c = { "<Plug>(coc-classobj-a)", "select all class" },
    },
    r = { "<Plug>(coc-rename)", "rename symbol" },
    o = { ":call ShowDocumentation()<cr>", "show documentation" },
  },
  j = { "<cmd>lua require'hop'.hint_words()<cr>", "jump cursor to word" },
}, { prefix = "<leader>", mode = "n" })
wk.register({
  c = {
    name = "coc",
    s = {
      name = "select",
      i = { "<Plug>(coc-funcobj-i)", "select inner function" },
      f = { "<Plug>(coc-funcobj-a)", "select all function" },
      n = { "<Plug>(coc-classobj-i)", "select inner class" },
      c = { "<Plug>(coc-classobj-a)", "select all class" },
    },
    a = {
      name = "actions",
      s = { "<Plug>(coc-codeaction-selected)", "code action on selected" },
    },
  },
  j = { "<cmd>lua require'hop'.hint_words()<cr>", "jump cursor to word" },
}, { prefix = "<leader>", mode = "o" })

wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "jump in line (before cursor)" },
}, { prefix = "", mode = "n" })
wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", "jump in line (before cursor)" },
}, { prefix = "", mode = "o" })
EOF

" COC START
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <cr> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<cr>"

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

let g:lightline = {
\ 'colorscheme': 'solarized',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
\ },
\ 'component_function': {
\   'cocstatus': 'coc#status'
\ },
\ }

" use autocmd to force lightline update.
autocmd user cocstatuschange,cocdiagnosticchange call lightline#update()

" COC END

" highlight trailing whitespace (at the end after colorscheme)
highlight extrawhitespace ctermbg=red guibg=red
match extrawhitespace /\s\+$\| \+\ze\t/
