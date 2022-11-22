" For editing multiple lines in vim, use a combination of `V:! sd` and macros. Occasionally, use `V:norm` and `V:norm@a` (a is a macro) but they do not work well when new lines are added. For scripts, use sd from CLI.
" Vim motion options: f/F for horizontal, C-j/C-k for vertical, /n*, dumb code navigation, smart code navigation

" Options
let mapleader = " "
set nowrap " Turn off line wrap
set nohlsearch " Turn off search highlighting
set clipboard=unnamedplus " Use system clipboard for copy and paste
set ignorecase " Search with smart case
set smartcase " Search with smart case
set timeoutlen=0 " Immediately show which-key
set noshowmode " Hide mode prompt (insert, etc) since we are using lightline
let $BASH_ENV = "~/.bash-aliases"
set sessionoptions=buffers " Session = buffers only (to avoid bugs with abduco)
set hidden " Allow buffers to be hidden without saving
set number " Enable line numbers by default
syntax off " Rely on treesitter only for syntax highlighting

"" Set colorscheme to NeoSolarized
colorscheme NeoSolarized
set background=dark
set termguicolors " Force colorscheme colors with 24-bit support

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
let @i ="o![](images/.png){width=60%}\<Esc>15hi"
let @e ="o$$\<Enter>$$\<Esc>O"

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

"" packer.nvim
""" Bootstrap
lua << EOF
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
end)
EOF
""" Enable packer
lua require('plugins')

"" refactoring.nvim
lua << EOF
require('refactoring').setup({})
EOF

"" vim-oscyank
augroup ssh_yank
  autocmd!
  autocmd TextYankPost * if v:event.operator is 'y' || v:event.operator is 'd' | execute 'OSCYankReg "' | endif
augroup end

"" sessions.nvim
lua << EOF
require("sessions").setup()
EOF

"" vim-sandwich
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

"" hop.nvim
lua << EOF
require'hop'.setup()
EOF

"" Ultisnips
""" Trigger configuration. You need to change this to something other than <tab> if you use YouCompleteMe or completion-nvim
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"" nvim-treesitter
""" Do NOT use treesitter for folding as it cannot be disabled for large files
lua << EOF
disable_for_large_files = function(lang, bufnr) -- Disable in large buffers
  return vim.api.nvim_buf_line_count(bufnr) > 50000
end

require'nvim-treesitter.configs'.setup {
  -- Install all languages for treesitter except for rnoweb, phpdoc
  ensure_installed = { "astro", "bash", "beancount", "bibtex", "c", "c_sharp", "clojure", "cmake", "comment", "commonlisp", "cooklang", "cpp", "css", "cuda", "d", "dart", "devicetree", "dockerfile", "dot", "eex", "elixir", "elm", "elvish", "embedded_template", "erlang", "fennel", "fish", "foam", "fortran", "fusion", "gdscript", "gleam", "glimmer", "glsl", "go", "godot_resource", "gomod", "gowork", "graphql", "hack", "haskell", "hcl", "heex", "help", "hjson", "hocon", "html", "http", "java", "javascript", "jsdoc", "json", "json5", "jsonc", "julia", "kotlin", "lalrpop", "latex", "ledger", "llvm", "lua", "m68k", "make", "markdown", "ninja", "nix", "norg", "ocaml", "ocaml_interface", "ocamllex", "org", "pascal", "perl", "php", "pioasm", "prisma", "proto", "pug", "python", "ql", "qmljs", "query", "r", "rasi", "regex", "rego", "rst", "ruby", "rust", "scala", "scheme", "scss", "slint", "solidity", "sparql", "sql", "supercollider", "surface", "svelte", "swift", "teal", "tiger", "tlaplus", "todotxt", "toml", "tsx", "turtle", "typescript", "v", "vala", "verilog", "vim", "vue", "wgsl", "yaml", "yang", "zig" },
  sync_install = false,
  highlight = {
    enable = true,
    disable = disable_for_large_files,
    additional_vim_regex_highlighting = false,
  },
  -- nvim-treesitter-cpp-tools
  nt_cpp_tools = {
      enable = true,
      preview = {
          quit = 'q', -- optional keymapping for quit preview
          accept = '<tab>' -- optional keymapping for accept preview
      },
  }
}

