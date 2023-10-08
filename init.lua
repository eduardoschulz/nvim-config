--vim.o.termguicolors = true
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
--vim.wo.signcolumn = 'yes'
vim.wo.wrap = false
vim.g.mapleader = ' '
--colorscheme setup
vim.cmd.colorscheme "catppuccin"

require("catppuccin").setup({
  flavour = "macchiato",
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
        treesitter = true,
        notify = false,
        semantic_tokens = true,
        mini = false,
    }})



-- Telescope 
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- treesitter
local config = require'nvim-treesitter.configs'

config.setup {
  --ensure_installed = "maintained",
  hightlight = {
    enable = true,
  }
}



-- cmp config

local cmp = require'cmp'
cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
     completion = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'buffer' },
      })
  })

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

--cmp.setup.cmdline(':', {
--    mapping = cmp.mapping.preset.cmdline(),
--    sources = cmp.config.sources({
--        { name = 'path' }
--      }, {
--        { name = 'cmdline' }
--      })
--  })

-- lsp config
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    
require('lspconfig')['gopls'].setup {
    capabilities = capabilities
} 

require ('lspconfig')['pyright'].setup {
  capabilities = capabilities
}

require ('lspconfig')['clangd'].setup {
  capabilities = capabilities
}
-- setup of lsp servers here
--lspconfig.pyright.setup(default_config)
--lspconfig.gopls.setup(default_config)

--lsp mappings
vim.keymap.set ('n', '<leader>e', vim.diagnostic.open_float)

vim.keymap.set ('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set ('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set ('n', '<leader>q', vim.diagnostic.setloclist)


-- packer installation

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use { "catppuccin/nvim", name = "catppuccin"}
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use 'nvim-treesitter/nvim-treesitter'
  use 'sheerun/vim-polyglot'
  use {'prettier/vim-prettier', run = 'yarn install' }
  
  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/vim-vsnip'
  use 'github/copilot.vim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)











