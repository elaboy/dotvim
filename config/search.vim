" Finding files, text and definitions.

" ---- :find — fuzzy-ish file search ------------------------------------------
" :find Foo<Tab> searches every folder under the current directory.
" Use * as a wildcard: :find *Service<Tab>
set path=.,**
set wildmenu                          " completion menu on the command line
set wildmode=longest:full,full
if exists('+wildignorecase')
  set wildignorecase
endif
set wildignore+=*/.git/*,*/bin/*,*/obj/*,*/node_modules/*,*/dist/*
set wildignore+=*/__pycache__/*,*/.venv/*,*/venv/*,*/.vs/*
set wildignore+=*.dll,*.exe,*.pdb,*.nupkg,*.pyc,*.min.js,tags

" ---- Live, fuzzy command line (Vim 9.1.1576+; older Vims keep Tab above) ----
" Suggestions pop up as you type any : command. For :find they are fuzzy file
" matches ('crshlg' finds CrashLog.cs), and Enter opens the top one unless you
" picked another with Tab or the arrow keys. Recipe from :help fuzzy-file-picker.
if exists('*wildtrigger') && exists('+findfunc') && exists('*cmdcomplete_info')
      \ && exists('##CmdlineLeavePre')
  set wildmode=noselect:lastused,full
  set wildoptions=pum
  set findfunc=DotvimFind

  " Up/Down still walk command history while the popup is open.
  cnoremap <expr> <Up>   wildmenumode() ? "\<C-E>\<Up>"   : "\<Up>"
  cnoremap <expr> <Down> wildmenumode() ? "\<C-E>\<Down>" : "\<Down>"

  augroup dotvim_live_cmdline
    autocmd!
    autocmd CmdlineChanged  : call wildtrigger()
    autocmd CmdlineEnter    : let s:files = []
    autocmd CmdlineLeavePre : call s:FindTopMatch()
  augroup END
endif

let s:files = []
" The file list is read once per : command line. In a git repo it comes from
" git (fast, and skips whatever .gitignore skips); elsewhere from a folder
" walk that skips 'wildignore'.
function! DotvimFind(arg, cmdcomplete) abort
  if empty(s:files)
    if executable('git') && (!empty(finddir('.git', '.;')) || !empty(findfile('.git', '.;')))
      let s:files = systemlist('git ls-files --cached --others --exclude-standard')
      if v:shell_error
        let s:files = []
      endif
    endif
    if empty(s:files)
      let s:files = filter(globpath('.', '**', 0, 1), '!isdirectory(v:val)')
      call map(s:files, "fnamemodify(v:val, ':.')")
    endif
  endif
  return a:arg ==# '' ? s:files : matchfuzzy(s:files, a:arg)
endfunction

function! s:FindTopMatch() abort
  let l:info = cmdcomplete_info()
  if getcmdline() =~# '^\s*fin\%[d]\s' && get(l:info, 'matches', []) != []
        \ && l:info.selected == -1
    call setcmdline('find ' . fnameescape(l:info.matches[0]))
  endif
endfunction

" ---- :grep — search text across the project ---------------------------------
" Fastest available tool wins: ripgrep, then git grep, then Vim's own vimgrep.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case grepformat=%f:%l:%c:%m
elseif executable('git')
  set grepprg=git\ grep\ -n\ --column\ -I grepformat=%f:%l:%c:%m
else
  set grepprg=internal
endif

" Open the quickfix window after :make / :grep / :vimgrep when there are results
" (and close it when there are none).
augroup dotvim_quickfix
  autocmd!
  autocmd QuickFixCmdPost make  call s:DedupeQuickfix()
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l*    lwindow
augroup END

" dotnet build prints every error twice (once while building, once in its
" summary), so drop repeated entries after :make.
function! s:DedupeQuickfix() abort
  let l:seen = {}
  let l:items = []
  for l:item in getqflist()
    let l:key = join([l:item.bufnr, l:item.lnum, l:item.col, l:item.type, l:item.text], "\t")
    if !has_key(l:seen, l:key)
      let l:seen[l:key] = 1
      call add(l:items, l:item)
    endif
  endfor
  call setqflist(l:items, 'r')
endfunction

" :GrepWord — search the project for the word under the cursor (<Space>g).
command! GrepWord call s:GrepWord(expand('<cword>'))
function! s:GrepWord(word) abort
  if a:word !~# '\k'
    echo 'Put the cursor on a word first.'
    return
  endif
  " git grep only works inside a repo; fall back to vimgrep elsewhere.
  if &grepprg ==# 'internal'
        \ || (&grepprg =~# '^git' && empty(finddir('.git', '.;')) && empty(findfile('.git', '.;')))
    execute 'silent! vimgrep /\<' . escape(a:word, '/\') . '\>/gj **/*'
  else
    execute 'silent! grep! -w ' . shellescape(a:word)
  endif
  redraw!
  echo len(getqflist()) . ' match(es) for "' . a:word . '"'
endfunction

" ---- Tags — Ctrl-] jumps to a definition ------------------------------------
" Look for a 'tags' file next to the current file, then in each parent folder.
set tags=./tags;,tags

" :MakeTags — index the current directory with ctags (<Space>t).
command! MakeTags call s:MakeTags()
function! s:MakeTags() abort
  if !executable('ctags')
    echohl WarningMsg
    echo 'ctags not found. Install Universal Ctags, or use <Space>g / :grep instead.'
    echohl None
    return
  endif
  let l:excludes = ['.git', 'bin', 'obj', 'node_modules', 'dist', '__pycache__',
        \ '.venv', 'venv', '.vs', '*.min.js']
  let l:cmd = 'ctags -R'
  for l:dir in l:excludes
    let l:cmd .= ' --exclude=' . l:dir
  endfor
  let l:output = system(l:cmd . ' -f tags .')
  if v:shell_error
    echohl ErrorMsg | echo l:output | echohl None
  else
    echo 'Wrote ' . fnamemodify('tags', ':p')
  endif
endfunction
