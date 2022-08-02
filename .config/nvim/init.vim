" For editing multiple lines in vim, use a combination of `V:! sd`, `V:norm` and `V:norm@a` (a is a macro).
" Vim motion options: f/F for horizontal, C-j/C-k for veritcal, /n*, dumb code navigation, smart code navigation

" Plugins Manager

"" Automatically install Vim-Plug
let data_dir = stdpath('data') . '/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"" Plugins will be downloaded under the specified directory.
call plug#begin(stdpath('data') . '/plugged')

"" Plugin List
""" Cosmetic
Plug 'overcache/NeoSolarized'
Plug 'itchyny/lightline.vim'

""" Regular
Plug 'folke/which-key.nvim'
Plug 'phaazon/hop.nvim'
Plug 'simrat39/symbols-outline.nvim' " for markdown
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets' " Snippets database
Plug 'natecraddock/sessions.nvim'

""" Dumb code
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

""" Smart code
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
syntax off " Vim-Plug enables vim's syntax highlighting but we use treesitter instead

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

"" Set colorscheme to NeoSolarized
colorscheme NeoSolarized
set background=dark
set termguicolors " Force colorscheme colors with 24-bit support

"" Markdown macros
let @i ="o![](images/.png){width=60%}\<Esc>15hi"
let @e ="o$$\<Enter>$$\<Esc>O"

" Helper functions
"" Trim trailing whitespace function
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

" Plugins

"" sessions.nvim

lua << EOF
require("sessions").setup()
EOF

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
""" Fold based on treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
""" Unfold all by default
set foldlevel=99

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- Install all languages for treesitter except for rnoweb, phpdoc
  ensure_installed = { "astro", "bash", "beancount", "bibtex", "c", "c_sharp", "clojure", "cmake", "comment", "commonlisp", "cooklang", "cpp", "css", "cuda", "d", "dart", "devicetree", "dockerfile", "dot", "eex", "elixir", "elm", "elvish", "embedded_template", "erlang", "fennel", "fish", "foam", "fortran", "fusion", "gdscript", "gleam", "glimmer", "glsl", "go", "godot_resource", "gomod", "gowork", "graphql", "hack", "haskell", "hcl", "heex", "help", "hjson", "hocon", "html", "http", "java", "javascript", "jsdoc", "json", "json5", "jsonc", "julia", "kotlin", "lalrpop", "latex", "ledger", "llvm", "lua", "m68k", "make", "markdown", "ninja", "nix", "norg", "ocaml", "ocaml_interface", "ocamllex", "org", "pascal", "perl", "php", "pioasm", "prisma", "proto", "pug", "python", "ql", "qmljs", "query", "r", "rasi", "regex", "rego", "rst", "ruby", "rust", "scala", "scheme", "scss", "slint", "solidity", "sparql", "sql", "supercollider", "surface", "svelte", "swift", "teal", "tiger", "tlaplus", "todotxt", "toml", "tsx", "turtle", "typescript", "v", "vala", "verilog", "vim", "vue", "wgsl", "yaml", "yang", "zig" },
  sync_install = false,
  highlight = {
    enable = true,
    disable = function(lang, bufnr) -- Disable in large buffers
      return vim.api.nvim_buf_line_count(bufnr) > 50000
    end,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF

"" nvim-treesitter-context
lua << EOF
require'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
        },
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

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
EOF

"" nvim-treesitter-refactor
lua << EOF
require'nvim-treesitter.configs'.setup {
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true, -- Set to false if you have an `updatetime` of ~100.
    },
    smart_rename = {
      enable = true,
    },
    navigation = {
      enable = true,
    },
  },
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

"" fzf.nvim
command! -bang -nargs=* Rgi call fzf#vim#grep('rg -i --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

