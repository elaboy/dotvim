" TypeScript: 2-space indent.
setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" <Space>m type-checks the project with the tsc installed in node_modules.
" --no-install: never download packages behind your back.
if executable('npx')
  let b:tsc_makeprg = 'npx --no-install tsc --noEmit --pretty false'
  compiler tsc
endif
