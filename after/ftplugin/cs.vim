" C#: on top of Vim's ftplugin/cs.vim and indent/cs.vim.
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
setlocal cinoptions+=j1,(0,ws,Ws    " lambdas, wrapped arguments
setlocal suffixesadd=.cs            " gf on 'Foo' opens Foo.cs

" <Space>m runs `dotnet build` from the current directory (where the .sln or
" .csproj is) and loads the errors into the quickfix list.
if executable('dotnet')
  let g:dotnet_show_project_file = 0      " drop the trailing [x.csproj]
  let $MSBUILDTERMINALLOGGER = 'off'      " plain output on .NET 9+
  compiler dotnet
  " Absolute paths, so quickfix jumps work from any directory.
  setlocal makeprg+=\ -p:GenerateFullPaths=true
endif
