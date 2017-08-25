set nocompatible                    " full vim
syntax enable                       " enable syntax highlighting
set encoding=utf8                   " utf8 default encoding

" load pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

noremap , \
let mapleader = ","

set scrolloff=3                     " show 3 lines of context around the cursor
set autoread                        " set to auto read when a file is changed from the outside
set mouse=a                         " allow for full mouse support
set autowrite
set showcmd                         " show typed commands

set wildmenu                        " turn on WiLd menu
set wildmode=list:longest,list:full " activate TAB auto-completion for file paths
set wildignore+=*.o,.git,.svn,node_modules

set ruler                           " always show current position
set backspace=indent,eol,start      " set backspace config, backspace as normal
set nomodeline                      " security

set hlsearch                        " highlight search things
set incsearch                       " go to search results as typing
set smartcase                       " but case-sensitive if expression contains a capital letter.
set ignorecase                      " ignore case when searching
set gdefault                        " assume global when searching or substituting
set magic                           " set magic on, for regular expressions
set showmatch                       " show matching brackets when text indicator is over them

set lazyredraw                      " don't redraw screen during macros, faster
set ttyfast                         " improves redrawing for newer computers
set fileformats=unix,mac,dos

set nobackup                        " prevent backups of files, since using vcs
set nowritebackup
set noswapfile

set shiftwidth=2                    " set tab width
set softtabstop=2
set tabstop=2

set smarttab
set expandtab                       " use spaces, not tabs
set autoindent                      " set automatic code indentation
set hidden                          " allow background buffers w/out writing

set nowrap                          " don't wrap lines

set list                            " show hidden characters
set listchars=tab:\ \ ,trail:·      " show · for trailing space, \ \ for trailing tab
set spelllang=en,es                 " set spell check language
set noeb vb t_vb=                   " disable audio and visual bells

set t_Co=256                        " use 256 colors
set background=dark
colorscheme ir_black                " terminal theme
if has("gui_running")
  au GUIEnter * set vb t_vb=       " disable visual bell in gui
  set guioptions-=T                " remove gui toolbar
  set guioptions-=m                " remove gui menubar
  set linespace=2                  " space between lines
  set columns=160 lines=35         " window size
  set cursorline                  " highlight current line
  set colorcolumn=115              " show a right margin column

  set guioptions+=LlRrb            " crazy hack to get gvim to remove all scrollbars
  set guioptions-=LlRrb

  set guifont=Ubuntu\ Mono\ 12    " gui font
  set background=dark
  colorscheme jellybeans          " gui theme
endif

" FOLDING
set foldenable                   " enable folding
set foldmethod=indent            " most files are evenly indented
set foldlevel=99

" ADDITIONAL KEY MAPPINGS

" fast saving
nmap <leader>w :up<cr>

" fast escaping
imap jj <ESC>

" prevent accidental striking of F1 key
map <F1> <ESC>
imap <F1> <ESC>

" clear highlight
nnoremap <leader><space> :noh<cr>

" map Y to match C and D behavior
nnoremap Y y$

" yank entire file (global yank)
nmap gy ggVGy

" ignore lines when going up or down
nnoremap j gj
nnoremap k gk

