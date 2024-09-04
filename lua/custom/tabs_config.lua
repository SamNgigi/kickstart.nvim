local M = {}

function M.setup()
  -- Global settings for all file types
  vim.opt.tabstop = 2 -- Number of spaces tab counts for
  vim.opt.shiftwidth = 2 -- Size of indent
  vim.opt.expandtab = true -- Use spaces instead of tabs
  vim.opt.softtabstop = 2 -- Number of spaces in tab when editing

  -- Optional: Set indentation settings
  vim.opt.autoindent = true -- Copy indent from current line when starting a new line
  vim.opt.smartindent = true -- Do smart auto indenting when starting a new line

  -- Setting Tab indent and unident on normal mode
  vim.keymap.set('n', '<Tab>', '>>', { noremap = true, silent = true })
  vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, silent = true })

  -- Setting Tab indent and unident on visual mode
  vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })
  vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

  -- Setting Shift+Tab to Unindent in insert mode
  vim.keymap.set('i', '<S-Tab>', function()
    local col = vim.fn.col '.'
    local line = vim.fn.getline '.'
    local shift_width = vim.bo.shiftwidth

    -- Check if we're at the start of the line if there are only spaces before the cursor
    if col == 1 or line:sub(1, col - 1):match '^%s*$' then
      return string.rep('\b', shift_width) -- Standard dedent
    else
      -- Count spaces before cursor
      local spaces_before = line:sub(1, col - 1):match '(%s*)$'
      local num_spaces = #spaces_before

      -- Calculate how many spaces to remove
      local spaces_to_remove = num_spaces % shift_width
      if spaces_to_remove == 0 then
        spaces_to_remove = shift_width
      end

      -- Remove the calculated number of spaces
      return string.rep('\b', spaces_to_remove)
    end
  end, { noremap = true, expr = true })
end

return M
