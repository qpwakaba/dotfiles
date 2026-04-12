vim.lsp.config['rust-analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { { 'Cargo.toml', 'Cargo.lock' }, '.git', '.env' },
  settings = {

  },
}
