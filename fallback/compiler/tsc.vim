" Fallback for old Vims whose compiler/tsc.vim ignores b:tsc_makeprg.
" Newer Vims load their own copy first; this file then does nothing.
if exists('current_compiler')
  finish
endif
let current_compiler = 'tsc'

execute 'CompilerSet makeprg=' . escape(get(b:, 'tsc_makeprg', get(g:, 'tsc_makeprg', 'tsc')), ' \|"')
CompilerSet errorformat=%f\ %#(%l\,%c):\ %trror\ TS%n:\ %m,
                       \%trror\ TS%n:\ %m,
                       \%-G%.%#
