" Shortcuts. <leader> is the Space bar: press Space, then the letter.
" Each one just types a stock command, shown on the right, so you also learn
" what to use on a machine without this config.

let mapleader = ' '
nnoremap <Space> <Nop>

nnoremap <leader>f :find<Space>
nnoremap <leader>b :ls<CR>:buffer<Space>
nnoremap <silent> <leader>m :call <SID>Make()<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> <leader>q :call <SID>ToggleQuickfix()<CR>
nnoremap <silent> <leader>g :GrepWord<CR>
nnoremap <silent> <leader>t :MakeTags<CR>
nnoremap <silent> <leader><Space> :nohlsearch<CR>

" Build or lint with whatever after/ftplugin/ chose for this file type.
" b:dotvim_make_args is '%' for linters that check one file at a time.
function! s:Make() abort
  if !exists('b:current_compiler')
    echohl WarningMsg
    echo 'No build/lint tool for filetype "' . &filetype . '" (or it is not installed).'
    echohl None
    return
  endif
  let l:tool = b:current_compiler
  update
  " The quickfix window opens on errors and takes the cursor: press Enter on
  " a line to jump there, or Ctrl-W p to go back to your file.
  execute 'silent make! ' . get(b:, 'dotvim_make_args', '')
  redraw!
  let l:count = len(filter(getqflist(), 'v:val.valid'))
  echo l:tool . ': ' . (l:count ? l:count . ' problem(s)' : 'OK')
endfunction

function! s:ToggleQuickfix() abort
  for l:win in getwininfo()
    if l:win.quickfix && !l:win.loclist
      cclose
      return
    endif
  endfor
  copen
endfunction
