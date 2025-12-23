local K = {}

function K.setup()
  vim.keymap.set('n', '<M-w>', ':vsplit<CR>', { noremap = true, silent = true }) -- open split window
  vim.keymap.set('n', '<M-e>', '<C-w>=', { noremap = true, silent = true }) -- equal size split window
  vim.keymap.set('n', '<M-f>', '<C-w>|', { noremap = true, silent = true }) -- toggle full size
  vim.keymap.set('n', '<M-s>', '<C-w>x', { noremap = true, silent = true }) -- toggle swap windows
  vim.keymap.set('n', '<M-Right>', '<C-w>>', { noremap = true, silent = true }) -- increase/decrease size to the right
  vim.keymap.set('n', '<M-Left>', '<C-w><', { noremap = true, silent = true }) -- increase/decrease size to the left
  vim.keymap.set('n', '<M-q>', ':close<CR>', { noremap = true, silent = true }) -- close window
end

return K
