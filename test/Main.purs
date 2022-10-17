module Test.Main where

import Data.Array
import Prelude

import Data.Foldable (class Foldable)
import Data.Map as M
import Data.Set as S
import Data.String.CodeUnits (toCharArray)
import Data.Tuple.Nested ((/\))
import Definitions.DFA (DFA, recognize, recognizeStr)
import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert)

dfa1 :: DFA Int
-- dfa1 is a DFA that accepts the language {0 (0|1)^n 1 | n >= 0}
dfa1 = {
  start : 1,
  accpects : S.fromFoldable [3],
  transition : M.fromFoldable [
    (1 /\ '0') /\ 2,
    (2 /\ '0') /\ 2,
    (2 /\ '1') /\ 3,
    (3 /\ '0') /\ 2,
    (3 /\ '1') /\ 3
  ]
}

main :: Effect Unit
main = do
  assert $ recognizeStr dfa1 "0001" == true
  assert $ recognizeStr dfa1 "1001" == false
  log "All test passed 🎉🎉🎉"
