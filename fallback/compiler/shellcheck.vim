" Fallback for Vims older than 9.0 that lack compiler/shellcheck.vim.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'shellcheck'

CompilerSet makeprg=shellcheck\ -f\ gcc
CompilerSet errorformat=%f:%l:%c:\ %trror:\ %m\ [SC%n],
                       \%f:%l:%c:\ %tarning:\ %m\ [SC%n],
                       \%f:%l:%c:\ %tote:\ %m\ [SC%n],
                       \%-G%.%#
