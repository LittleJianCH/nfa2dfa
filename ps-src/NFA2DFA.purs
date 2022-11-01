module NFA2DFA
  ( mkNFA
  , nfa2dfa
  )
  where

import Data.Function.Uncurried (Fn1, Fn4, mkFn1, mkFn4)
import Data.Tuple (uncurry)
import Data.Array as A
import Data.Map as M
import Data.Set as S
import Data.Tuple.Nested ((/\))
import Definitions.NFA (NFA)
import Prelude (map, ($))
import Transform as T

type Edge a = {
  from :: a,
  to   :: a,
  char :: Char
}

mkNFA :: Fn4 (Array Int) (Array Int) (Array (Edge Int)) (Array Char) (NFA Int)
mkNFA = mkFn4 \starts accepts edges alphabet ->
  { starts: S.fromFoldable starts
  , accepts: S.fromFoldable accepts
  , transition: A.foldr (uncurry $ M.insertWith S.intersection)
                        M.empty
                        (map (\e -> (e.from /\ e.char) /\ (S.singleton e.to)) edges)
  , alphabet: S.fromFoldable alphabet
  }

type DFA = {
  start :: Array Int,
  accepts :: Array (Array Int),
  edges :: Array (Edge (Array Int))
}

nfa2dfa :: Fn1 (NFA Int) DFA
nfa2dfa = mkFn1 $ \nfa ->
  let dfa = T.nfa2dfa nfa in {
    start: A.fromFoldable dfa.start,
    accepts: map A.fromFoldable (A.fromFoldable dfa.accepts),
    edges: map (\((from /\ ch) /\ to) -> {
                 from: A.fromFoldable from,
                 to: A.fromFoldable to,
                 char: ch
               })
               (M.toUnfoldable dfa.transition)
  }
