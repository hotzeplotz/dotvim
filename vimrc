" my vimrc - initially populated with a few lines from my historic vimrc and a
" lot of cool stuff from scribu's dotvim archive
"
"" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Load Pathogen
"source ~/.vim/bundle/pathogen/autoload/pathogen.vim
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"source ~/.vim/gnupgmini

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



" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile

  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END
