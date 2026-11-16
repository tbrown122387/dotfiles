-- Add plugin specs here (or as new files in this directory) as they come up.
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index" },
      })
      vim.lsp.enable("clangd")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = vim.keymap.set
          local opts = { buffer = args.buf }
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "<C-LeftMouse>", function()
            vim.cmd("exec \"normal! \\<LeftMouse>\"")
            vim.lsp.buf.definition()
          end, opts)
        end,
      })
    end,
  },
}
