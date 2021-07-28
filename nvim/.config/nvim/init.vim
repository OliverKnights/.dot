set shiftwidth=2 " spaces to indent by
set tabstop=2 " spaces <Tab> is in the file
set softtabstop=2 " spaces <Tab> is when editing
set expandtab " use spaces
set autoread " source file changes
set autowriteall " auto save
set background=light
set clipboard=unnamedplus " copy to system clipboard always
set hidden " change buffers without saving
set history=10000 " remember : commands
set ignorecase " ignore case in searching
set smartcase " if we use caps in search, turn off ignore case
set inccommand=nosplit " show replacements in place 
set infercase " smarter completion
set mouse=a

set autoindent
set smartindent

set splitbelow
set splitright

set noswapfile

set undofile

set browsedir=buffer

set path=.,,**
set wildignore=*/vendor/*,*.tar.gz

tnoremap <Esc> <C-\><C-n>

let mapleader=" "
nnoremap <Leader>gr :silent grep --exclude='*.tar.gz' -R '' .<left><left><left>

nnoremap <Leader>bo :bro ol<CR>

nnoremap <Leader>vi <cmd>e $MYVIMRC<cr>
nnoremap <Leader>vr <cmd>source $MYVIMRC<cr>
nnoremap <Leader>vl <cmd>luafile %<cr>
nnoremap <Leader>vL <cmd>e ~/.config/nvim/lua<cr>

nnoremap <Leader>fi :fin<space>

" Open in browser
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<CR>

augroup make_view
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END
