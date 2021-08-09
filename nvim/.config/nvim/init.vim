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

set viewoptions=folds,cursor,curdir " don't save locally modified options
set lazyredraw " don't update screen during macros
set wildcharm=<tab>
set autoindent
set smartindent

set splitbelow
set splitright

set noswapfile

set undofile

set browsedir=buffer

set path=.,,**
set wildignore=*/vendor/*,*.tar.gz

set runtimepath^=expand(',$HOME/.fzf')

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

tnoremap <Esc> <C-\><C-n>

let mapleader=" "
nnoremap <Leader>gr :grep --exclude='*.tar.gz' --exclude-dir=.git --exclude-dir=node_modules -R '' .<left><left><left>

nnoremap <Leader>ss :mksession! ~/.local/share/nvim/session/
nnoremap <Leader>so :source ~/.local/share/nvim/session/

nnoremap <Leader>zf <cmd>FZF<CR>

nnoremap <Leader>bo :bro ol<CR>

nnoremap <Leader>vi <cmd>e $MYVIMRC<cr>
nnoremap <Leader>vr <cmd>source $MYVIMRC<cr>

nnoremap <Leader>fi :fin<space>

" Open in browser
let g:loaded_netrwPlugin = 0
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<CR>

augroup make_view
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END
