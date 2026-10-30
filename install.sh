#!/usr/bin/env bash
# Install dotvim: make ~/.vimrc source this repo's vimrc. In Git Bash it also
# writes ~/_vimrc, because native Windows Vim (gvim.exe) only reads that one.
#
# Usage: ./install.sh [project-dir]
#   project-dir  also build a ctags index there, so Ctrl-] works right away
#
# Safe to re-run: existing files are backed up once, then left alone.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)

case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        git_bash=1
        vimrc_path=$(cygpath -m "$repo/vimrc")   # C:/Users/... works in both Vims
        ;;
    *)
        git_bash=0
        vimrc_path="$repo/vimrc"
        ;;
esac
stub="source ${vimrc_path// /\ }"

install_stub() {
    local target=$1
    if [ -f "$target" ] && [ "$(cat "$target")" = "$stub" ]; then
        echo "  $target already points here"
        return
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup
        backup="$target.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$backup"
        echo "  backed up $target -> $backup"
    fi
    printf '%s\n' "$stub" > "$target"
    echo "  wrote $target"
}

echo "Installing dotvim from $repo"
install_stub "$HOME/.vimrc"
if [ "$git_bash" = 1 ]; then
    install_stub "$HOME/_vimrc"
fi

# Load the config once and fail loudly if it reports any error.
if command -v vim >/dev/null 2>&1; then
    if vim -Nu "$HOME/.vimrc" -i NONE -es \
        -c 'if v:errmsg !=# "" | cquit | endif' -c 'qa!' </dev/null; then
        echo "  vim loaded the config without errors"
    else
        echo "  vim reported an error loading the config: run vim and check :messages" >&2
        exit 1
    fi
else
    echo "  vim is not on PATH; skipping the load check"
fi

echo
echo "Optional tools (missing ones just disable a feature):"
report() {
    if command -v "$1" >/dev/null 2>&1; then
        printf '  %-11s found    %s\n' "$1" "$2"
    else
        printf '  %-11s missing  %s\n' "$1" "$2"
    fi
}
report ctags      "Ctrl-] go to definition (:MakeTags)"
report rg         "fast :grep (falls back to git grep / vimgrep)"
report dotnet     "<Space>m in C#"
report npx        "<Space>m in TypeScript / JavaScript"
report ruff       "<Space>m in Python (or pylint)"
report shellcheck "full <Space>m lint in Bash (bash -n otherwise)"
report hadolint   "<Space>m in Dockerfiles"
report yamllint   "<Space>m in YAML"
report docker     "<Space>m in compose files (if no yamllint)"

if [ $# -gt 0 ]; then
    echo
    if command -v ctags >/dev/null 2>&1; then
        (
            cd "$1"
            ctags -R --exclude=.git --exclude=bin --exclude=obj \
                --exclude=node_modules --exclude=dist --exclude=__pycache__ \
                --exclude=.venv --exclude=venv --exclude=.vs --exclude='*.min.js' \
                -f tags .
        )
        echo "Wrote $1/tags (add 'tags' to that project's .gitignore)"
    else
        echo "ctags not found, so no index was built. Install Universal Ctags:"
        echo "  Windows: winget install UniversalCtags.Ctags"
        echo "  Debian/Ubuntu/WSL: sudo apt install universal-ctags"
    fi
fi
