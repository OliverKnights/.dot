-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
      }
    end
  }
  
  use {
    "tpope/vim-vinegar"
  }

  use "nvim-lua/plenary.nvim"

  use {
    'kristijanhusak/orgmode.nvim',
    config = function()
      require('orgmode').setup{}
    end
  }

  use {
    'nvim-neorg/neorg',
    config = function()
      require('neorg').setup {
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.norg.concealer"] = {}, -- Allows for use of icons
          ["core.keybinds"] = { -- Configure core.keybinds
            config = {
              default_keybinds = true, -- Generate the default keybinds
              neorg_leader = "<Leader>o" -- This is the default if unspecified
            }
          },
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
          config = {
            workspaces = {
              my_workspace = "~/src/wiki"
            }
          }
        }
      },
    }
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
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

      parser_configs.norg = {
        install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg",
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main"
        }
      }

      require('nvim-treesitter.configs').setup {
        ensure_installed = { "norg", "haskell", "cpp", "c", "javascript", "go", "python" },
      }
    end
  }

  use {
    'romgrk/nvim-treesitter-context',
    config = function()
      require'treesitter-context'.setup{
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          throttle = true, -- Throttles plugin updates (may improve performance)
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim 
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",

              -- Or you can define your own textobjects like this
              ["iF"] = {
                python = "(function_definition) @function",
                cpp = "(function_definition) @function",
                c = "(function_definition) @function",
                java = "(method_declaration) @function",
              },
            },
          },
        },
      }
    end
  }

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
      local servers = { 'pyright', 'bashls', 'gopls', 'ccls' }
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
