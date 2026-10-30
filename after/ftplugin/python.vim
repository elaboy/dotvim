" Python: Vim's ftplugin already sets 4-space indent and omni-complete.
setlocal textwidth=88               " ruff / black line length

" <Space>m lints with ruff (whole project) or pylint (this file).
" No fallback to plain `python`: on Windows that can be the Microsoft Store stub.
if executable('ruff')
  compiler ruff
elseif executable('pylint')
  compiler pylint
  let b:dotvim_make_args = '%'
endif
