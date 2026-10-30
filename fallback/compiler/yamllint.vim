" Fallback for Vims older than 9.0 that lack compiler/yamllint.vim.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'yamllint'

CompilerSet makeprg=yamllint\ -f\ parsable
CompilerSet errorformat=%f:%l:%c:\ [%t%*[a-z]]\ %m,
                       \%-G%.%#
