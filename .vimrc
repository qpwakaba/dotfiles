" vimrc
syntax on
set background=dark
set hlsearch
set backspace=indent,eol,start
nnoremap <Esc><Esc> :nohlsearch<CR>

if version > 704
  set belloff=all
else
  set vb t_vb=
endif

set number
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set cindent
set fileencodings=utf-8,cp932,euc-jp
set scrolloff=8
set noshowcmd
set ignorecase
set smartcase
set foldlevel=999999
set incsearch

"noremap ; :
nnoremap q <NOP>
"vnoremap p "_dP
"nnoremap p ]p
"nnoremap <silent> p p`[=`]`]
"nnoremap <silent> P P`[=`]`]
inoremap <CR> <C-g>u<CR>
inoremap <C-j> <C-g>u<C-j>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-s> <C-x>
imap <C-c> <C-Esc>
noremap <S-j> <C-d>
noremap <S-k> <C-u>
noremap <C-j> <C-f>
noremap <C-k> <C-b>
noremap <C-w><C-c> <Nop>
noremap <C-w>c <Nop>
noremap 0 ^
noremap ^ 0
if has('terminal')
  tnoremap <C-w>gt <C-w>:tabn<CR>
  tnoremap <C-w>gT <C-w>:tabN<CR>
endif
nnoremap <C-w>gt :tabn<CR>
nnoremap <C-w>gT :tabN<CR>
noremap <silent> <C-w><C-l> :redraw!<CR>
noremap <M-w> :w<CR>
noremap <Esc>w :w<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"augroup mlclose
"  autocmd!
"  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
"  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
"augroup END

set noequalalways

set wildmenu
set completeopt=menuone,longest
set infercase
set showcmd

set hidden
set rulerformat=%-20(%k\ [%l/%L],%c\ \ %{&fileencoding}%)

" 行末スペースハイライト
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

noremap <Down> gj
noremap <Up>   gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up>   <C-o>gk


if exists('##TerminalOpen')
  augroup terminal
    au TerminalOpen * if &buftype == 'terminal' | setlocal nonumber | endif
  augroup END
endif

source $VIMRUNTIME/macros/matchit.vim

" Vimでプロジェクト固有の設定を適用する https://qiita.com/unosk/items/43989b61eff48e0665f3
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction


if filereadable(expand($HOME.'/.local/vimrc'))
  source $HOME/.local/vimrc
endif

