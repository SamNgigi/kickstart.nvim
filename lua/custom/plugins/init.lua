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

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = { "rust", "lua", "toml", "markdown", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = false },
        incremental_selection = { enable = false },
      })
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
          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              files = { watcher = "server" },
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
}
