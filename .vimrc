" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if has("autocmd")
  filetype plugin indent on

  " Jump to last known cursor position unless invalid
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif " has("autocmd")

" Use gvim's diff.exe if we're running on Windows (as detected by backslash in
" $VIM)
if strlen(matchstr($VIM, ".*\\"))
  set diffexpr=MyDiff()
  function MyDiff()
    let opt = ''
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let diffexe = $VIMRUNTIME . '\diff.exe'
    silent execute '!"' . diffexe . '" -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
  endfunction
endif

" Alt-Space is System menu
if has("gui")
  set guifont=Ubuntu\ Mono\ 12
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" Windows default path ".,c:\tmp,c:\temp" isn't present in Vista; use user's
" %TEMP%
if strlen($TEMP)
  set directory=.,$TEMP
end

set autoindent			" always set autoindenting on
set backspace=indent,eol,start	" allow backspace over autoindent, line breaks, start of insert
set guioptions-=m		" no GUI menu
set guioptions-=T		" no GUI toolbar
set hidden			" allow changed buffers to hide
set history=50			" keep 50 lines of command line history
set ignorecase			" ignore case for searches, etc.
set incsearch			" do incremental searching
set laststatus=2		" always show the status line
set listchars=eol:$,tab:>_,trail:_,extends:+	" Appearance when 'list' is set
set listchars+=precedes:<,extends:>	" Vertical scrolling indicators
set matchpairs+=<:>
set noequalalways		" do not equalize windows on split
set nomodeline			" Avoid modeline security issues
set ruler			" show the cursor position all the time
set shiftwidth=2		" indent 2 spaces
set showbreak=__		" delimit column 0 of wrapped lines
set showcmd			" display incomplete commands
set showmatch			" highlight matching (){}'
set smartindent
set smarttab
set spellfile=~/.vim-wordlist.single.add
set splitbelow			" when splitting, put window below current window
set tabstop=8			" tab stops at 8 spaces
set ttyfast			" smoother redraws, more bandwidth
set whichwrap=b,s,h,l,<,>,[,]	" <left>, <right> wrap in Normal and Insert
set wildmenu			" put tab completions in status bar
set winminheight=0		" split window minimum height

if has("spell")
  set spellfile=~/.vim-wordlist.single.add
endif

" Correct illegible text for my terminals' color schemes
highlight DiffAdd	ctermfg=black
highlight DiffChange	ctermfg=black
highlight DiffText	ctermfg=black
highlight Search	ctermfg=black

" filename, help flag, modified flag, read-only flag, right-align (%=)
" column, virtual column, percent
set statusline=%<%f\ %h%m%r%=%y\ %-12.(%l,%c%V%)\ %P

if exists("&breakindent")
  set breakindent
" set breakindentopt=shift:2
endif

set encoding=utf-8

" Disable ClearType for now - resizes are too slow
" " Enable ClearType on Windows
" if exists("&renderoptions")
"   set renderoptions=type:directx,gamma:1.25,contrast:.25,geom:1,renmode:4,taamode:1
" endif

" see https://sanctum.geek.nz/arabesque/gracefully-degrading-vimrc/
