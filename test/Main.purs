module Test.Main where

import Prelude (Unit, discard, ($), (==))
import Data.Array (all)
import Data.Map as M
import Data.Set as S
import Data.Tuple.Nested ((/\))
import Definitions.DFA (DFA)
import Definitions.DFA as D
import Definitions.NFA (NFA)
import Definitions.NFA as N
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

dfa2 :: DFA Int
-- dfa2 is an DFA that accepts the language which
-- is ended with 0 and has odd length
-- or is ended with 1 and has even length
dfa2 = {
  start : 1,
  accpects : S.fromFoldable [2, 5],
  transition : M.fromFoldable [
    (1 /\ '0') /\ 2,
    (1 /\ '1') /\ 4,
    (2 /\ '0') /\ 3,
    (2 /\ '1') /\ 5,
    (3 /\ '0') /\ 2,
    (3 /\ '1') /\ 4,
    (4 /\ '0') /\ 3,
    (4 /\ '1') /\ 5,
    (5 /\ '0') /\ 2,
    (5 /\ '1') /\ 4
  ]
}

nfa1 :: NFA Int
-- nfa1 is an NFA that accepts the language which
-- is ended with 0 and has odd length
-- or is ended with 1 and has even length
nfa1 = {
  starts : S.fromFoldable [1],
  accpects : S.fromFoldable [3, 4],
  transition : M.fromFoldable [
    (1 /\ '0') /\ S.fromFoldable [2, 3],
    (1 /\ '1') /\ S.fromFoldable [2],
    (2 /\ '0') /\ S.fromFoldable [1],
    (2 /\ '1') /\ S.fromFoldable [1, 4]
  ]
}

main :: Effect Unit
main = do
  assert $ D.recognizeStr dfa1 "0001" == true
  assert $ D.recognizeStr dfa1 "1001" == false
  assert $ D.recognizeStr dfa1 "0aa1" == false

  let zeroOddOneEvenTests = [
    "0" /\ true,
    "11" /\ true,
    "01" /\ true,
    "0100" /\ false,
    "101" /\ false
  ]
  assert $ all
    (\(str /\ expected) -> D.recognizeStr dfa2 str == expected)
    zeroOddOneEvenTests
  assert $ all
    (\(str /\ expected) -> N.recognizeStr nfa1 str == expected)
    zeroOddOneEvenTests

  log "All test passed 🎉🎉🎉"
