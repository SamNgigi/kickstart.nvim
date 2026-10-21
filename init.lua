--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- NOTE: init.lua — My custom config, ported onto upstream kickstart.nvim (vim.pack, Nvim 0.12).
--
-- Deltas from upstream are tagged `CHANGED:` / `ADDED:` / `REMOVED:` so future
-- upstream diffs stay readable. Personal modules live in lua/custom/ and are
-- required explicitly at the bottom (deterministic load order).

-- ============================================================
-- SECTION 1: OPTIONS
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = true -- CHANGED

  -- ADDED: python provider (pyenv-win). REMOVED: shell/shellcmdflag/shellquote
  -- overrides — Nvim's Windows defaults already use cmd.exe with correct quoting.
  -- If a :! command misbehaves, re-add with a comment saying which one.
  if vim.fn.has 'win32' == 1 then
    vim.g.python3_host_prog = 'C:/Users/jedi/.pyenv/pyenv-win/shims/python'
  end

  vim.g.loaded_man = 1 -- ADDED: disable built-in man plugin

  vim.o.number = true
  vim.o.relativenumber = true -- CHANGED
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true

  vim.o.autoread = true -- ADDED: pick up Claude Code's on-disk edits (see checktime autocmd)
end

-- ============================================================
-- SECTION 2: KEYMAPS & AUTOCMDS
-- ============================================================
do
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = true, -- CHANGED: all severities
    virtual_text = { prefix = '●', source = 'if_many', spacing = 4 }, -- CHANGED
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end,
    },
  }
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- CHANGED: Alt+hjkl for window focus (upstream uses Ctrl; Ctrl+j/k is line-move below)
  vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- ADDED: move lines. 'x' not 'v' so snippet select-mode isn't hijacked.
  -- REMOVED: insert-mode <C-j>/<C-k> — collides with blink's <C-k> signature help.
  -- FIXED: visual ranges were `>+1`/`<-2` (missing the mark apostrophe).
  vim.keymap.set('n', '<C-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
  vim.keymap.set('n', '<C-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
  vim.keymap.set('x', '<C-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true })
  vim.keymap.set('x', '<C-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true })

  -- ADDED: diff buffer against its on-disk version
  vim.api.nvim_create_user_command('DiffOrig', function()
    vim.cmd 'vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis'
  end, { desc = 'Diff buffer against file on disk' })
  vim.keymap.set('n', '<leader>do', '<cmd>DiffOrig<cr>', { desc = '[D]iff [O]rig' })
  vim.keymap.set('n', '<leader>dc', '<cmd>diffoff!<cr>', { desc = '[D]iff [C]lose' })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  -- ADDED: reload externally-changed files. Guard: checktime errors in cmdline/cmdwin.
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
    group = vim.api.nvim_create_augroup('autoread-checktime', { clear = true }),
    callback = function()
      if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
        vim.cmd 'checktime'
      end
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER (vim.pack) + BUILD HOOKS
--   Inspect:  :lua vim.pack.update(nil, { offline = true })
--   Update:   :lua vim.pack.update()
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local output = (result.stderr ~= '' and result.stderr) or result.stdout or ''
      if output == '' then
        output = 'No output from build command.'
      end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
      return false
    end
    return true
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      -- CHANGED: cmake first (Windows has no make), short-circuit on failure
      if name == 'telescope-fzf-native.nvim' then
        if vim.fn.executable 'cmake' == 1 then
          local _ = run_build(name, { 'cmake', '-S.', '-Bbuild', '-DCMAKE_BUILD_TYPE=Release' }, path)
            and run_build(name, { 'cmake', '--build', 'build', '--config', 'Release' }, path)
            and run_build(name, { 'cmake', '--install', 'build', '--prefix', 'build' }, path)
        elseif vim.fn.executable 'make' == 1 then
          run_build(name, { 'make' }, path)
        end
        return
      end

      -- REMOVED: LuaSnip build (LuaSnip dropped; blink native snippets instead)

      if name == 'nvim-treesitter' then
        if not ev.data.active then
          vim.cmd.packadd 'nvim-treesitter'
        end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

-- ============================================================
-- SECTION 4: UI / CORE UX
-- ============================================================
do
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
    on_attach = function(bufnr)
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, 'Jump to next git [c]hange')
      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, 'Jump to previous git [c]hange')

      map('v', '<leader>hs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, 'git [s]tage hunk')
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, 'git [r]eset hunk')
      map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage hunk')
      map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
      map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
      map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
      map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
      map('n', '<leader>hi', gitsigns.preview_hunk_inline, 'git preview hunk [i]nline')
      map('n', '<leader>hb', function()
        gitsigns.blame_line { full = true }
      end, 'git [b]lame line')
      map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
      map('n', '<leader>hD', function()
        gitsigns.diffthis '~'
      end, 'git [D]iff against last commit')
      map('n', '<leader>hQ', function()
        gitsigns.setqflist 'all'
      end, 'git hunk [Q]uickfix list (repo)')
      map('n', '<leader>hq', gitsigns.setqflist, 'git hunk [q]uickfix list (file)')
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git show [b]lame line')
      map('n', '<leader>tw', gitsigns.toggle_word_diff, '[T]oggle git intra-line [w]ord diff')
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'text object [i]nside [h]unk')
    end,
  }

  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
      -- ADDED
      { '<leader>a', group = '[A]I / Claude Code', mode = { 'n', 'v' } },
      { '<leader>b', group = '[B]uffers' },
      { '<leader>d', group = '[D]iff' },
      { '<leader>g', group = '[G]it / Diffview' },
      { '<leader>k', group = '[K]ulala HTTP' },
    },
  }

  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup { styles = { comments = { italic = false } } }
  vim.cmd.colorscheme 'tokyonight-night'

  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  vim.pack.add { gh 'nvim-mini/mini.nvim' }
  if vim.g.have_nerd_font then
    require('mini.icons').setup()
    MiniIcons.mock_nvim_web_devicons()
  end
  -- 'aa'/'ii' avoid clashing with Nvim 0.12 built-in incremental selection
  require('mini.ai').setup { mappings = { around_next = 'aa', inside_next = 'ii' }, n_lines = 500 }
  require('mini.surround').setup()
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION (telescope)
-- ============================================================
do
  ---@type (string | vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
    gh 'nvim-telescope/telescope-live-grep-args.nvim', -- ADDED
  }
  -- CHANGED: cmake also qualifies (Windows)
  if vim.fn.executable 'make' == 1 or vim.fn.executable 'cmake' == 1 then
    table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
  end
  vim.pack.add(telescope_plugins)

  -- CHANGED: .gitignore is the single source of truth for what's hidden.
  -- REMOVED: old file_ignore_patterns — they're Lua patterns matched anywhere in
  --   the path, so 'build' hid build.rs, '.git' hid .github/, 'dist' hid distance.rs.
  -- FIXED: old find_files config was nested under `defaults` (never applied), and
  --   its positive `-g .gitignore -g .env` globs would have restricted results to
  --   ONLY those two files.
  local rg_files = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' }

  require('telescope').setup {
    defaults = {
      mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' } },
    },
    pickers = {
      find_files = { find_command = rg_files },
    },
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'live_grep_args')

  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  -- ADDED: escape hatch for gitignored files (.env, target/ artefacts)
  vim.keymap.set('n', '<leader>sF', function()
    builtin.find_files { find_command = { 'rg', '--files', '--hidden', '--no-ignore', '--glob', '!**/.git/*' } }
  end, { desc = '[S]earch [F]iles incl. ignored' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  -- CHANGED: live_grep_args (rg flags/globs inline)
  vim.keymap.set('n', '<leader>sg', function()
    require('telescope').extensions.live_grep_args.live_grep_args()
  end, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' }) -- ADDED: muscle memory
      vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    end,
  })

  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
  end, { desc = '[/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
  end, { desc = '[S]earch [/] in Open Files' })
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true }
  end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- SECTION 6: LSP
