-- ps://github.com/sumneko/lua-language-server

local M = {
  lua = {
    lsp = {
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            runtime = { version = 'LuaJIT' },
            diagnostics = {
              globals = { 'vim', 'require' },
            },
            format = {
              enable = false,
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
    },
    formatter = 'stylua',
    parsers = { 'lua', 'luadoc' },
    debug = { 'local-lua-debugger-vscode' },
  },
}

return M
