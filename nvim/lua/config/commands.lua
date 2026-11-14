-- ---------------------------------------------------------------------------
-- clang-tidy
-- ---------------------------------------------------------------------------
local function run_clang_tidy()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file to run clang-tidy on", vim.log.levels.WARN)
    return
  end

  local db = vim.fn.findfile("compile_commands.json", vim.fn.expand("%:p:h") .. ";")
  local cmd = "clang-tidy " .. vim.fn.shellescape(file)
  if db ~= "" then
    cmd = cmd .. " -p " .. vim.fn.shellescape(vim.fn.fnamemodify(db, ":h"))
  else
    cmd = cmd .. " --"
  end

  vim.o.makeprg = cmd
  vim.cmd("silent make!")
  vim.cmd("botright cwindow")
  vim.cmd("redraw!")
end

vim.api.nvim_create_user_command("ClangTidy", run_clang_tidy, {})
vim.keymap.set("n", "<leader>ct", run_clang_tidy)

-- ---------------------------------------------------------------------------
-- clang-format
-- ---------------------------------------------------------------------------
local function run_clang_format()
  local bin = vim.fn.executable("clang-format") == 1 and "clang-format" or "clang-format-21"
  if vim.fn.executable(bin) == 0 then
    vim.notify("clang-format not found in PATH", vim.log.levels.WARN)
    return
  end

  local view = vim.fn.winsaveview()
  vim.cmd("silent %!" .. bin .. " --assume-filename=" .. vim.fn.shellescape(vim.fn.expand("%")))
  if vim.v.shell_error ~= 0 then
    vim.cmd("undo")
    vim.notify("clang-format failed, buffer left unchanged", vim.log.levels.WARN)
  end
  vim.fn.winrestview(view)
end

vim.api.nvim_create_user_command("ClangFormat", run_clang_format, {})
vim.keymap.set("n", "<leader>cf", run_clang_format)
