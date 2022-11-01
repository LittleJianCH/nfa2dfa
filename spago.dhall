{ name = "nfa2dfa"
, dependencies =
  [ "arrays"
  , "assert"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "functions"
  , "lists"
  , "maybe"
  , "ordered-collections"
  , "prelude"
  , "quickcheck"
  , "strings"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "ps-src/**/*.purs", "test/**/*.purs" ]
}