-- rust_analyzer is deliberately absent: rustaceanvim owns it (lua/custom/extras.lua).
-- ============================================================
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local hl = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references })
        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- ADDED: ported from old lspconfig setup. `root_dir = root_pattern(...)` → `root_markers`.
    clangd = {
      cmd = { 'clangd', '--background-index', '--compile-commands-dir=.', '--completion-style=detailed' },
      root_markers = { 'compile_flags.txt', '.clangd', '.git' },
    },
    gopls = {},
    pyright = {
      settings = { python = { analysis = { extraPaths = {} } } },
      capabilities = { workspace = { didChangeWatchedFiles = { dynamicRegistration = false } } },
    },
    ts_ls = {},
    emmet_language_server = {
      filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
    },

    stylua = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
          workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
        })
      end,
      settings = { Lua = { format = { enable = false } } },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }
  require('mason').setup {}
  require('mason-lspconfig').setup { automatic_enable = false }
  require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 7: FORMATTING
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    -- CHANGED: format on save everywhere except C/C++ (your previous behaviour;
    -- upstream defaults to off). Rust formats via rust-analyzer → rustfmt.
    format_on_save = function(bufnr)
      local disabled = { c = true, cpp = true }
      if disabled[vim.bo[bufnr].filetype] then
        return nil
      end
      return { timeout_ms = 500 }
    end,
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = {
      lua = { 'stylua' },
    },
  }
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format { async = true }
  end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE
-- CHANGED: blink native snippets + friendly-snippets; LuaSnip dropped
-- (its jsregexp build was disabled on Windows anyway).
-- ============================================================
do
  vim.pack.add {
    gh 'rafamadriz/friendly-snippets',
    { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  }
  require('blink.cmp').setup {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    -- Prebuilt Rust matcher for the checked-out tag; warns and falls back to Lua if absent.
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 9: TREESITTER (main branch)
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local ts = require 'nvim-treesitter'
  ts.install { -- CHANGED: your parser set
    'rust',
    'python',
    'typescript',
    'tsx',
    'toml',
    'yaml',
    'sql',
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
  }

  local function attach(buf, lang)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if not vim.treesitter.language.add(lang) then
      return
    end
    vim.treesitter.start(buf, lang)
    if vim.treesitter.query.get(lang, 'indents') ~= nil then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- CHANGED: buffer-scoped
    end
  end

  local available = ts.get_available()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ts-attach', { clear = true }),
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then
        return
      end
      if vim.tbl_contains(ts.get_installed 'parsers', lang) then
        attach(args.buf, lang)
      elseif vim.tbl_contains(available, lang) then
        ts.install(lang):await(function()
          attach(args.buf, lang)
        end)
      else
        attach(args.buf, lang)
      end
    end,
  })
end

-- ============================================================
-- SECTION 10: KICKSTART EXTRAS + PERSONAL MODULES
-- Order matters: extras depend on plenary/treesitter/mini loaded above.
-- ============================================================
do
  require 'kickstart.plugins.debug'
  require 'kickstart.plugins.indent_line'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'

  require('custom.tabs_config').setup()
  require('custom.keymaps_config').setup()
  require 'custom.extras'
end

-- vim: ts=2 sts=2 sw=2 et
