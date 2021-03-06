" BASIC CONFIG {{{

set nocompatible
set history=2000
set showcmd
set noswapfile
set nohlsearch
set wrap
set tw=0 wm=0
set expandtab
set lbr
set backspace=indent,eol,start
set hidden
set nowrap

" }}}

" GITCOMMIT {{{

" wrapping for commit messages
autocmd Filetype gitcommit setlocal textwidth=72

" }}}

" VUNDLE CONFIG {{{

filetype off " to resolve runtimepath issue when loading vundle

" set runtime
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" have Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" PLUGINS

Plugin 'junegunn/fzf' 
Plugin 'junegunn/fzf.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-endwise'
Plugin 'jpalardy/vim-slime'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'AndrewRadev/switch.vim'
Plugin 'tpope/vim-ragtag'
Plugin 'junegunn/rainbow_parentheses.vim'
Plugin 'Chiel92/vim-autoformat'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'fatih/vim-go'
Plugin 'mechatroner/rainbow_csv'

call vundle#end()

filetype plugin indent on "reset after vundle has done its stuff 
syntax on

" }}}

" AUTO COMMANDS {{{

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
  autocmd FileType ruby,haml,eruby,yaml,html,sass,scss,cucumber set ai sw=2 sts=2 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " javascript
  autocmd! FileType javascript set sw=2 sts=2 expandtab autoindent smartindent nocindent

  " go
  autocmd FileType go set sw=4 sts=4 ts=4 noexpandtab

augroup END


" }}}

" KEYBINDINGS {{{

" remap writing to file to F2
noremap  <f2> :w<return>
inoremap <f2> <c-o>:w<return>

" F5 to bring up buffer list, hit buffer id no to select it
noremap <F5> :Buffers<CR>

" F12 to fix up syntax highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" }}}

" PLUGIN CONFIG {{{

" FZF.VIM

" Set vim to use fzf when installed via git
set rtp+=~\.fzf

" map ctrl+p to fzf in vim
nmap <c-p> :Files<CR>

" SLIME
" set slime to use tmux session 
let g:slime_target = "tmux"

" run vim with split tmux window + REPL
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}

" EMMET.VIM
" only use emmet with certain files
" use tab to for expanding abbreviations (but not lose it for indenting)
imap <expr> <leader><tab> emmet#expandAbbrIntelligent("\<tab>")

" RAINBOW_PARENTHESES.VIM
" automatically use the plugin when working with lisp files
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" NERDTREE
" set ctrl+b to open tree 
map <C-b> :NERDTreeToggle<CR>

" }}}
