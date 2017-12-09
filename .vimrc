" BASIC CONFIG
set nocompatible
set history=2000


" VUNDLE CONFIG
filetype off " to resolve runtimepath issue when loading vundle

" set runtime
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" have Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" PLUGINS

" ctrlp
Plugin 'ctrlpvim/ctrlp.vim'
" delimitMate
Plugin 'Raimondi/delimitMate'

call vundle#end()

filetype plugin indent on "reset after vundle has done its stuff 
syntax on

" AUTO COMMANDS
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber set ai sw=2 sts=2 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " javascript
  autocmd! FileType javascript set sw=2 sts=2 expandtab autoindent smartindent nocindent
augroup END


