" Vim compiler file — `docker compose config` validation of a compose file.
" Docker reports schema errors without a line number, so those entries jump
" to the file only; YAML syntax errors do carry a line.
if exists('current_compiler')
  finish
endif
let current_compiler = 'compose'

" validating C:\app\compose.yaml: services.web additional properties 'x' not allowed
" yaml: line 4: mapping values are not allowed in this context
CompilerSet makeprg=docker\ compose\ -f\ %:S\ config\ -q
CompilerSet errorformat=%Evalidating\ %f:\ %m,
                       \%Eyaml:\ line\ %l:\ %m,
                       \%-G%\s%#,
                       \%+G%m
