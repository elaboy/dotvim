" Insert-mode completion. No plugins: this is keyword + syntax + tags completion.
"   Ctrl-N / Ctrl-P   words from open buffers and tags (the everyday one)
"   Ctrl-X Ctrl-O     omni-complete: language-aware where Vim ships support
"   Ctrl-X Ctrl-]     names from the tags file
"   Ctrl-X Ctrl-F     file paths

" Where Ctrl-N looks: this buffer, other windows, other open and closed
" buffers, then tags.
set complete=.,w,b,u,t
set completeopt=menuone,longest
if has('patch-7.4.775')
  set completeopt+=noselect     " don't insert the first match until you pick it
endif
if has('patch-7.4.314')
  set shortmess+=c              " no 'match 1 of 5' messages
endif
set infercase                   " completing 'foo' from 'FooBar' keeps your case
set pumheight=15                " at most 15 items in the menu

" Omni-complete fallback: languages without a stock omnifunc (C#, PowerShell,
" Bash, Dockerfile...) complete their keywords from the syntax file.
" Runs after the ftplugins, so stock omnifuncs (Python, JS/TS, SQL...) win.
augroup dotvim_omnifunc
  autocmd!
  autocmd FileType * if exists('+omnifunc') && &omnifunc ==# ''
        \ | setlocal omnifunc=syntaxcomplete#Complete | endif
augroup END
