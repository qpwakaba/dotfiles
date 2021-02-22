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
set formatoptions-=ro

"noremap ; :
"nnoremap q <NOP>
"nnoremap p ]p
"nnoremap <silent> p p`[=`]`]
"nnoremap <silent> P P`[=`]`]
inoremap <CR> <C-g>u<CR>
inoremap <C-j> <C-g>u<C-j>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-s> <C-x>
inoremap <C-c> <C-Esc>:call <SID>DeleteSpaceLine()<CR>

function s:DeleteSpaceLine()
  let l:current = getline('.')
  let l:indented = substitute(l:current, '^ *$', '', '')
  if (l:current != l:indented)
    call setline('.', l:indented)
  endif
endfunction

vnoremap <expr> p <SID>PasteWithoutYank()
function s:PasteWithoutYank()
  let l:info = getbufinfo(bufname())[0]
  if (l:info.lnum != l:info.linecount)
    return '"_xP'
  else
    return '"_xp'
  fi
endfunction


noremap <S-j> <C-d>
noremap <S-k> <C-u>
noremap <C-j> <C-f>
noremap <C-k> <C-b>
noremap <C-w><C-c> <Nop>
noremap <C-w>c <Nop>
noremap 0 ^
noremap ^ 0
noremap r<C-c> <Nop>
inoremap <Home> <C-o>^
if has('terminal')
  tnoremap <C-w>gt <C-w>:tabn<CR>
  tnoremap <C-w>gT <C-w>:tabN<CR>
endif
nnoremap <C-w>gt :tabn<CR>
nnoremap <C-w>gT :tabN<CR>
noremap <silent> <C-w><C-l> :redraw!<CR>
noremap <M-w> :w<CR>
noremap <Esc>w :w<CR>
inoremap <Nul> <C-n>
command -nargs=* W w <args>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

inoremap <expr> <BS> <SID>DeleteLeft(getcurpos())
inoremap <expr> <Delete> <SID>DeleteRight(getcurpos())

function s:DeleteLeft(curpos)
  let l:left = strpart(getline(a:curpos[1]), 0, a:curpos[2] - 1)
  if (l:left =~ "^  *$")
    if (a:curpos[1] > 1)
      let l:current_indent = strlen(l:left)
      let l:above_indent = strlen(matchstr(getline(a:curpos[1] - 1), '^ *'))
      if (l:current_indent > l:above_indent)
        return repeat("\<C-h>", l:current_indent - l:above_indent)
      endif
      return "\<C-w>"
    endif
  endif
  return "\<BS>"
endfunction

function s:DeleteRight(curpos)
  let l:right = strpart(getline(a:curpos[1]), a:curpos[2] - 1)
  if (l:right == '')
    let l:below_indent = strlen(matchstr(getline(a:curpos[1] + 1), '^ *'))
    return repeat("\<Delete>", 1 + l:below_indent)
  else
    return "\<Delete>"
  endif
endfunction

if (exists('$WSLENV'))
  set mouse+=a
  cnoremap <S-Insert> <C-r>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g'")<CR><BS>
  inoremap <S-Insert> <C-r>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g'")<CR><BS>
  tnoremap <S-Insert> <C-w>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g'")<CR><BS>
  vnoremap <silent> <C-Insert> :w !clip.exe<CR><CR>
endif

set noequalalways

set wildmenu
set wildmode=longest:full,full
set completeopt=menuone,longest
set noinfercase
set wildignorecase
set fileignorecase
set showcmd

set hidden
set rulerformat=%-20(%k\ [%l/%L],%c\ \ %{&fileencoding}%)

hi VertSplit cterm=none ctermbg=none ctermfg=lightblue
hi Search term=reverse ctermfg=black ctermbg=11
hi StatusLine ctermbg=darkgreen ctermfg=16 cterm=none
hi StatusLineTerm ctermbg=darkgreen ctermfg=16
hi StatusLineNC ctermfg=7 ctermfg=white cterm=inverse
hi StatusLineTermNC ctermbg=7 ctermfg=black
hi TabLine cterm=none ctermbg=black ctermfg=gray
hi TabLineSel cterm=none ctermbg=4 ctermfg=white
hi TabLineFill cterm=none ctermbg=black ctermfg=white
hi MatchParen term=NONE ctermfg=red ctermbg=NONE
set showtabline=1
set laststatus=2

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

" Vimでファイルを開き直してもUndoができるように正しく設定する https://qiita.com/tamanobi/items/8f013cce36881af8cee3
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif


" Hack #84: バッファの表示設定を保存する https://vim-jp.org/vim-users-jp/2009/10/08/Hack-84.html
" Save fold settings.
autocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
autocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
" Don't save options.
set viewoptions-=options

