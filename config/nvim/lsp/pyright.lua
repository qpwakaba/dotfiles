local cmd
if vim.fn.executable('npx') then
  cmd = { 'npx', '--package=pyright', '--', 'pypright-langserver', '--stdio' }
elseif vim.fn.executable('pyright') then
  cmd = { 'pyright', '--stdio' }
else
  return {
    cmd = { 'true' },
  }
end

return {
  -- Command and arguments to start the server.
  cmd = cmd,
  -- Filetypes to automatically attach to.
  filetypes = { 'python' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { {'pyrightconfig.json', 'pyproject.toml'}, '.git', '.env' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}
