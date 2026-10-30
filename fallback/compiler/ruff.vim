" Fallback for Vims older than 9.1 that lack compiler/ruff.vim.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'ruff'

CompilerSet makeprg=ruff\ check\ --output-format=concise
CompilerSet errorformat=%f:%l:%c:\ %m,
                       \%-GFound\ %.%#,
                       \%-G%.%#
