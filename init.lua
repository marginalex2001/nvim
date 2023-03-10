-----------------------------------------------------
-------------------ОБЩИЕ НАСТРОЙКИ-------------------
-----------------------------------------------------

vim.cmd([[
filetype indent plugin on
syntax enable
]])

vim.opt.mouse = 'a'
vim.opt.number = true            --Номер строк сбоку
vim.opt.tabstop = 4              --1 tab = 4 пробела
vim.opt.smartindent = true
vim.opt.shiftwidth = 4           --Смещаем на 4 пробела
vim.opt.colorcolumn =  '110'

vim.opt.ignorecase = true        --Игнорировать размер букв
vim.opt.smartcase = true         --Игнор прописных буквj



-----------------------------------------------------
-------------------КЕЙМАПЫ---------------------------
-----------------------------------------------------

vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>NERDTreeToggle<cr>', {noremap = true})
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', {noremap = true})
vim.api.nvim_set_keymap('', '<F8>', '<cmd>TagbarToggle<cr>', {noremap = true, silent = true})

-- мапы для телескопа
local builtin = require('telescope.builtin')
vim.keymap.set('n', ',ff', builtin.find_files, {})
vim.keymap.set('n', ',fg', builtin.live_grep, {})
vim.keymap.set('n', ',fb', builtin.buffers, {})
vim.keymap.set('n', ',fh', builtin.help_tags, {})

  -- You dont need to set any of these options. These are the default ones. Only
  -- the loading is important
  require('telescope').setup {
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
      }
    }
  }
-- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  -- require('telescope').load_extension('fzf')


-----------------------------------------------------
-------------------AUTOCOMPLETE----------------------
-----------------------------------------------------
--языковые сервера
require'lspconfig'.pyright.setup{}
require'lspconfig'.clangd.setup{}

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'pyright' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-----------------------------------------------------
-------------------ПЛАГИНЫ---------------------------
-----------------------------------------------------


vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --дерево папок
  use 'preservim/nerdtree'

  --автодополнение скобок
  use 'jiangmiao/auto-pairs'

  --бар справа
  use 'preservim/tagbar'

  --работа с git
  use 'tpope/vim-fugitive'
  use 'airblade/vim-gitgutter'

  --терминаль
  --use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  --  require("toggleterm").setup()
  --end}
  
  -- vim telescope удобный поиск
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Комментирует по <gc> все, вне зависимости от языка программирования
  use { 'numToStr/Comment.nvim',
      config = function()
      require('Comment').setup()
  end }

  --тема
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  })

  --нижний бар
  use "kyazdani42/nvim-web-devicons"
  use { 'nvim-lualine/lualine.nvim',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      config = function()
      require('lualine').setup()
  end, }

  --LSP
  use 'neovim/nvim-lspconfig'
  --autocomplete
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets pluginp

end)
