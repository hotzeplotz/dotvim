" my vimrc - initially populated with a few lines from my historic vimrc and a
" lot of cool stuff from scribu's dotvim archive
"
"" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load Pathogen
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

set fileencodings=utf-8 guifont="Droid Sans Mono" encoding=utf-8 tabstop=2
syntax enable
set background=light
colorscheme solarized

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup	" do not keep a backup file, use versions instead

set history=100
set ruler	" show the cursor position all the time
set showcmd	" display incomplete commands
set incsearch	" do incremental searching
set undofile " remember undo changes between sessions

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Enable file type detection.
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\ exe "normal! g`\"" |
\ endif
augroup END

" Replaces the current selection with whatever is in the " register;
" Since it doesn't overwrite the " register, it can be used multiple times.
vmap r "_dP

" Smaller tabs
set tabstop=2 shiftwidth=2

" Use 4 spaces instead of tabs for Python files
autocmd FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Always hide ~ files
let g:netrw_list_hide = '\~$'

" Easily set current directory to current file
map ,cd :lcd %:p:h<CR>:pwd<CR>

" ack-grep config
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" Automatically remove trailing spaces
autocmd FileType php,js,css autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" Save using 'Ctrl s' and return to insert mode
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S> <C-O>:update<CR>

" syntastic config
let g:syntastic_phpcs_disable = 1

" Automatically show the tag list when there are multiple matches
noremap <silent> <C-]> g<C-]>

" Use pman to look up PHP functions
autocmd FileType php setlocal keywordprg=pman

" DBGPavim (interactive PHP debugging)
let g:dbgPavimPort = 9009

" Load WordPress tags for all php files
autocmd FileType php setlocal tags+=~/wp/core/tags

