local opt = vim.opt

-- ---------------------------------------------------------------------------
-- General
-- ---------------------------------------------------------------------------
opt.backspace = { "indent", "eol", "start" }
opt.hidden = true -- allow switching buffers without saving
opt.mouse = "a" -- mouse support in all modes
opt.clipboard:prepend({ "unnamed", "unnamedplus" }) -- use system clipboard where available
opt.updatetime = 300
opt.signcolumn = "yes"

-- Keep swap/backup/undo files out of the working directory
local data = vim.fn.stdpath("data")
local swapdir = data .. "/swap"
local backupdir = data .. "/backup"
local undodir = data .. "/undo"

opt.directory = swapdir .. "//"
opt.backupdir = backupdir .. "//"
opt.undodir = undodir .. "//"
opt.undofile = true

for _, dir in ipairs({ swapdir, backupdir, undodir }) do
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p", "0700")
  end
end

-- ---------------------------------------------------------------------------
-- UI
-- ---------------------------------------------------------------------------
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showcmd = true
opt.wildmenu = true
opt.laststatus = 2
opt.scrolloff = 5
opt.cursorline = true
opt.termguicolors = true
vim.cmd.colorscheme("desert")

-- ---------------------------------------------------------------------------
-- Indentation
-- ---------------------------------------------------------------------------
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- ---------------------------------------------------------------------------
-- Search
-- ---------------------------------------------------------------------------
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- ---------------------------------------------------------------------------
-- Splits
-- ---------------------------------------------------------------------------
opt.splitright = true
opt.splitbelow = true
