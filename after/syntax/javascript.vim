" Vim's JavaScript syntax is old and leaves most modern code uncoloured,
" while its TypeScript syntax is thorough. TypeScript is a superset of
" JavaScript, so highlight .js files with the TypeScript rules instead.
syntax clear
unlet! b:current_syntax
runtime! syntax/typescript.vim
let b:current_syntax = 'javascript'
