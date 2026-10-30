# dotvim

A portable Vim setup for C#, Python, SQL, TypeScript/JavaScript, PowerShell,
Bash, Batch, Dockerfiles and Docker Compose. **No plugins**: it uses only what
ships with Vim, so it also works where third-party plugins are not allowed.

Works in Git Bash's Vim, native Windows Vim/gVim, Linux and WSL. Vim 8.0 or
newer; on Vim 9.1+ you get everything.

New to Vim? Run `vimtutor` first (about 30 minutes). It teaches the movement
and editing keys this sheet assumes.

## Install

```sh
git clone https://github.com/elaboy/dotvim ~/dotvim
~/dotvim/install.sh                 # or: ~/dotvim/install.sh path/to/project
```

The installer backs up your existing `~/.vimrc` and replaces it with one line,
`source ~/dotvim/vimrc`. In Git Bash it also writes `~/_vimrc`, because native
Windows Vim only reads that file. Run it again any time; it won't touch files
that are already set up. It ends by listing which optional tools it found.
To update later: `git -C ~/dotvim pull`.

- **No git?** `curl -L https://github.com/elaboy/dotvim/archive/refs/heads/main.tar.gz | tar xz`, then run `dotvim-main/install.sh`.
- **Windows without Git Bash?** Double-click `install.cmd`.
- **Native Windows Vim users:** without a `~/_vimrc`, gVim loads the `_vimrc` in its install folder, which only loads `vimrc_example.vim`. This config takes its place and keeps the same basics. `y` and `p` use the Windows clipboard.

## Cheat sheet

`<Space>` is the leader key: press Space, then the letter. The right-hand column
is the stock command each shortcut types, which works on any Vim.

### Files and buffers
| Keys | What it does | Stock Vim |
|---|---|---|
| `Space f` | find a file by name; Tab completes, `*` is a wildcard | `:find name` |
| `Space b` | list open files, type a number or part of a name | `:ls` then `:b name` |
| `Ctrl-^` | jump back to the previous file | |
| `gf` | open the file whose name is under the cursor | |
| `:e .` | browse the current folder | |

Start Vim from the project's root folder: `:find` searches everything below it,
skipping `bin/`, `obj/`, `.git/`, `node_modules/`, `dist/` and `.venv/`.

### Build, lint and errors
| Keys | What it does | Stock Vim |
|---|---|---|
| `Space m` | build or lint (see the table below); errors go to the quickfix list | `:make` |
| `Enter` | in the quickfix window, jump to that error | |
| `]q` / `[q` | next / previous error | `:cnext` / `:cprevious` |
| `Space q` | open/close the quickfix window | `:copen` / `:cclose` |
| `Ctrl-W p` | go back to the previous window | |

### Search
| Keys | What it does | Stock Vim |
|---|---|---|
| `/text` then `n` / `N` | search this file forward, next, previous | |
| `*` | search this file for the word under the cursor | |
| `Space g` | search the whole project for the word under the cursor | `:grep -w word` |
| `:grep text` | search the whole project | |
| `:vimgrep /text/ **/*.cs` | search with Vim itself (no external tool) | |
| `Space Space` | clear search highlighting | `:nohlsearch` |

### Go to definition (tags)
Needs [Universal Ctags](https://github.com/universal-ctags/ctags)
(`winget install UniversalCtags.Ctags`, `sudo apt install universal-ctags`).
Without it, use `Space g`.

| Keys | What it does |
|---|---|
| `Space t` | (re)build the `tags` index for the current folder (`:MakeTags`) |
| `Ctrl-]` | jump to the definition under the cursor |
| `Ctrl-T` | jump back |
| `g]` | list every definition with that name and pick one |
| `:tag Name` | jump to a definition by name (Tab completes) |

Add `tags` to each project's `.gitignore`.

### Completion (insert mode)
| Keys | Completes |
|---|---|
| `Ctrl-N` / `Ctrl-P` | words from every open file and the tags index |
| `Ctrl-X Ctrl-O` | language-aware completion where Vim has it, keywords elsewhere |
| `Ctrl-X Ctrl-]` | names from the tags index |
| `Ctrl-X Ctrl-F` | file paths |

There's no semantic completion (IntelliSense) without plugins or an LSP; this
is word, keyword and tag completion.

### Editing
| Keys | What it does |
|---|---|
| `gcc` | comment / uncomment this line (Vim 9.1+) |
| `gc` + motion | comment / uncomment a block, e.g. `gcip` for a paragraph, `gc` in visual mode |
| `%` | jump between matching brackets, `if`/`else`, `#region`/`#endregion` |
| `=` + motion | re-indent, e.g. `gg=G` for the whole file |
| `u` / `Ctrl-R` | undo / redo (undo history is kept after you close the file) |

## Languages

Each row is in addition to Vim's own support for the language. A project's
`.editorconfig` wins over these indent settings.

| Language | Indent | `Space m` runs | Without the tool |
|---|---|---|---|
| C# | 4 | `dotnet build` in the current folder | message |
| Python | 4 | `ruff check`, or `pylint file` | message |
| SQL | 4 | — | |
| TypeScript | 2 | `tsc --noEmit` from the project's node_modules | |
| JavaScript | 2 | `eslint file` from the project's node_modules | |
| PowerShell | 4 | — (`:compiler powershell \| make` *runs* the script) | |
| Bash | 4 | `shellcheck file` | `bash -n file` (syntax only) |
| Batch | 4 | — (new files are saved with CRLF line endings) | |
| Dockerfile | 4 | `hadolint file` | message |
| Compose / YAML | 2 | `yamllint file`, or `docker compose config` for compose files | message |
| JSON, XML (`.csproj`) | 2 | — | |

**SQL dialects.** Vim highlights SQL with its Oracle dialect by default, which
covers standard SQL, including PostgreSQL; Vim has no Postgres dialect.
For PL/SQL packages and procedures, run `:SqlPlsql`. To see every dialect, type
`:SQLSetType` followed by a space and press Tab. SQL keyword completion is on
`Ctrl-J k` (keywords), `Ctrl-J f` (functions) and `Ctrl-J T` (types), so Ctrl-C
still leaves insert mode.

## Layout

```
vimrc                 entry point: adds this repo to Vim's search path, loads config/
config/options.vim    editor defaults, clipboard, swap/undo in ~/.vim-data
config/search.vim     :find, :grep, :GrepWord, :MakeTags, quickfix behaviour
config/completion.vim completion settings
config/mappings.vim   the Space shortcuts
after/ftplugin/*.vim  per-language settings, applied after Vim's own
after/indent/*.vim    per-language indent fixes
compiler/*.vim        :make setups Vim doesn't ship (hadolint, compose)
fallback/compiler/    copies of newer Vim's compilers, used only on old Vims
```

Swap, backup and undo files go to `~/.vim-data/`, not next to your code.
