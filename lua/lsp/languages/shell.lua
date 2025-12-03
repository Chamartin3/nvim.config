local M

M = {
  zsh = {
    lsp = { 'bashls' },
    formatter = {
      'beautysh',
      'shfmt',
    },
    linters = { 'shellcheck' },
    parsers = { 'bash' },
  },
  shell = {
    lsp = { 'bashls' },
    formatter = 'shfmt',
    linters = { 'shellcheck' },
    parsers = { 'bash' },
    debug = { 'bash-debug-adapter' },
  },
  dockerfile = {
    lsp = { 'dockerls' },
    linters = { 'hadolint' },
    parsers = { 'dockerfile' },
  },
  docker_compose_yaml = {
    lsp = { 'docker_compose_language_service' },
    parsers = {},
  },
  cmake = {
    lsp = { 'neocmake' },
    parsers = { 'cmake' },
  },
}

return M
