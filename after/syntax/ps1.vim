" More PowerShell highlighting, on top of Vim's syntax/ps1.vim.

" Method calls: (Get-Date).AddDays(-7), $s.Trim().
syn match ps1DotvimMethod "\.\zs\h\w*\ze("
" Properties: $_.LastWriteTime, $file.FullName.
syn match ps1DotvimProperty "\.\zs\h\w*\>\ze\%([^(]\|$\)"
" Attributes: [Parameter(Mandatory)], [CmdletBinding()].
syn match ps1DotvimAttribute "\[\zs\u\w*\ze("

hi def link ps1DotvimMethod    Function
hi def link ps1DotvimProperty  Identifier
hi def link ps1DotvimAttribute PreProc
