" Bash: 4-space indent (g:is_bash is set in config/options.vim).
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" <Space>m checks this file with shellcheck if installed. Otherwise Vim's
" ftplugin has already picked `bash -n` (syntax check only).
if executable('shellcheck')
  compiler shellcheck
endif
" Both read stdin when given no file name, so always pass this file.
let b:dotvim_make_args = '%'
