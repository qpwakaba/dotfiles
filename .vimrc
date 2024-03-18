let mapleader = "\<Space>"

" おすすめプラグイン 〜 Vimはいいぞ！ゴリラと学ぶVim講座(7) https://knowledge.sakura.ad.jp/23248/
" dein.vim の導入
" dein.vim settings {{{
" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:lazy = s:rc_dir . '/dein-lazy.toml'

  " read toml and cache
  if filereadable(s:toml)
    call dein#load_toml(s:toml, {'lazy': 0})
  endif
  if filereadable(s:lazy)
    call dein#load_toml(s:lazy, {'lazy': 1})
  endif

  " local settings
  let s:rc_dir = expand('~/.local/vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:lazy = s:rc_dir . '/dein-lazy.toml'

  " read toml and cache
  if filereadable(s:toml)
    call dein#load_toml(s:toml, {'lazy': 0})
  endif
  if filereadable(s:lazy)
    call dein#load_toml(s:lazy, {'lazy': 1})
  endif

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}

" vimrc
syntax on
filetype indent plugin on
set background=dark
set hlsearch
set backspace=indent,eol,start
nnoremap <Esc><Esc> :nohlsearch<CR>

if version > 704
  set belloff=all
else
  set vb t_vb=
endif

set updatetime=500
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
set incsearch
set formatoptions-=ro

set foldlevel=999999
autocmd InsertLeave,WinEnter * setlocal foldmethod=syntax
autocmd InsertEnter,WinLeave * setlocal foldmethod=manual

" Cursor in terminal
" https://vim.fandom.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 2 solid block
" 3 -> blinking underscore
" 4 solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

if &term =~ '^xterm'
  " normal mode
  let &t_EI .= "\<Esc>[0 q"
  " insert mode
  let &t_SI .= "\<Esc>[5 q"
endif

inoremap <Plug>(qpwakaba_push_history) <C-g>u
inoremap <Plug>(qpwakaba_noremap_CR) <CR>
let g:qpwakaba_vimrc = expand("<SID>")
augroup qpwakaba_keymap
  autocmd!
  autocmd BufEnter * call s:qpwakaba_keymap()
  function s:qpwakaba_keymap()
    if exists('b:qpwakaba_keymap')
      return
    endif
    let b:qpwakaba_keymap = 1
    call s:qpwakaba_keymap_CR()
    call s:qpwakaba_keymap_BS_del()
  endfunction
  function s:qpwakaba_keymap_CR()
    inoremap <Plug>(qpwakaba_keymap_orig_CR) <CR>
    if !empty(maparg('<CR>', 'i', 0))
      let s:orig_CR = maparg('<CR>', 'i', 0, 1)
      imap <buffer> <CR> <Plug>(qpwakaba_push_history)<Plug>(qpwakaba_keymap_orig_CR)
      let s:plug_CR = maparg('<Plug>(qpwakaba_keymap_orig_CR)', 'i', 0, 1)
      let s:orig_CR['lhs'] = s:plug_CR['lhs']
      let s:orig_CR['lhsraw'] = s:plug_CR['lhsraw']
      if has_key(s:orig_CR, 'lhsrawalt')
        call remove(s:orig_CR, 'lhsrawalt')
      endif
      call mapset('i', 0, s:orig_CR)
    else
      imap <buffer> <CR> <Plug>(qpwakaba_push_history)<Plug>(qpwakaba_keymap_orig_CR)
    endif
  endfunction

  function s:qpwakaba_keymap_BS_del()
    inoremap <Plug>(qpwakaba_keymap_orig_BS) <BS>
    if !empty(maparg('<BS>', 'i', 0))
      let s:orig_BS = maparg('<BS>', 'i', 0, 1)
      imap <buffer> <silent> <expr> <BS> <SID>DeleteLeft(getcurpos())
      let s:plug_BS = maparg('<Plug>(qpwakaba_keymap_orig_BS)', 'i', 0, 1)
      let s:orig_BS['lhs'] = s:plug_BS['lhs']
      let s:orig_BS['lhsraw'] = s:plug_BS['lhsraw']
      if has_key(s:orig_BS, 'lhsrawalt')
        call remove(s:orig_BS, 'lhsrawalt')
      endif
      call mapset('i', 0, s:orig_BS)
    else
      imap <buffer> <silent> <expr> <BS> <SID>DeleteLeft(getcurpos())
    endif

    inoremap <Plug>(qpwakaba_keymap_orig_Dl) <Delete>
    if !empty(maparg('<Delete>', 'i', 0))
      let s:orig_Dl = maparg('<Delete>', 'i', 0, 1)
      imap <buffer> <silent> <expr> <Delete> <SID>DeleteRight(getcurpos())
      let s:plug_Dl = maparg('<Plug>(qpwakaba_keymap_orig_Dl)', 'i', 0, 1)
      let s:orig_Dl['lhs'] = s:plug_Dl['lhs']
      let s:orig_Dl['lhsraw'] = s:plug_Dl['lhsraw']
      if has_key(s:orig_Dl, 'lhsrawalt')
        call remove(s:orig_Dl, 'lhsrawalt')
      endif
      call mapset('i', 0, s:orig_Dl)
    else
      imap <buffer> <silent> <expr> <Delete> <SID>DeleteRight(getcurpos())
    endif
  endfunction

  function s:DeleteLeft(curpos)
    let l:left = strpart(getline(a:curpos[1]), 0, a:curpos[2] - 1)
    if (l:left =~ "^  *$")
      if (a:curpos[1] > 1)
        return "\<C-w>"
      endif
    endif
    return "\<Plug>(qpwakaba_keymap_orig_BS)"
  endfunction

  function s:DeleteLeftOld(curpos)
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
    return "\<Plug>(qpwakaba_keymap_orig_BS)"
  endfunction

  function s:DeleteRight(curpos)
    let l:right = strpart(getline(a:curpos[1]), a:curpos[2] - 1)
    if (l:right == '')
      let l:below_indent = strlen(matchstr(getline(a:curpos[1] + 1), '^ *'))
      return repeat("\<Delete>", 1 + l:below_indent)
    endif
    return "\<Plug>(qpwakaba_keymap_orig_Dl)"
  endfunction

