" PowerShell: 4-space indent.
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" No <Space>m here on purpose: Vim's 'powershell' compiler *runs* the script
" (pwsh file.ps1) rather than checking it. When you do want that:
"     :compiler powershell | make
