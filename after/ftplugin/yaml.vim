" YAML, including Docker Compose files. Vim's ftplugin sets 2-space indent;
" tabs are illegal in YAML and show up as '>' thanks to 'list'.

" <Space>m: yamllint if installed; for compose files, otherwise ask docker to
" validate the merged configuration (`docker compose config`).
let b:is_compose = expand('%:t') =~? '\v^(docker-)?compose.*\.ya?ml$'
if executable('yamllint')
  compiler yamllint
  let b:dotvim_make_args = '%'
elseif b:is_compose && executable('docker')
  compiler compose
endif
