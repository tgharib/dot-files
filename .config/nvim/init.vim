" For editing multiple lines in vim, use 1. `V:! sd` 2. macros 3. `V:norm`.
" Vim motion options: f/F/t/T for horizontal, <CR> for vertical, */#, search, goto definition, ripgrep
" Paste text vertically using visual block mode https://stackoverflow.com/a/27542895

" Options
let mapleader = " "
set nowrap " Turn off line wrap
set nohlsearch " Turn off search highlighting
set clipboard=unnamedplus " Use system clipboard for copy and paste
set ignorecase smartcase " Use smart case for search (smartcase needs ignorecase set)
set timeoutlen=0 " Immediately show which-key
set sessionoptions=buffers " Session = buffers only (to avoid bugs with abduco)
set hidden " Allow buffers to be hidden without saving
set number " Enable line numbers by default
set expandtab " Spaces-only indenation https://gist.github.com/LunarLambda/4c444238fb364509b72cfb891979f1dd
set softtabstop=-1 " Spaces-only indenation
syntax off " Rely on treesitter only for syntax highlighting
let g:suda_smart_edit = 1 " suda.nvim smart write
set mouse= " Disable mouse support
set signcolumn=number " Combine gutter with number lines column

"" Don't touch unnamed register when pasting over visual selection
xnoremap p P

lua << EOF
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  defaults = {
    lazy = true,
  },
  spec = {
    -- Don't forget to disable lazy loading when installing new plugin!
    -- Color scheme
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
    -- Status line at the bottom
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    -- Keybind helper
    "folke/which-key.nvim",
    -- Fzf windows
    {
      "ibhagwan/fzf-lua",
      -- optional for icon support
      -- dependencies = { "nvim-tree/nvim-web-devicons" },
      -- or if using mini.icons/mini.nvim
      dependencies = { "nvim-mini/mini.icons" },
      opts = {}
    },
    -- Sessions support
    "natecraddock/sessions.nvim",
    -- Autorecognize indent of file
    "nmac427/guess-indent.nvim",
    -- Edit root files
    { "lambdalisue/suda.vim", lazy = false },
    -- File manager
    { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" }, lazy = false },
    -- Show which lines are added, changed or deleted
    "lewis6991/gitsigns.nvim",
    -- Dark/light mode based on system setting
    { "f-person/auto-dark-mode.nvim", opts = {} },
    -- Syntax highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      branch = 'master',
      build = ':TSUpdate'
    },
    -- Show current function at top if function is massive
    "nvim-treesitter/nvim-treesitter-context",
    -- Refactoring plugin for C++ (Rust not supported)
    {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      lazy = false,
      opts = {},
    },
    -- Nice plugins
    { "echasnovski/mini.nvim", version = false },
    -- Document outline for markdown
    {
      'stevearc/aerial.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons"
      },
    },
    -- Use local neovim GUI on remote server
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
    -- https://gist.github.com/smnatale/b847e568f1a155b8e8349f29a482a1f4
    -- Provides lspconfig for each mason tool (LSP) installed
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            { "neovim/nvim-lspconfig" },
        },
    },
    -- Ensure selected mason tools (LSPs) are installed
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = {},
    },
    -- Get access to LSP inlay hints via a toggle
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("inlay-hints").setup({
                commands = { enable = true }, -- Enable InlayHints commands
                autocmd = { enable = false } -- Disable the inlay hints on `LspAttach` event
            })
        end
    },
    -- Better than fzf-lua for buffer diagnostics (persistent)
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
      keys = {},
    },
    -- Better than fzf-lua for go to references (persistent)
    {
      "kevinhwang91/nvim-bqf",
      opts = {},
      lazy = false,
    },
    -- Show lightbulbs when current line has a code action
    { 'kosayoda/nvim-lightbulb' },
    -- C++ clangd extensions
    { 'https://git.sr.ht/~p00f/clangd_extensions.nvim' },
    -- Signature help when calling a function
    {
      "ray-x/lsp_signature.nvim",
      event = "InsertEnter",
      opts = {
        bind = true,
        handler_opts = {
          border = "rounded",
        },
        hint_enable = false,
        select_signature_key = '<C-p>',
      },
    },
    -- Auto-completion
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },
      lazy = false,
      -- use a release tag to download pre-built binaries
      version = '1.*',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = 'enter',
          ['<C-e>'] = { 'show', 'hide' },
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        completion = {
          documentation = { auto_show = true },
          ghost_text = {
            enabled = true,
          },
          menu = {
            direction_priority = function()
              local ctx = require('blink.cmp').get_context()
              local item = require('blink.cmp').get_selected_item()
              if ctx == nil or item == nil then return { 's', 'n' } end

              local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
              local is_multi_line = item_text:find('\n') ~= nil

              -- after showing the menu upwards, we want to maintain that direction
              -- until we re-open the menu, so store the context id in a global variable
              if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
                vim.g.blink_cmp_upwards_ctx_id = ctx.id
                return { 'n', 's' }
              end
              return { 's', 'n' }
            end,
          },
          list = {
            selection = {
              preselect = false,
            },
          },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- do not automatically check for plugin updates
  checker = { enabled = false },
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

lua << EOF
-- https://gist.github.com/smnatale/692ac4f256d5f19fbcbb78fe32c87604

-- restore cursor to file position in previous editing session
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

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
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

"" clangd_extensions
lua << EOF
require("clangd_extensions").setup()
EOF

"" nvim-lightbulb
lua << EOF
require("nvim-lightbulb").setup({
  autocmd = { enabled = true }
})
EOF

"" fzf-lua
lua << EOF
require('fzf-lua').setup({'fzf-vim'})
EOF

"" Mason tool installer
lua << EOF
require('mason-tool-installer').setup({
  ensure_installed = {
    "clangd",
    "rust-analyzer",
    "pyright",
  }
})
EOF

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
    vim.keymap.set("n", "{", "<Cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<Cmd>AerialNext<CR>", { buffer = bufnr })
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
require('gitsigns').setup()
EOF

"" mini.nvim

lua << EOF
-- gA to start, s for split pattern, t for trimming whitespace
-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-align.txt
require('mini.align').setup()
-- highlight word under cursor
require('mini.cursorword').setup()
-- close windows while saving window layout
require('mini.bufremove').setup()
-- hop.nvim clone
require('mini.jump2d').setup({
  view = {
    dim = true,
    n_steps_ahead = 10,
  },
  mappings = {
    start_jumping = '',
  },
})
-- icons
require('mini.icons').setup()
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
  -- Install languages for treesitter
  ensure_installed = { "bash", "c", "cmake", "comment", "cpp", "dockerfile", "glsl", "java", "lua", "make", "markdown", "ninja", "nix", "python", "rust", "verilog" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = disable_for_large_files,
    additional_vim_regex_highlighting = false,
  },
}

