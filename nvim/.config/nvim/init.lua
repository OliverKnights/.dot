local o = vim.o
local g = vim.g

local api = vim.api
local nmap=api.nvim_set_keymap

o.shiftwidth=2 -- spaces to indent by
o.tabstop=2 -- spaces <Tab> is in the file
o.softtabstop=2 -- spaces <Tab> is when editing
o.expandtab=true -- use spaces
o.autoread=true -- source file changes
o.autowriteall=true -- auto save
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

o.autoindent=true
o.smartindent=true

o.splitbelow=true
o.splitright=true

o.swapfile=false

o.undofile=true

g.browsedir='buffer'

o.path='.,,**'
o.wildignore='*/vendor/*,*.tar.gz'

nmap('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

g.mapleader=" "
nmap('n', '<Leader>gr', ':silent grep --exclude=\'*.tar.gz\' -R \'\' .<left><left><left>', { noremap = true })

nmap('n', '<Leader>bo', ':bro ol<CR>', { noremap = true })

nmap('n', '<Leader>vi', '<cmd>e $MYVIMRC<cr>', { noremap = true })
nmap('n', '<Leader>vr', '<cmd>source $MYVIMRC<cr>', { noremap = true })
nmap('n', '<Leader>vl', '<cmd>luafile %<cr>', { noremap = true })
nmap('n', '<Leader>vL', '<cmd>e ~/.config/nvim/lua<cr>', { noremap = true })

nmap('n', '<Leader>fi', ':fin<space>', { noremap = true })

-- Open in browser
nmap('n', 'gx', '<Plug>NetrwBrowseX', {})
nmap('n', '<Plug>NetrwBrowseX', ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>', { noremap = true, silent = true })

api.nvim_command('augroup make_view')
api.nvim_command('autocmd!')
api.nvim_command('autocmd BufWinLeave *.* mkview')
api.nvim_command('autocmd BufWinEnter *.* silent! loadview')
api.nvim_command('augroup END')
