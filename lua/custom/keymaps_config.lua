local K = {}

function K.setup()
  -- INFO: Window management
  vim.keymap.set('n', '<M-w>', ':vsplit<CR>', { noremap = true, silent = true }) -- open split window
  vim.keymap.set('n', '<M-e>', '<C-w>=', { noremap = true, silent = true }) -- equal size split window
  vim.keymap.set('n', '<M-f>', '<C-w>|', { noremap = true, silent = true }) -- toggle full size
  vim.keymap.set('n', '<M-s>', '<C-w>x', { noremap = true, silent = true }) -- toggle swap windows
  vim.keymap.set('n', '<M-Right>', '<C-w>>', { noremap = true, silent = true }) -- increase/decrease size to the right
  vim.keymap.set('n', '<M-Left>', '<C-w><', { noremap = true, silent = true }) -- increase/decrease size to the left
  vim.keymap.set('n', '<M-q>', ':close<CR>', { noremap = true, silent = true }) -- close window

  vim.keymap.set('n', '<leader>bo', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })

  -- Navigate out of terminal buffers with the same ALT+h/l bindings with f for full size toggle
  vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window from terminal' })
  vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window from terminal' })
  vim.keymap.set('t', '<A-f>', '<C-\\><C-n><C-w>|', { desc = 'Toggle full size terminal' })
  vim.keymap.set('t', '<A-e>', '<C-\\><C-n><C-w>=', { desc = 'Equal size split terminal with buffer' })

  -- INFO: Creating scratch buffer for different file types
  vim.keymap.set('n', '<leader>dn', function()
    vim.ui.input({ prompt = 'Scratch filetype (leave blank for none): ' }, function(ft)
      vim.cmd 'vnew'
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
      if ft and ft ~= '' then
        vim.bo.filetype = ft
      end
      -- vim.cmd 'diffthis | wincmd p | diffthis'
    end)
  end, { desc = 'Diff with new scratch buffer' })
end

return K
