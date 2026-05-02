-- 1. Менеджер плагинов (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Список плагинов
require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Тема
  { "neovim/nvim-lspconfig" },             -- Конфиг для подсказок (LSP)
  { "hrsh7th/nvim-cmp" },                  -- Движок подсказок
  { "hrsh7th/cmp-nvim-lsp" },              -- Подсказки от компилятора
  { "L3MON4D3/LuaSnip" },                  -- Сниппеты
  { "williamboman/mason.nvim" },           -- Установщик серверов
  { "williamboman/mason-lspconfig.nvim" },
})

-- 3. Настройки темы (Прозрачность + Стиль)
require("catppuccin").setup({
  transparent_background = true,
  term_colors = true,
  styles = { sidebars = "transparent", floats = "transparent" }
})
vim.cmd.colorscheme "catppuccin-mocha"

-- 4. Основные настройки
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'

-- Жесткая настройка табов
vim.opt.tabstop = 4       -- Визуальная ширина таба
vim.opt.softtabstop = 4   -- Сколько пробелов вставляется при нажатии Tab
vim.opt.shiftwidth = 4    -- Ширина автоматического отступа
vim.opt.expandtab = true  -- Превращать табы в пробелы (обязательно!)
vim.opt.smartindent = true

-- На всякий случай отключаем авто-определение табов из файлов (иногда мешает)
vim.g.sleuth_automatic = 0

-- 5. Настройка подсказок (Auto-completion)
local cmp = require('cmp')
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter выбирает подсказку
    ['<Tab>'] = cmp.mapping.select_next_item(),        -- Tab листает вниз
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),     -- Shift+Tab листает вверх
  }),
  sources = cmp.config.sources({ { name = 'nvim_lsp' } })
})

-- 6. Подключаем C++ (clangd)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Вместо require('lspconfig').clangd.setup используем новый метод:
vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
})
vim.lsp.enable('clangd')
