set nocompatible          " get rid of Vi compatibility mode. SET FIRST!
filetype plugin indent on " filetype detection[ON] plugin[ON] indent[ON]
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
colorscheme desert        " set colorscheme
set number                " show line numbers
set laststatus=2          " last window always has a statusline
filetype indent on        " activates indenting for files
set nohlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
set ruler                 " Always show info along bottom.
set autoindent            " auto-indent
set tabstop=4             " tab spacing
set softtabstop=4         " unify
set shiftwidth=4          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smarttab              " use tabs at the start of a line, spaces elsewhere
set nowrap                " don't wrap text

" Wrap text at 72 characters while writing a Git commit message
autocmd FileType gitcommit setlocal textwidth=72

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Highlight current line
set cursorline
" Show “invisible” characters
" set list
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells

" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" Windows movement
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Change the directory view in netrw
let g:netrw_liststyle = 4

" Open files in a new tab
let g:netrw_browse_split = 3

" Set the width of the directory explorer
let g:netrw_winsize = 25

" Auto-reload vim configuration
augroup myvimrc
    au!
    au BufWritePost .vimrc,vimrc so $MYVIMRC
augroup END

" Ctags search
set tags=./tags;$HOME

" Set f5 to generate tags 
nnoremap <f5> :!ctags -R<CR>

" Auto-update tags for python
autocmd BufWritePost *.py silent! !ctags -R .

