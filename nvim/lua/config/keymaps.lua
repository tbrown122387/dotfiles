vim.g.mapleader = ","

local map = vim.keymap.set

-- Clear search highlight
map("n", "<leader><space>", ":nohlsearch<CR>", { silent = true })

-- Move between splits with Ctrl+hjkl
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Quick save/quit
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")
