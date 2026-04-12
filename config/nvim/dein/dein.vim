let s:plugins = stdpath('config') . '/dein/plugins.toml'
let s:plugins_lazy = stdpath('config') . '/dein/lazy-plugins.toml'
let s:plugins_local = expand("$HOME/.local/config/nvim/dein/plugins.toml")
let s:plugins_local_lazy = expand("$HOME/.local/config/nvim/dein/lazy-plugins.toml")

let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

" Ward off unexpected things that your distro might have made, as
" well as sanely reset options when re-sourcing .vimrc

" Set dein base path (required)
let s:dein_base = '~/.cache/dein-nvim/'

" Set dein source path (required)
let s:dein_src = '~/.cache/dein-nvim/repos/github.com/Shougo/dein.vim'

" Set dein runtime path (required)
execute 'set runtimepath+=' .. s:dein_src

" Call dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" .toml file
let s:rc_dir = expand('~/.vim')
if !isdirectory(s:rc_dir)
  call mkdir(s:rc_dir, 'p')
endif

" read toml and cache
if filereadable(s:plugins)
  call dein#load_toml(s:plugins, {'lazy': 0})
endif
if filereadable(s:plugins_lazy)
  call dein#load_toml(s:plugins_lazy, {'lazy': 1})
endif

" local settings
if filereadable(s:plugins_local)
  call dein#load_toml(s:plugins_local, {'lazy': 0})
endif
if filereadable(s:plugins_local_lazy)
  call dein#load_toml(s:plugins_local_lazy, {'lazy': 1})
endif

" Finish dein initialization (required)
call dein#end()

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Uncomment if you want to install not-installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
