" Editor behaviour. Every line is a stock Vim option; :help 'name' explains it.

" ---- What you see -----------------------------------------------------------
set number                  " line numbers in the left gutter
set laststatus=2            " always show the status line (file name, position)
set ruler                   " line,column in the bottom-right corner
set showcmd                 " show half-typed commands, e.g. the 'd' of 'dw'
set scrolloff=5             " keep 5 lines visible above/below the cursor
set display=lastline        " show as much of a long last line as fits
set splitbelow splitright   " new splits open below / to the right
set list                    " make tabs and trailing spaces visible...
set listchars=tab:>\ ,trail:-,nbsp:+
if exists('+belloff')
  set belloff=all           " no beeping
endif
if has('gui_running') && has('win32')
  set guifont=Consolas:h11
endif

" ---- Editing ----------------------------------------------------------------
set hidden                  " switch buffers without saving first
set backspace=indent,eol,start
set mouse=a                 " click to move, drag to select, wheel to scroll
set autoread                " reload files changed outside Vim (e.g. git pull)
set fileformats=unix,dos    " keep CRLF files CRLF, LF files LF
set ttimeout ttimeoutlen=50 " Esc leaves insert mode without a delay

" Git Bash's Vim doesn't recognise /bin/bash.exe as bash, so :make would only
" capture stdout and miss every error a tool prints to stderr.
if &shellpipe ==# '| tee' && &shell =~? 'sh\(\.exe\)\=$'
  set shellpipe=2>&1\|\ tee
endif

" Default indent: 4 spaces. after/ftplugin/ changes it per language, and a
" project's .editorconfig wins over both.
set expandtab tabstop=4 shiftwidth=4 softtabstop=4 autoindent

" ---- Search -----------------------------------------------------------------
set incsearch hlsearch      " highlight matches while typing and afterwards
set ignorecase smartcase    " case-insensitive unless you type a capital

" ---- Clipboard: y and p use the system clipboard ----------------------------
if has('unnamedplus')
  set clipboard^=unnamed,unnamedplus
elseif has('clipboard')
  set clipboard^=unnamed
elseif has('unix') && executable('clip.exe') && exists('##TextYankPost')
  " WSL: Vim usually has no clipboard support, so copy yanks to Windows.
  augroup dotvim_wsl_clipboard
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y'
          \ | call system('clip.exe', getreg(v:event.regname)) | endif
  augroup END
endif

" ---- Swap, backup and undo files live in ~/.vim-data, not next to your code -
let s:data = expand('~/.vim-data')
for s:dir in ['swap', 'backup', 'undo']
  if !isdirectory(s:data . '/' . s:dir)
    call mkdir(s:data . '/' . s:dir, 'p')
  endif
endfor
" A trailing // makes file names unique by encoding the full path. That name
" can pass the 260-character limit of native Windows Vim for deeply nested
" files, so each option also lists the plain folder as a second choice.
let &directory = s:data . '/swap//,' . s:data . '/swap'
let &backupdir = s:data . '/backup//,' . s:data . '/backup'
if has('persistent_undo')
  let &undodir = s:data . '/undo//,' . s:data . '/undo'
  set undofile              " undo history survives closing the file
endif

" ---- Packages that ship with Vim (not third-party; silently skipped if old) --
silent! packadd! editorconfig  " obey a project's .editorconfig (Vim 9.0.1799+)
silent! packadd! comment       " gcc / gc{motion} toggle comments (Vim 9.1+)
silent! packadd! matchit       " % jumps between if/else, #region/#endregion...

" ---- Language switches read by Vim's own syntax/ftplugin files --------------
let g:is_bash = 1                       " .sh files are bash, not POSIX sh
let g:ftplugin_sql_omni_key = '<C-j>'   " stock SQL plugin steals Ctrl-C otherwise
