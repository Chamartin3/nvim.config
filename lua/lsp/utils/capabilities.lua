local default_capabilities = {
  textDocument = {
    publishDiagnostics = {
      relatedInformation = true,
      versionSupport = true,
    },
  },
  workspace = {
    configuration = true,
  },
  experimental = {
    semanticTokens = {
      refreshSupport = true,
    },
  },
}

local client_capabilities = vim.lsp.protocol.make_client_capabilities()

local custom_configs = {
  workspace = {
    didChangeWatchedFiles = { dynamicRegistration = false },
  },
}

return vim.tbl_deep_extend('force', default_capabilities, client_capabilities, custom_configs)
