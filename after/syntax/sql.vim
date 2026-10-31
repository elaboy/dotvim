" More SQL highlighting, on top of Vim's SQL syntax (Oracle dialect by default).
" Adds the PostgreSQL vocabulary the Oracle dialect lacks, plus common DDL
" words, function calls, casts, parameters and JSON operators.
syntax case ignore

syn keyword sqlKeyword primary key foreign references constraint unique check
syn keyword sqlKeyword generated always identity cascade restrict
syn keyword sqlKeyword returning ilike limit offset fetch first next rows only
syn keyword sqlKeyword conflict nothing lateral over partition window recursive
syn keyword sqlKeyword materialized concurrently returns language
syn keyword sqlKeyword declare loop exception raise notice perform execute
syn keyword sqlKeyword plpgsql

syn keyword sqlType uuid json jsonb serial bigserial smallserial
syn keyword sqlType timestamp timestamptz timetz interval boolean bool
syn keyword sqlType text bytea numeric decimal integer int int2 int4 int8
syn keyword sqlType bigint smallint real double precision inet cidr citext
syn keyword sqlType money tsvector clob nclob blob nvarchar2 nchar binary_double

" Function calls: now(), best_lap(...), DBMS_OUTPUT.PUT_LINE(...).
syn match sqlDotvimCall "\<\h\w*\ze("
" Casts and parameters: '{}'::jsonb, $1.
syn match sqlDotvimCast "::\s*\h\w*"
syn match sqlDotvimParam "\$\d\+"
" $$ ... $$ function bodies (Postgres) and the / terminator (Oracle).
syn match sqlDotvimDelimiter "\$\h\w*\$\|\$\$\|^\s*/\s*$"
" JSON operators and PL/SQL assignment.
syn match sqlDotvimOperator "->>\|->\|#>>\|#>\|@>\|<@\|:="
" PL/SQL cursor attributes and packages: SQL%ROWCOUNT, DBMS_OUTPUT.
syn match sqlDotvimSpecial "%\%(rowcount\|rowtype\|type\|found\|notfound\|isopen\)\>"
syn match sqlDotvimPackage "\<\%(dbms\|utl\|apex\)_\w*\ze\."

hi def link sqlDotvimCall      Function
hi def link sqlDotvimCast      Type
hi def link sqlDotvimParam     Special
hi def link sqlDotvimDelimiter Special
hi def link sqlDotvimOperator  Operator
hi def link sqlDotvimSpecial   Special
hi def link sqlDotvimPackage   Type
