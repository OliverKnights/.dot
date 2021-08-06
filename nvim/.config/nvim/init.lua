local o = vim.o
local cmd = vim.cmd
local g = vim.g

local api = vim.api
local map=api.nvim_set_keymap

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
cmd([[set wildcharm=<tab>]])

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

map('n', '<Leader>zf', ':FZF<CR>', { noremap = true })

map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

map('n', '<Leader>gr', ':silent grep --exclude-dir=.git --exclude-dir=node_modules --exclude=\'*.tar.gz\' -R \'\' .<left><left><left>', { noremap = true })

map('n', '<Leader>ss', ':mksession! ~/.local/share/nvim/session/', { noremap = true })
map('n', '<Leader>so', ':source ~/.local/share/nvim/session/', { noremap = true })

map('n', '<Leader>bo', ':bro ol<CR>', { noremap = true })

map('n', '<Leader>vi', '<cmd>e $MYVIMRC<cr>', { noremap = true })
map('n', '<Leader>vr', '<cmd>source $MYVIMRC<cr>', { noremap = true })
map('n', '<Leader>vl', '<cmd>luafile %<cr>', { noremap = true })

map('n', '<Leader>fi', ':fin<space>', { noremap = true })

map('n', '<Leader>;', ':', { noremap = true })

-- Disable netrw, but autoload it for `gx`.
cmd('let g:loaded_netrwPlugin = 0')
map('n', 'gx', '<Plug>NetrwBrowseX', {})
map('n', '<Plug>NetrwBrowseX', ':call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : "<cfile>")),netrw#CheckIfRemote())<CR>', { noremap = true, silent = true })

cmd('augroup make_view')
cmd('autocmd!')
cmd('autocmd BufWinLeave *.* mkview')
cmd('autocmd BufWinEnter *.* silent! loadview')
cmd('augroup END')

cmd('let g:tmux_navigator_no_mappings = 1')

map('n', '<M-h>', ':silent TmuxNavigateLeft<cr>', { noremap = true })
map('n', '<M-j>', ':silent TmuxNavigateDown<cr>', { noremap = true })
map('n', '<M-k>', ':silent TmuxNavigateUp<cr>', { noremap = true})
map('n', '<M-l>', ':silent TmuxNavigateRight<cr>', { noremap = true})
map('n', '<M-\\>', ':silent TmuxNavigatePrevious<cr>', { noremap = true})
map('i', '<M-h>', '<esc>:silent TmuxNavigateLeft<cr>', { noremap = true })
map('i', '<M-j>', '<esc>:silent TmuxNavigateDown<cr>', { noremap = true })
map('i', '<M-k>', '<esc>:silent TmuxNavigateUp<cr>', { noremap = true})
map('i', '<M-l>', '<esc>:silent TmuxNavigateRight<cr>', { noremap = true})
map('i', '<M-\\>', '<esc>:silent TmuxNavigatePrevious<cr>', { noremap = true})

-- Automatically source changes
cmd('autocmd BufWritePost plugins.lua source <afile> | PackerCompile')

require'plugins'

cmd([[let g:sh_fold_enabled=1]])

-- cmd([[
-- call wilder#enable_cmdline_enter()
-- cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
-- cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
-- call wilder#set_option('modes', [':'])
-- call wilder#set_option('pipeline', [ wilder#branch(wilder#cmdline_pipeline({'language': 'python', 'fuzzy': 1, }), wilder#python_search_pipeline({ 'pattern': wilder#python_fuzzy_pattern(), 'sorter': wilder#python_difflib_sorter(), 'engine': 're', }))])
-- call wilder#set_option('renderer', wilder#popupmenu_renderer({'highlighter': wilder#basic_highlighter()}))
-- ]])
