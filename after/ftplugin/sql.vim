" SQL: Vim highlights SQL with the Oracle dialect by default. Standard SQL
" (PostgreSQL included) highlights fine with it; Vim has no Postgres dialect.
" Switch dialect per file with :SQLSetType <Tab>, e.g. :SqlPlsql below.
setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Oracle PL/SQL packages, procedures and triggers.
command! -buffer SqlPlsql SQLSetType plsql

" Omni-complete keys moved off Ctrl-C (see config/options.vim):
"   Ctrl-J k   SQL keywords       Ctrl-J f   functions
"   Ctrl-J o   options            Ctrl-J T   types
"   Ctrl-J s   statements         Ctrl-X Ctrl-O   everything
