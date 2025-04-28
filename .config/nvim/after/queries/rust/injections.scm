; Inject SQL syntax highlighting for sqlx macros
(macro_invocation
  macro: (scoped_identifier
           path: (identifier) @path (#eq? @path "sqlx")
           name: (identifier) @name (#match? @name "query(_as)?(_scalar)?"))
  (token_tree
    (raw_string_literal) @sql)
  (#offset! @sql 0 1 0 -1)
  (#set! injection.language "sql")
  (#set! injection.include-children))