-- New treesitter config (main branch instead of master) but doesn't work with rust
-- require'nvim-treesitter'.install {'bash', 'c', 'cmake', 'comment', 'cpp', 'dockerfile', 'glsl', 'java', 'lua', 'make', 'markdown', 'ninja', 'nix', 'python', 'rust', 'verilog'}
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'rs', 'vim', 'h', 'c', 'hpp', 'cpp', 'sh', 'bash' },
--   callback = function() vim.treesitter.start() end,
-- })

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
EOF

"" which-key.nvim
"
" :nmap - Display normal mode maps
" :imap - Display insert mode maps
" :vmap - Display visual and select mode maps
" :smap - Display select mode maps <-- select mode is never used
" :xmap - Display visual mode maps
" :cmap - Display command-line mode maps i.e. after pressing :
" :omap - Display operator pending mode maps e.g. deletion after pressing d
lua << EOF
require("which-key").setup {}
local wk = require("which-key")
wk.add({
  { "<CR>", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  { "<leader>k", "<Cmd>lua vim.lsp.buf.hover()<CR>", desc = "show documentation" },
  { "<leader>L", "<Cmd>Lazy<CR>", desc = "show Lazy plugin manager window" },
  { "<leader>b", group = "buffers" },
  { "<leader>bQ", "<Cmd>bufdo bw<CR>", desc = "quit all buffers" },
  { "<leader>bb", "<Cmd>Buffers<CR>", desc = "select buffer" },
  { "<leader>bf", "<Cmd>Files<CR>", desc = "open file" },
  { "<leader>bl", ":SessionsLoad! ", desc = "load session" },
  { "<leader>bq", "<Cmd>lua MiniBufremove.wipeout()<CR>", desc = "quit current buffer" },
  { "<leader>bs", ":SessionsSave! ", desc = "save session" },
  { "<leader>bt", "<Cmd>tabonly<CR>", desc = "tabs -> buffers" },
  { "<leader>x", group = "fix error" },
  { "<leader>fe", "<Cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics" },
  { "<leader>fE", "<Cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics" },
  { "<leader>fl", "<Cmd>Trouble qflist toggle<cr>", desc = "quickfix list" },
  { "<leader>fL", "<Cmd>Trouble loclist toggle<cr>", desc = "location list" },
  { "<leader>g", group = "go to" },
  { "<leader>gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", desc = "go to implementation" },
  { "<leader>gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", desc = "go to declaration" },
  { "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", desc = "go to definition" },
  { "<leader>gg", "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "go to source/header" },
  { "<leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", desc = "go to references" },
  { "<leader>gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "go to type definition" },
  { "<leader>p", group = "paths" },
  { "<leader>pc", "<Cmd>cd %<Cmd>h<CR>", desc = "cd into current buffer working directory" },
  { "<leader>pf", "<Cmd>echo expand('%<Cmd>p')<CR>", desc = "show file path" },
  { "<leader>po", "<Cmd>Oil<CR>", desc = "oil (file manager)" },
  { "<leader>r", group = "refactor/transform" },
  { "<leader>ra", "<Cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code action" },
  { "<leader>rf", "<Cmd>lua vim.lsp.buf.format()<CR>", desc = "format buffer" },
  { "<leader>rp", group = "print debug" },
  { "<leader>rpc", "<Cmd>lua require('refactoring').debug.cleanup({})<CR>", desc = "cleanup (refactoring.nvim)" },
  { "<leader>rpl", "<Cmd>lua require('refactoring').debug.printf({below = true})<CR>", desc = "print line (refactoring.nvim)" },
  { "<leader>rpv", "<Cmd>lua require('refactoring').debug.print_var()<CR>", desc = "print variable (refactoring.nvim)" },
  { "<leader>rz", "<Cmd>lua require('refactoring').select_refactor({prefer_ex_cmd = true}) <CR>", desc = "refactoring.nvim prompts" },
  { "<leader>rr", "<Cmd>lua vim.lsp.buf.rename()<CR>", desc = "rename symbol" },
  { "<leader>rw", group = "whitespace" },
  { "<leader>rw2", "<Cmd>set tabstop=2 shiftwidth=2 | set expandtab | set softtabstop=-1<CR>", desc = "set tabs to 2 spaces" },
  { "<leader>rw4", "<Cmd>set tabstop=4 shiftwidth=4 | set expandtab | set softtabstop=-1<CR>", desc = "set tabs to 4 spaces" },
  { "<leader>rwr", "<Cmd>retab<CR>", desc = "replace tabs with spaces" },
  { "<leader>rwt", "<Cmd>call TrimWhitespace()<CR>", desc = "trim whitespace" },
  { "<leader>s", group = "search" },
  { "<leader>se", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", desc = "open document outline" },
  { "<leader>sd", "<Cmd>Trouble symbols toggle focus=false<cr>", desc = "open document outline" },
  { "<leader>sD", "<Cmd>AerialToggle!<CR>", desc = "open document outline" },
  { "<leader>sT", "<Cmd>Lines!<CR>", desc = "search text in all buffers" },
  { "<leader>sc", "<Cmd>let @/ = \"\"<CR>", desc = "clear search buffer" },
  { "<leader>sr", ":Rg! ", desc = "rg text in current working directory" },
  { "<leader>ss", "<Cmd>FzfLua lsp_document_symbols<CR>", desc = "search symbols in buffer" },
  { "<leader>st", "<Cmd>BLines!<CR>", desc = "search text in current buffer" },
  { "<leader>t", group = "toggles" },
  { "<leader>td", "<Cmd>Gitsigns toggle_signs<CR>", desc = "toggle git diff signs" },
  { "<leader>th", "<Cmd>set hlsearch!<CR>", desc = "toggle search highlight" },
  { "<leader>tl", "<Cmd>set number!<CR>", desc = "toggle line numbers" },
  { "<leader>tn", "<Cmd>TSContext toggle<CR>", desc = "toggle context (nested statements)" },
  { "<leader>tt", "<Cmd>InlayHintsToggle<CR>", desc = "toggle inlay hints" },
  { "<leader>tw", "<Cmd>set wrap!<CR>", desc = "toggle line wrap" },
  })
wk.add({
  {
  mode = { "x" },
  { "<CR>", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  { "<leader>r", group = "refactor/transform" },
  { "<leader>ra", "<Cmd>lua vim.lsp.buf.code_action()<CR>", desc = "code action" },
  { "<leader>rz", "<Cmd>lua require('refactoring').select_refactor({prefer_ex_cmd = true}) <CR>", desc = "refactoring.nvim prompts" },
  },
  })
wk.add({
  {
  mode = { "o" },
  { "<CR>", "<Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<CR>" },
  },
  })
EOF

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
