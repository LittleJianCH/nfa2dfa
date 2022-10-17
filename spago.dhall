{ name = "my-project"
, dependencies =
  [ "console"
  , "effect"
  , "lists"
  , "ordered-collections"
  , "prelude"
  , "tuples"
  , "undefined"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