augroup END

inoremap <C-j> <C-g>u<C-j>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-s> <C-x>
inoremap <C-c> <C-Esc><Cmd>call <SID>DeleteSpaceLine()<CR>

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


nnoremap <C-s> <Cmd>w<CR>
noremap <S-j> <C-d>
noremap <S-k> <C-u>
"noremap <C-j> <C-f>
"noremap <C-k> <C-b>
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
"noremap <Esc>w :w<CR>
command -nargs=* W w <args>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
inoremap <C-a> <Home>
inoremap <C-e> <End>
nnoremap <Space><Space> <Cmd>let &cursorline = 1 - &cursorline<CR>



if (exists('$WSLENV'))
  set mouse+=a
  cnoremap <S-Insert> <C-r>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g' \| head -c -1")<CR>
  inoremap <S-Insert> <C-o>:set paste<CR><C-r>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g' \| head -c -1")<CR><C-o>:set nopaste<CR>
  tnoremap <S-Insert> <C-w>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g' \| head -c -1")<CR>
  tnoremap <S-Insert> <C-w>=system("powershell.exe -c Get-Clipboard \| sed 's/\r//g' \| head -c -1")<CR>
  vnoremap <silent> <C-Insert> :'<,'>w !sed -e '1s/^\xEF\xBB\xBF//' \| clip.exe<CR><CR>
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
hi SpellBad ctermfg=darkred cterm=underline
hi Pmenu ctermbg=22 ctermfg=white
set showtabline=1
set laststatus=2

" 行末スペースハイライト
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

noremap <expr> <Down> popup_findinfo() != 0 ? "\<Down>" : "gj"
noremap <expr> <Up>   popup_findinfo() != 0 ? "\<Up>"   : "gk"
inoremap <silent> <expr> <Down> popup_findinfo() != 0 ? "\<Down>" : "\<C-o>gj"
inoremap <silent> <expr> <Up>   popup_findinfo() != 0 ? "\<Up>"   : "\<C-o>gk"

set helplang=ja

if !empty(globpath(&rtp, 'autoload/lsp.vim'))
  nnoremap <C-k><C-d> <Cmd>LspDocumentFormat<CR>
  nnoremap <C-k><C-f> <Cmd>LspDocumentRangeFormat<CR>
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <F12> <plug>(lsp-definition)
  endfunction
  augroup lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled
\   call s:on_lsp_buffer_enabled()
  augroup END
endif

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

if filereadable(expand($HOME.'/.local/vimrc'))
  source $HOME/.local/vimrc
endif

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

hi link ALEError Error
hi link ALEWarning Todo
hi XmlTag ctermfg=153
hi link XmlTagName XmlTag

" ref: https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