-- nvim-treesitter-context
require'treesitter-context'.setup {
  enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    default = { 'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case' },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- The options below are exposed but shouldn't require your attention, you can safely ignore them.
  zindex = 20, -- The Z-index of the context window
  mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
EOF

"" symbols-outline.nvim
lua << EOF
vim.g.symbols_outline = {
    highlight_hovered_item = false,
    auto_preview = false,
    position = 'left',
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
wk.register({
  s = {
    name = "smart code (coc)",
    n = {
      name = "navigation",
      d = { "<Plug>(coc-definition)", "go to definition" },
      D = { "<Plug>(coc-implementation)", "go to implementation" },
      o = { ":<C-u>CocList outline<CR>", "search symbol in document outline" },
      O = { ":<C-u>CocList -I symbols<CR>", "search symbol in workspace" },
      r = { "<Plug>(coc-references)", "go to references" },
      t = { "<Plug>(coc-type-definition)", "go to type definition" },
      n = { ":CocCommand clangd.switchSourceHeader<CR>", "go to source/header" },
    },
    a = {
      name = "actions",
      l = { "<Plug>(coc-fix-current)", "quick fix on current line" },
      s = { "<Plug>(coc-codeaction-selected)", "code action on selected" },
      b = { "<Plug>(coc-codeaction)", "code action on current buffer" },
    },
    f = { ":call CocActionAsync('format')<CR>", "format buffer" },
    l = { ":<C-u>CocList diagnostics<CR>", "list diagnostics" },
    r = { "<Plug>(coc-rename)", "rename symbol" },
    s = { ":call ShowDocumentation()<CR>", "show documentation" },
    o = { ":call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>", "organize imports" },
    t = { ":CocCommand document.toggleInlayHint<CR>", "toggle inlay hints" },
  },
  d = {
    name = "dumb code",
    n  = {
      name = "navigation",
      r = { ":Rg! ", "rg" },
      b = { ":BLines<CR>", "search in current buffer" },
      B = { ":Lines<CR>", "search in all buffers" },
    },
    s = { ":Snippets<CR>", "snippets" },
    c = { ":TSContextToggle<CR>", "toggle context" },
  },
  c = {
    name = "c++ refactor",
    r = { "<Plug>(coc-rename)", "rename symbol (repeat)" },
  },
  b = {
    name = "buffers",
    f = { ":Files<CR>", "open file" },
    b = { ":Buffers<CR>", "select buffer" },
    c = { ":bw<CR>", "close current buffer :bw" },
    C = { ":bufdo bw<CR>", "close all buffers :bufdo bw" },
    t = { ":tabonly<CR>", "tabs -> buffers" },
    l = { ":SessionsLoad! ", "load session" },
    s = { ":SessionsSave! ", "save session" },
  },
  w = {
    name = "fix whitespace",
    r = { ":retab<CR>", "replace tabs with spaces" },
    ["2"] = { ":setlocal expandtab ts=2 sw=2<CR>", "set tabs to 2 spaces" },
    ["4"] = { ":setlocal expandtab ts=4 sw=4<CR>", "set tabs to 4 spaces" },
    t = { ":call TrimWhitespace()<CR>", "trim whitespace" },
  },
  m = {
    name = "misc",
    w = { ":set wrap!<CR>", "toggle line wrap" },
    l = { ":set number!<CR>", "toggle line numbers" },
    ["?"] = { ":Commands<CR>", "vim commands" },
    k = { ":help index<CR>", "vim keybinds" },
    K = { ":map<CR>", "vim mapped keybinds" },
    v = { ":Colors<CR>", "vim color schemes" },
    f = { ":echo expand('%:p')<CR>", "show file path" },
    h = { ":set hlsearch!<CR>", "toggle search highlight" },
    a = { "<Plug>(operator-sandwich-add)", "add surroundings" },
    d = { "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "delete surroundings (automatic)" },
    D = { "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "delete surroundings" },
    r = { "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)", "replace surroundings (automatic)" },
    R = { "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)", "replace surroundings" },
  },
}, { prefix = "<leader>", mode = "n" })
wk.register({
  s = {
    name = "smart code (coc)",
    f = { "<Plug>(coc-format-selected)", "format buffer" },
    a = {
      name = "actions",
      s = { "<Plug>(coc-codeaction-selected)", "code action on selected" },
    },
  },
  c = {
    name = "c++ refactor",
    ["1"] = { ":TSCppDefineClassFunc<CR>", "Implement out of class member functions" },
    ["2"] = { ":TSCppMakeConcreteClass<CR>", "Implement all the pure virtual functions" },
    ["3"] = { ":TSCppRuleOf3<CR>", "Modify class to obey Rule of 3" },
    ["4"] = { ":TSCppRuleOf5<CR>", "Modify class to obey Rule of 5" },
    s = { "<Plug>(coc-codeaction-selected)", "code action on selected (repeat)" },
  },
}, { prefix = "<leader>", mode = "x" })

wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
  t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>", "jump in line (after cursor)" },
  T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>", "jump in line (before cursor)" },
  ["<C-j>"] = { "2j", "move cursor down two lines" },
  ["<C-k>"] = { "2k", "move cursor up two lines" },
}, { prefix = "", mode = "n" })
wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
  t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>", "jump in line (after cursor)" },
  T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>", "jump in line (before cursor)" },
}, { prefix = "", mode = "o" })
wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
  t = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<CR>", "jump in line (after cursor)" },
  T = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<CR>", "jump in line (before cursor)" },
}, { prefix = "", mode = "x" })
EOF

" :nmap - Display normal mode maps
" :imap - Display insert mode maps
" :vmap - Display visual and select mode maps
" :smap - Display select mode maps <-- select mode is never used
" :xmap - Display visual mode maps
" :cmap - Display command-line mode maps i.e. after pressing :
" :omap - Display operator pending mode maps e.g. deletion after pressing d

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

"" COC END

" Highlight trailing whitespace (at the end after colorscheme is set)
highlight extrawhitespace ctermbg=red guibg=red
match extrawhitespace /\s\+$\| \+\ze\t/
