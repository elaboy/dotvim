" Fallback for Vims older than 8.1 that lack compiler/eslint.vim.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'eslint'

CompilerSet makeprg=npx\ eslint\ --format\ stylish
CompilerSet errorformat=%-P%f,
                       \%\s%#%l:%c\ %#\ %trror\ \ %m,
                       \%\s%#%l:%c\ %#\ %tarning\ \ %m,
                       \%-Q,
                       \%-G%.%#
