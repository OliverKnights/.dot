-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'justinmk/vim-dirvish',
    config = function()
      vim.cmd([[
        augroup dirvish_config
          autocmd!
          autocmd FileType dirvish nnoremap <silent><buffer> D :Shdo rm -rf {}<CR> 
        augroup END
      ]])
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      }
    end
  }

  use {
    'kristijanhusak/orgmode.nvim',
    config = function()
      require('orgmode').setup{}
    end
  }

  use {
    'tpope/vim-dadbod'
  }

  use {
    'kristijanhusak/vim-dadbod-ui'
  }

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  use 'airblade/vim-rooter'
  
  use {
    'junegunn/fzf.vim',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>bl', '<cmd>Buffers<cr>', { noremap=true, silent=true })
      vim.api.nvim_set_keymap('n', '<Leader>fl', '<cmd>Files<cr>', { noremap=true, silent=true })
      vim.api.nvim_set_keymap('n', '<Leader>pr', '<cmd>Rg<cr>', { noremap=true, silent=true })
    end
  }

  use {
    'tpope/vim-fugitive',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>gs', '<cmd>vert G<cr>', { noremap=true, silent=true })
    end
  }

  use 'tpope/vim-eunuch'
  use 'tpope/vim-commentary'
  use 'tpope/vim-endwise'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-unimpaired'

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      local nvim_lsp = require('lspconfig')

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

      end

      -- Use a loop to conveniently call 'setup' on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = { 'pyright', 'bashls', 'gopls' }
      for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          }
        }
      end
    end
  }
end)
