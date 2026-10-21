-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
  {
    'ThePrimeagen/vim-be-good',
    cmd = 'VimBeGood',
    config = function()
      -- Optional: Add any specific configuration here if needed
    end,
  },
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    event = 'VeryLazy',
    init = function() end,
  },
  {
    'numToStr/Comment.nvim',
    opts = { --[[add any options here]]
    },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true, cmd = { 'DB' } },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Salesforce helpers
  { 'jonathanmorris180/salesforce.nvim' }, -- optional
  { 'xixiaofinland/sf.nvim', ft = { 'apex', 'soql', 'sosl' } }, -- optional
  -- Rust
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          -- cmd = { vim.fn.stdpath 'data' .. '/mason/bin/rust-analyzer.CMD' },
          default_settings = {
            ['rust-analyzer'] = {
              checkOnSave = true,
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
                targets = { 'x86_64-pc-windows-msvc', 'x86_64-unknown-linux-gnu' },
              },
              files = { watcher = 'server' },
              cargo = {
                allFeatures = true,
                target = 'x86_64-pc-windows-msvc',
              },
            },
          },
        },
      }
    end,
  },
  -- nvim http client
  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    opts = {},
    config = function()
      require('kulala').setup {
        -- Enabling formatters for JSON (and other formats)
        formatters = {
          json = { 'jq', '.' },
          xml = { 'xmllint', '--format', '-' },
          html = { 'xmllint', '--format', '--html', '-' },
        },
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>kr', ':lua require("kulala").run()<CR>', { desc = 'Kulala: Run Request' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ka', ':lua require("kulala").run_all()<CR>', { desc = 'Kulala: Run all Requests' })
      vim.keymap.set('n', '<leader>kt', ':lua require("kulala").toggle_view()<CR>', { desc = 'Kulala: Toggle view' })
      vim.keymap.set('n', '<leader>kc', ':lua require("kulala").copy()<CR>', { desc = 'Kulala: Copy as cURL' })
      vim.keymap.set('n', '<leader>kR', ':lua require("kulala").replay()<CR>', { desc = 'Kulala: Replay the last request' })
      vim.keymap.set('n', '<leader>ks', ':lua require("kulala").scratchpad()<CR>', { desc = 'Kulala: Replay the last request' })
    end,
  },
  -- claude code cli
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },

  -- easily view diffs
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Diff view open' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
      { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Diff view close' },
    },
    opts = {},
  },

  -- render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

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
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

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
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
