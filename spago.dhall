{ name = "nfa2dfa"
, dependencies =
  [ "arrays"
  , "assert"
  , "console"
  , "effect"
  , "foldable-traversable"
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
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
