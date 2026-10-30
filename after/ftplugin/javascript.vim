" JavaScript: 2-space indent.
setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" <Space>m lints this file with the project's eslint (if node_modules has it).
if executable('npx')
  compiler eslint
  setlocal makeprg=npx\ --no-install\ eslint\ --format\ stylish
  let b:dotvim_make_args = '%'
endif
