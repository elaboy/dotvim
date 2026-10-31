" More C# highlighting, on top of Vim's syntax/cs.vim.
" Vim can't know your own type names, so this follows C# naming conventions:
" PascalCase names in type positions are types, and Name( is a method call.
" csUserType / csUserInterface / csUserMethod are hooks that Vim's C# syntax
" reserves for exactly this, so they also work inside (), {} and $"{...}".

" Interfaces: IDisposable, IReadOnlyList<T>.
syn match csUserInterface "\<I\u\w*\>"
" A type followed by a generic list: List<int>, Task<string>.
syn match csUserType "\<\u\w*\ze<"
" A type in a declaration: `Exception ex)`, `CrashLog log =`, `Foo? x;`, `Foo[] xs`.
syn match csUserType "\<\u\w*\ze[?\[\]]*\s\+@\=\h\w*\s*\%([=;,){]\|=>\)"
" Exception types: catch (IOException), catch (Exception ex).
syn match csUserType "\%(\<catch\s*(\s*\)\@<=\u\w*"
" Type patterns: x is Foo, x as Foo, ex is IOException or UnauthorizedAccessException.
syn match csUserType "\%(\<\%(is\|as\|or\|and\|not\)\s\+\)\@<=\u\w*"
" Static access and namespaces: Path.Combine, System.IO.
syn match csUserType "\<\u\w*\ze\.\u"
" Method calls and declarations: Load(), Select<T>(). Defined last, so a
" generic method call wins over the generic-type rule above.
syn match csUserMethod "\<\h\w*\ze\s*\%(<[^<>;()]*>\)\=\s*("

" Type names inside <...> and after `new`, where Vim's own regions apply.
syn match csDotvimInnerType "\<\u\w*\>" contained containedin=csGeneric,csNewType
" Attributes: [Fact], [ObservableProperty], [JsonPropertyName("x")].
syn match csDotvimAttribute "^\s*\[\zs\u\w*\ze[\](]"

hi def link csUserType        Type
hi def link csUserInterface   Type
hi def link csUserMethod      Function
hi def link csDotvimInnerType Type
hi def link csDotvimAttribute PreProc
