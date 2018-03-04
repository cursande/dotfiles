" BASIC CONFIG
set nocompatible
set history=2000
set showcmd

" VUNDLE CONFIG
filetype off " to resolve runtimepath issue when loading vundle

" set runtime
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" have Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" PLUGINS

" fzf
Plugin 'junegunn/fzf' 
" fzf.vim
Plugin 'junegunn/fzf.vim'
" ack.vim
Plugin 'mileszs/ack.vim'
" delimitMate
Plugin 'Raimondi/delimitMate'
" vim-ruby
Plugin 'vim-ruby/vim-ruby'
" vim-endwise
Plugin 'tpope/vim-endwise'
" vim-slime
Plugin 'jpalardy/vim-slime'
" goyo
Plugin 'junegunn/goyo.vim'
" vim-rspec
Plugin 'thoughtbot/vim-rspec'
" vim-commentary
Plugin 'tpope/vim-commentary'
" vim-fugitive
Plugin 'tpope/vim-fugitive'
" switch.vim
Plugin 'AndrewRadev/switch.vim'

call vundle#end()

filetype plugin indent on "reset after vundle has done its stuff 
syntax on
let g:ruby_path = system('echo $HOME/.rbenv/shims') "Help speed things up when working with ruby files

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

" KEYBINDINGS
" set no highlight to leader + c
map <Leader>c :noh

" remap writing to file to F2
noremap  <f2> :w<return>
inoremap <f2> <c-o>:w<return>

" FZF.VIM
" map ctrl+p to fzf in vim
nmap <c-p> :Files<CR>

" ACK.VIM

" If I'm using my config on a system where I don't have ag...
if executable('ag')
  let g:ackprg = 'ag --vimgrep --nogroup --nocolor --column'
endif

" SLIME
" set slime to use tmux session 
let g:slime_target = "tmux"

" run vim with split tmux window + REPL
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}

" VIM-RSPEC
" key mapping
" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

