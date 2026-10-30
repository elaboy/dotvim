" Dockerfile: 4-space indent for continuation lines.
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" <Space>m lints this file with hadolint, if installed.
if executable('hadolint')
  compiler hadolint
  let b:dotvim_make_args = '%'
endif
