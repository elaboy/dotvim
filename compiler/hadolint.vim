" Vim compiler file — hadolint (Dockerfile linter). Vim ships none.
if exists('current_compiler')
  finish
endif
let current_compiler = 'hadolint'

" Dockerfile:3:1: warning: DL3006 Always tag the version of an image explicitly
CompilerSet makeprg=hadolint\ --no-color\ -f\ gcc
CompilerSet errorformat=%f:%l:%c:\ %trror:\ %m,
                       \%f:%l:%c:\ %tarning:\ %m,
                       \%f:%l:%c:\ %m,
                       \%-G%.%#
