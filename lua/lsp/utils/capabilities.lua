-- local default_capabilities = {
--   textDocument = {
--     publishDiagnostics = {
--       relatedInformation = true,
--       versionSupport = true,
--     },
--   },
--   workspace = {
--     configuration = true,
--   },
--   experimental = {
--     semanticTokens = {
--       refreshSupport = true,
--     },
--   },
-- }
local M = {}
local client_capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local function get_merged_capabilities(server_capabilities)
  return vim.tbl_deep_extend('force', client_capabilities, cmp_capabilities, server_capabilities or {})
end

M.get_capabilities = get_merged_capabilities
M.client_capabilities = client_capabilities
M.cmp_capabilities = cmp_capabilities

return M
