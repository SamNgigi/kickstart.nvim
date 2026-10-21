-- lua/custom/extras.lua
-- Personal plugins, ported from lazy.nvim specs to vim.pack.
--
-- Required explicitly at the END of init.lua (after kickstart sections), because
-- these depend on plenary (telescope section), treesitter + mini (render-markdown),
-- and must not race the kickstart setup. Explicit require = deterministic order.
--
-- Dropped vs old lazy specs:
--   - Comment.nvim: built into Neovim >= 0.10 (gc / gcc).
--   - telescope-fzf-native: now handled in kickstart section 5 + PackChanged hook.
--   - blink.cmp: now configured in kickstart section 8.

local function gh(repo)
  return 'https://github.com/' .. repo
end
local map = vim.keymap.set

-- ============================================================
-- Rust
-- vim.g.rustaceanvim must be set BEFORE the plugin loads.
-- rust_analyzer must NOT appear in the kickstart `servers` table:
-- rustaceanvim owns that client; enabling both = two clients.
-- ============================================================
vim.g.rustaceanvim = {
  server = {
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
-- TODO: bump to the latest major (check releases) to clear the
-- get_buffers_by_client_id deprecation warning.
vim.pack.add { { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '9.*' } }

-- ============================================================
-- Editing
-- ============================================================
vim.pack.add {
  gh 'mg979/vim-visual-multi',
  gh 'ThePrimeagen/vim-be-good',
}

-- ============================================================
-- Database (dadbod)
-- ============================================================
vim.g.db_ui_use_nerd_fonts = 1
vim.pack.add {
  gh 'tpope/vim-dadbod',
  gh 'kristijanhusak/vim-dadbod-ui',
  gh 'kristijanhusak/vim-dadbod-completion',
}

-- ============================================================
-- Salesforce
-- Old specs called no setup(). Check each README: if a setup() call is
-- required, add it here. Delete this block if Salesforce work is dormant.
-- ============================================================
vim.pack.add {
  gh 'jonathanmorris180/salesforce.nvim',
  gh 'xixiaofinland/sf.nvim',
}

-- ============================================================
-- HTTP client (kulala)
-- ============================================================
vim.pack.add { gh 'mistweaverco/kulala.nvim' }
local kulala = require 'kulala'
kulala.setup {
  formatters = {
    json = { 'jq', '.' },
    xml = { 'xmllint', '--format', '-' },
    html = { 'xmllint', '--format', '--html', '-' },
  },
}
map({ 'n', 'v' }, '<leader>kr', kulala.run, { desc = 'Kulala: Run request' })
map({ 'n', 'v' }, '<leader>ka', kulala.run_all, { desc = 'Kulala: Run all requests' })
map('n', '<leader>kt', kulala.toggle_view, { desc = 'Kulala: Toggle view' })
map('n', '<leader>kc', kulala.copy, { desc = 'Kulala: Copy as cURL' })
map('n', '<leader>kR', kulala.replay, { desc = 'Kulala: Replay last request' })
map('n', '<leader>ks', kulala.scratchpad, { desc = 'Kulala: Scratchpad' }) -- old desc was a copy-paste bug

-- ============================================================
-- Claude Code
-- snacks.nvim is a dependency (terminal provider); no setup() needed for it.
-- ============================================================
vim.pack.add {
  gh 'folke/snacks.nvim',
  gh 'coder/claudecode.nvim',
}
require('claudecode').setup {}

map('n', '<leader>ac', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
map('n', '<leader>af', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
map('n', '<leader>ar', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
map('n', '<leader>aC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
map('n', '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', { desc = 'Select Claude model' })
map('n', '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
map('v', '<leader>as', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })
map('n', '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
map('n', '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })

-- lazy's `ft`-scoped key → buffer-local map via FileType autocmd
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('claudecode-tree-add', { clear = true }),
  pattern = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
  callback = function(ev)
    map('n', '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', { buffer = ev.buf, desc = 'Add file to Claude' })
  end,
})

-- ============================================================
-- Diffs (plenary already added by the telescope section)
-- ============================================================
vim.pack.add { gh 'sindrets/diffview.nvim' }
require('diffview').setup {}
map('n', '<leader>gdo', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview open' })
map('n', '<leader>gdc', '<cmd>DiffviewClose<cr>', { desc = 'Diffview close' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })

-- ============================================================
-- Markdown rendering (needs treesitter + mini from kickstart sections)
-- ============================================================
vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {}
