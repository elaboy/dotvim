" Fallback for Vims older than 9.0 that lack compiler/dotnet.vim.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'dotnet'

CompilerSet makeprg=dotnet\ build\ -nologo\ -consoleloggerparameters:NoSummary
CompilerSet errorformat=%E%f(%l\,%c):\ %trror\ %m\ [%.%#],
                       \%W%f(%l\,%c):\ %tarning\ %m\ [%.%#],
                       \%-G%.%#
