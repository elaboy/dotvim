" More Python highlighting, on top of Vim's syntax/python.vim.
" Follows Python naming conventions: name( is a call, CapWords is a class.

syn match pythonDotvimCall "\<\h\w*\ze\s*("
" CapWords with at least one lowercase letter, so CONSTANTS stay as they are.
" Defined after the call rule so `Lap(...)` reads as a class.
syn match pythonDotvimClass "\<\u\w*\l\w*\>"
syn keyword pythonDotvimSelf self cls

hi def link pythonDotvimCall  Function
hi def link pythonDotvimClass Type
hi def link pythonDotvimSelf  Special
