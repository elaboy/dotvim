" Batch (.bat/.cmd): 4-space indent.
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" New batch files are saved with CRLF line endings. With LF endings cmd.exe can
" miss labels, breaking `goto` and `call :label`. Existing files keep theirs
" (:set ff=dos then :w to convert one).
if !filereadable(expand('%:p'))
  setlocal fileformat=dos
endif
