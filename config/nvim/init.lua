vim.opt.compatible = false
vim.api.nvim_create_augroup('init.lua', { clear = true })

local dein_vim = vim.fn.stdpath("config") .. "/dein/dein.vim"
local localconf = "$HOME/.local/config/nvim/init.lua"


if vim.fn.filereadable(dein_vim) == 1 then
  if vim.fn.exists("g:dein#_plugins") == 0 then
    vim.cmd("source " .. dein_vim)
  end
end


vim.keymap.set('n', 'r<C-c>', '<Nop>', {})
vim.keymap.set('n', '<C-w><C-c>', '<Nop>', {})
vim.keymap.set('n', '<C-w>c', '<Nop>', {})
vim.keymap.set('n', '<C-w>c', '<Nop>', {})
vim.keymap.set('c', '<C-a>', '<Home>', {})
vim.keymap.set('c', '<C-e>', '<End>', {})
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>', { silent = true })
--vim.keymap.set('n', '<C-k><C-k>', vim.lsp.buf.hover, { silent = true })
vim.keymap.set('n', 'gf', function() vim.lsp.buf.format({ async = true }) end, { silent = true })
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, { silent = true })
vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { silent = true })
vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, { silent = true })
vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, { silent = true })
-- vim.keymap.set('n', 'gt', function() vim.lsp.buf.type_definition() end, { silent = true })
vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, { silent = true })
vim.keymap.set('n', '<C-k>.', function() vim.lsp.buf.code_action() end, { silent = true })
-- vim.keymap.set('n', 'ge', function() vim.diagnostic.open_float() end, { silent = true })
vim.keymap.set('n', 'g]', function() vim.diagnostic.goto_next() end, { silent = true })
vim.keymap.set('n', 'g[', function() vim.diagnostic.goto_prev() end, { silent = true })
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', {})

vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.infercase = false
vim.opt.fileignorecase = true
vim.opt.equalalways = false
vim.opt.undofile = true
vim.opt.completeopt = 'fuzzy,menuone,noinsert,popup'

vim.opt.list = true
vim.opt.listchars = { trail = '␣', tab = '-->' }

-- use osc52 clipboard
vim.g.clipboard = "osc52"


local function vimrc_local(loc)
  local escaped = vim.fn.escape(loc, " ")
  local files = vim.fn.findfile(".vimrc.local", escaped .. ";", -1)

  for i = #files, 1, -1 do
    local f = files[i]
    if vim.fn.filereadable(f) == 1 then
      vim.cmd("source " .. vim.fn.fnameescape(f))
    end
  end
end
vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
  group = 'init.lua',
  callback = function()
    vimrc_local(vim.fn.expand("%:p:h"))
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = 'init.lua',
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})


if vim.fn.filereadable(localconf) == 1 then
  dofile(localconf)
end

-- lsp settings

vim.lsp.enable('pyright')
vim.lsp.enable('rust-analyzer')

vim.api.nvim_create_autocmd("LspAttach", {
  group = 'init.lua',
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "<C-Space>", vim.lsp.buf.hover, { buffer = args.buf })
  end,
})

-- automatic update location list
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  group = 'init.lua',
  callback = function(args)
    for _, win in ipairs(vim.fn.win_findbuf(args.buf)) do
      vim.api.nvim_win_call(win, function()
        vim.diagnostic.setloclist({ bufnr = args.buf, open = false })
      end)
    end
  end,
})

-- automatic synchronization cursor position and location list
local function sync_loclist_index()
  local bufnr = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)
  local lnum = pos[1]
  local col = pos[2] + 1  -- 1-based

  local loclist = vim.fn.getloclist(0)

  local best_idx = nil
  local best_dist = nil

  for i, item in ipairs(loclist) do
    if item.bufnr == bufnr and item.lnum == lnum then
      local item_col = item.col or 1
      local dist = math.abs(item_col - col)

      if best_dist == nil or dist < best_dist then
        best_dist = dist
        best_idx = i
      end
    end
  end

  if best_idx then
    vim.fn.setloclist(0, {}, 'r', { idx = best_idx })
  end
end

vim.api.nvim_create_autocmd("CursorMoved", {
  group = 'init.lua',
  callback = sync_loclist_index,
})


-- disable automatic closing terminal on process exit
vim.api.nvim_clear_autocmds({
  group = "nvim.terminal",
  event = "TermClose",
})

vim.api.nvim_create_autocmd("TermClose", {
  group = 'init.lua',
  pattern = "*",
  callback = function()
    vim.cmd("stopinsert")
  end,
})

-- restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)

    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
