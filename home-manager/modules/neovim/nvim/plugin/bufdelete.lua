local ok, _ = pcall(require, "bufdelete")
if not ok then
  return
end

-- keymap to delete buffer
vim.keymap.set('n', '<C-q>', '<cmd>Bdelete<cr>', { noremap = true, silent = true })
