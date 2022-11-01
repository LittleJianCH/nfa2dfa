module NFA2DFA
  ( mkNFA
  , nfa2dfa
  )
  where

import Data.Array as A
import Data.Array.NonEmpty (head)
import Data.Function.Uncurried (Fn1, Fn4, mkFn1, mkFn4)
import Data.Map as M
import Data.Ord (class Ord)
import Data.Set as S
import Data.Tuple (uncurry)
import Data.Tuple.Nested ((/\))
import Definitions.NFA (NFA)
import Prelude (map, ($), (<<<))
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
  , transition: A.foldr (uncurry $ M.insertWith S.union)
                        M.empty
                        (map (\e -> (e.from /\ e.char) /\ (S.singleton e.to)) edges)
  , alphabet: S.fromFoldable alphabet
  }

type DFA = {
  start :: Array Int,
  accepts :: Array (Array Int),
  edges :: Array (Edge (Array Int)),
  nodes :: Array (Array Int)
}

unique :: forall a . Ord a => Array a -> Array a
unique = map head <<< A.group <<< A.sort

nfa2dfa :: Fn1 (NFA Int) DFA
nfa2dfa = mkFn1 $ \nfa ->
  let dfa = T.nfa2dfa nfa
      keyValues = M.toUnfoldable dfa.transition
  in {
    start: A.fromFoldable dfa.start,
    accepts: map A.fromFoldable (A.fromFoldable dfa.accepts),
    edges: map (\((from /\ ch) /\ to) -> {
                 from: A.fromFoldable from,
                 to: A.fromFoldable to,
                 char: ch
               })
               keyValues,
    nodes: unique $ A.concatMap (\((from /\ _) /\ to) ->
                                  map A.fromFoldable [from, to])
                                keyValues
  }