"" which-key.nvim
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
      o = { ":<C-u>CocList outline<CR>", "go to symbol in document outline" },
      O = { ":<C-u>CocList -I symbols<CR>", "go to symbol in workspace" },
      r = { "<Plug>(coc-references)", "go to references" },
      t = { "<Plug>(coc-type-definition)", "go to type definition" },
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
      d = { ":<C-u>CocList diagnostics<CR>", "show all diagnostics" },
      ["["] = { "<Plug>(coc-diagnostic-prev)", "quick-navigate previous diagnostic" },
      ["]"] = { "<Plug>(coc-diagnostic-next)", "quick-navigate next diagnostic" },
    },
    r = { "<Plug>(coc-rename)", "rename symbol" },
    o = { ":call ShowDocumentation()<CR>", "show documentation" },
    i = { ":call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>", "organize imports" },
  },
  d = {
    name = "dumb code",
    n  = {
      name = "navigation",
      d = { ":lua require'nvim-treesitter-refactor.navigation'.goto_definition(0)<CR>", "go to definition" },
      a = { ":Ag! ", "ag" },
      r = { ":Rg! ", "rg" },
      R = { ":Rgi! ", "rg -i" },
      t = { ":BTags<CR>", "tags in current buffer" },
      T = { ":Tags<CR>", "tags in project" },
      l = { ":BLines<CR>", "lines in current buffer" },
      L = { ":Lines<CR>", "lines in all buffers" },
    },
    s = { ":Snippets<CR>", "snippets" },
    c = { ":TSContextToggle<CR>", "toggle context" },
    r = { ":lua require'nvim-treesitter-refactor.smart_rename'.smart_rename(0)<CR>", "rename symbol" },
  },
  b = {
    name = "buffers",
    g = { ":GFiles<CR>", "open git file" },
    f = { ":Files<CR>", "open file" },
    b = { ":Buffers<CR>", "select buffer" },
    c = { ":bw<CR>", "close current buffer :bw" },
    C = { ":bufdo bw<CR>", "close all buffers :bufdo bw" },
    t = { ":tabonly<CR>", "tabs -> buffers" },
    l = { ":SessionsLoad ", "load session" },
    s = { ":SessionsSave ", "save session" },
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
    s = { ":SymbolsOutlineOpen<CR>", "toggle markdown symbols outline" },
    c = { ":Commands<CR>", "vim commands" },
    k = { ":help index<CR>", "vim keybinds" },
    K = { ":help index<CR>", "vim keybinds 2" },
    v = { ":Colors<CR>", "vim color schemes" },
    f = { ":echo expand('%:p')<CR>", "show file path" },
    h = { ":set hlsearch!<CR>", "toggle search highlight" },
  },
}, { prefix = "<leader>", mode = "n" })
wk.register({
  c = {
    name = "smart code (coc)",
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
}, { prefix = "<leader>", mode = "o" })

wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
  ["<C-j>"] = { "2j", "move cursor down two lines" },
  ["<C-k>"] = { "2k", "move cursor up two lines" },
  ["<CR>"] = { ":lua require'nvim-treesitter.incremental_selection'.init_selection()<CR>", "start code selection" },
  ["<A-0>"] = { ":lua require'nvim-treesitter-refactor.navigation'.goto_next_usage(0)<CR>", "go to next symbol usage" },
  ["<A-9>"] = { ":lua require'nvim-treesitter-refactor.navigation'.goto_previous_usage(0)<CR>", "go to previous symbol usage" },
}, { prefix = "", mode = "n" })
wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
}, { prefix = "", mode = "o" })
wk.register({
  f = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<CR>", "jump in line (after cursor)" },
  F = { "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<CR>", "jump in line (before cursor)" },
}, { prefix = "", mode = "v" })
wk.register({
  ["<CR>"] = { ":lua require'nvim-treesitter.incremental_selection'.node_incremental()<CR>", "expand code selection" },
  ["<BS>"] = { ":lua require'nvim-treesitter.incremental_selection'.node_decremental()<CR>", "shrink code selection" },
}, { prefix = "", mode = "x" })
-- n = normal mode, o = deletion mode (d), v = v-line mode = line-selection mode (V), x = visual mode = char-selection mode (v)
EOF

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

augroup mygroup
  autocmd!
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp') " Update signature help on jump placeholder
  autocmd user cocstatuschange,cocdiagnosticchange call lightline#update() " Use autocmd to force lightline update
augroup end

if has('nvim-0.4.0') || has('patch-8.2.0750') " Remap <C-f> and <C-b> for scroll float windows/popups.
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
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

"" COC END

" Highlight trailing whitespace (at the end after colorscheme is set)
highlight extrawhitespace ctermbg=red guibg=red
match extrawhitespace /\s\+$\| \+\ze\t/
