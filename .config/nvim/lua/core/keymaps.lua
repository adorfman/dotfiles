vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

vim.keymap.set("n", "<leader>tf", ":Telescope find_files<CR>", 
               {noremap = true, silent = true, desc = "Find Files"})

vim.keymap.set("n", "<leader>tb", ":Telescope buffers<CR>", 
               {noremap = true, silent = true, desc = "Find Buffers"})

vim.keymap.set("n", "<leader>th", ":Telescope themes<CR>", 
               {noremap = true, silent = true, desc = "Theme Switcher"})