" auto complete {} indent and position the cursor in the middle line
inoremap {<CR>  {<CR>}<Esc>O
inoremap (<CR>  (<CR>)<Esc>O
inoremap [<CR>  [<CR>]<Esc>O

" fast window switching
map <leader>, <C-W>w

" cycle between buffers
map <leader>. :b#<cr>

" change directory to current buffer
map <leader>cd :cd %:p:h<cr>

" open file explorer
map <leader>n :NERDTreeToggle<cr>

" swap implementations of ` and ' jump to prefer row and column jumping
nnoremap ' `
nnoremap ` '

" indent visual selected code without unselecting and going back to normal mode
vmap > >gv
vmap < <gv

" pull word under cursor into lhs of a substitute (for quick search and replace)
nmap <leader>r :%s#\<<C-r>=expand("<cword>")<CR>\>#

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//e<cr>:let @/=''<CR>

" insert path of current file into a command
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" fast editing of the .vimrc
nmap <silent> <leader>ev :e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>

" allow saving when you forgot sudo
cmap w!! w !sudo tee % >/dev/null

" turn on spell checking
map <leader>spl :setlocal spell!<cr>

" spell checking shortcuts
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"" ADDITIONAL AUTOCOMMANDS

" saving when focus lost (after tabbing away or switching buffers)
au FocusLost,BufLeave,WinLeave,TabLeave * silent! up

" open in last edit place
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
au QuickFixCmdPost *grep* cwindow

"" ABBREVIATIONS
" source $HOME/.vim/autocorrect.vim

"" PLUGIN SETTINGS

let g:netrw_liststyle=3  " use tree style for netrw

" Unimpaired
" bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Command-T
let g:CommandTMaxHeight=20
let g:CommandTCancelMap=['<ESC>','<C-c>']

" Ack
set grepprg=ack
nnoremap <leader>a :Ack<space>
let g:ackhighlight=1
let g:ackprg="ack-grep -H --type-set html=.ejs --type-set jade=.jade --type set less=.less --type-set stylus=.styl --type-set coffee=.coffee --nocolor --nogroup --column --ignore-dir=node_modules -G '^((?!min\.).)*$'"

" CoffeeScript
map <leader>cc :CoffeeCompile<cr>
map <silent> <leader>cm :CoffeeMake<cr> <cr>

"" LANGUAGE SPECIFIC

" Python
au FileType python set noexpandtab

" JavaScript
au BufRead,BufNewFile *.json set ft=javascript


" Swap Lines
" http://stackoverflow.com/questions/741814/move-entire-line-up-and-down-in-vim
function! s:swap_lines(n1, n2)
  let line1 = getline(a:n1)
  let line2 = getline(a:n2)
  call setline(a:n1, line2)
  call setline(a:n2, line1)
endfunction

function! s:swap_up()
  let n = line('.')
  if n == 1
    return
  endif

  call s:swap_lines(n, n - 1)
  exec n - 1
endfunction

function! s:swap_down()
  let n = line('.')
  if n == line('$')
    return
  endif

  call s:swap_lines(n, n + 1)
  exec n +1
endfunction

noremap <silent> <c-j> :call <SID>swap_up()<CR>
noremap <silent> <c-k> :call <SID>swap_down()<CR>

" Auto remove trailing whitespaces on buffer
autocmd BufWritePre * :%s/\s\+$//e

" Xclip to copy between vim and clipboard
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    vmap <leader>c y:call system("pbcopy", getreg("\""))<CR>:call system("pbcopy", getreg("\""))<CR>
    nmap <leader>v :call setreg("\"",system("pbpaste"))<CR>p
  else
    vmap <leader>c y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
    nmap <leader>v :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
  endif
endif

" Syntastic

" https://github.com/vim-syntastic/syntastic/issues/1640
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"set statusline+=%F
set laststatus=2 " always hide the last status

" https://github.com/pugjs/pug-lint
let g:syntastic_pug_checkers = ['pug_lint']

let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" https://github.com/mantoni/eslint_d.js
let g:syntastic_javascript_eslint_exec = 'eslint_d'

" https://github.com/sindresorhus/vim-xo
" `npm install -g xo`
" (note this can be overridden e.g. with 'eslint' per project in vimlocal)
let g:syntastic_javascript_checkers = ['xo']

let syntastic_mode_map = { 'passive_filetypes': ['html'] }

" remove hit-enter
:silent !ls

" flow type checking
let g:flow#enable = 0

" thx to @dsibiski
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Die arrow keys!
"nnoremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

" Highlight the 80th column
" http://stackoverflow.com/a/3787678
:highlight ColorColumn ctermbg=lightgrey guibg=lightgrey
:set colorcolumn=80

" Force detection of markdown with .md files so it doens't do Modula-2
" https://github.com/tpope/vim-markdown
" http://stackoverflow.com/a/11995366
" md extension for markdown
au BufNewFile,BufRead *.md set ft=markdown

" Toggle live markdown preview with `gm`
nmap gm :LivedownToggle<CR>
" use port 8337 instead of 1337 since tunnelblick uses that port
let g:livedown_port = 8337

" Allow JSX in any .js file
" https://github.com/mxw/vim-jsx
let g:jsx_ext_required = 0

" vim-prettier
" https://github.com/prettier/vim-prettier
"let g:prettier#autoformat = 0

" max line lengh that prettier will wrap on
let g:prettier#config#print_width = 80

" number of spaces per indentation level
let g:prettier#config#tab_width = 2

" use tabs over spaces
let g:prettier#config#use_tabs = 'false'

" print semicolons
let g:prettier#config#semi = 'true'

" single quotes over double quotes
let g:prettier#config#single_quote = 'true'

" print spaces between brackets
let g:prettier#config#bracket_spacing = 'false'

" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line = 'true'

" none|es5|all
let g:prettier#config#trailing_comma = 'none'

autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql Prettier

" vim-autoformatter
" https://github.com/Chiel92/vim-autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
au BufWrite * :Autoformat

" Load local project directory settings
silent! so .vimlocal

" disable unsafe commands in project specific vimrc files
" https://andrew.stwrt.ca/posts/project-specific-vimrc/
set secure
