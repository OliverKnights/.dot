local o = vim.o
local cmd = vim.cmd
local g = vim.g

local api = vim.api
local nmap=api.nvim_set_keymap

o.autoread=true -- source file changes
o.background='light'
o.clipboard='unnamedplus' -- copy to system clipboard always
o.hidden=true -- change buffers without saving
o.history=10000 -- remember : commands
o.ignorecase=true -- ignore case in searching
o.smartcase=true -- if we use caps in search, turn off ignore case
o.inccommand='nosplit' -- show replacements in place 
o.infercase=true -- smarter completion
o.mouse='a'
o.viewoptions='folds,cursor,curdir' -- don't save locally modified options
o.lazyredraw=true -- don't update screen during macros

o.completeopt = "menuone,noselect" -- suggested settings for completion

o.autoindent=true
o.smartindent=true

o.splitbelow=true
o.splitright=true

o.swapfile=false

o.undofile=true

g.browsedir='buffer'

o.path='.,,**'
o.wildignore='*/vendor/*,*.tar.gz'
o.runtimepath=o.runtimepath .. vim.fn.expand(',$HOME/.fzf')

g.mapleader=" "

nmap('n', '<Leader>zf', ':FZF<CR>', { noremap = true })

nmap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

nmap('n', '<Leader>gr', ':silent grep --exclude=\'*.tar.gz\' -R \'\' .<left><left><left>', { noremap = true })

nmap('n', '<Leader>ss', ':mksession! ~/.local/share/nvim/session/', { noremap = true })
nmap('n', '<Leader>so', ':source ~/.local/share/nvim/session/', { noremap = true })

nmap('n', '<Leader>bo', ':bro ol<CR>', { noremap = true })

nmap('n', '<Leader>vi', '<cmd>e $MYVIMRC<cr>', { noremap = true })
nmap('n', '<Leader>vr', '<cmd>source $MYVIMRC<cr>', { noremap = true })
nmap('n', '<Leader>vl', '<cmd>luafile %<cr>', { noremap = true })

nmap('n', '<Leader>fi', ':fin<space>', { noremap = true })

-- Disable netrw, but autoload it for `gx`.
cmd('let g:loaded_netrwPlugin = 0')
nmap('n', 'gx', '<Plug>NetrwBrowseX', {})
nmap('n', '<Plug>NetrwBrowseX', ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>', { noremap = true, silent = true })

cmd('augroup make_view')
cmd('autocmd!')
cmd('autocmd BufWinLeave *.* mkview')
cmd('autocmd BufWinEnter *.* silent! loadview')
cmd('augroup END')

cmd('let g:tmux_navigator_no_mappings = 1')

nmap('n', '<M-h>', ':silent TmuxNavigateLeft<cr>', { noremap = true })
nmap('n', '<M-j>', ':silent TmuxNavigateDown<cr>', { noremap = true })
nmap('n', '<M-k>', ':silent TmuxNavigateUp<cr>', { noremap = true})
nmap('n', '<M-l>', ':silent TmuxNavigateRight<cr>', { noremap = true})
nmap('n', '<M-\\>', ':silent TmuxNavigatePrevious<cr>', { noremap = true})
nmap('i', '<M-h>', '<esc>:silent TmuxNavigateLeft<cr>', { noremap = true })
nmap('i', '<M-j>', '<esc>:silent TmuxNavigateDown<cr>', { noremap = true })
nmap('i', '<M-k>', '<esc>:silent TmuxNavigateUp<cr>', { noremap = true})
nmap('i', '<M-l>', '<esc>:silent TmuxNavigateRight<cr>', { noremap = true})
nmap('i', '<M-\\>', '<esc>:silent TmuxNavigatePrevious<cr>', { noremap = true})

-- Automatically source changes
cmd('autocmd BufWritePost plugins.lua source <afile> | PackerCompile')

require'plugins'


