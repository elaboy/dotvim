" dotvim — a portable, zero-plugin Vim setup.
" Your ~/.vimrc (or ~/_vimrc on native Windows) only contains:
"     source /path/to/dotvim/vimrc
" Everything here uses features that ship with Vim itself.

set nocompatible
set encoding=utf-8
scriptencoding utf-8

" Vim skips its own defaults.vim once you have a vimrc. Load it anyway: it turns
" on syntax, filetype plugins, incsearch, wildmenu and 'jump back to the last
" cursor position when reopening a file'. (Missing on Vim < 8.0; that's fine.)
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

" Where this repo lives, so the rest of the config can find its files.
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 'runtimepath' is the list of folders Vim searches for ftplugin/, compiler/...
"   repo first    -> our compiler/ files are found
"   repo/after    -> our after/ftplugin/ runs after Vim's own ftplugins
"   repo/fallback -> copies of newer stock files, used only on old Vims
execute 'set runtimepath^=' . fnameescape(s:root)
execute 'set runtimepath+=' . fnameescape(s:root . '/after')
execute 'set runtimepath+=' . fnameescape(s:root . '/fallback')

filetype plugin indent on
syntax enable

for s:part in ['options', 'search', 'completion', 'mappings']
  execute 'source' fnameescape(s:root . '/config/' . s:part . '.vim')
endfor
