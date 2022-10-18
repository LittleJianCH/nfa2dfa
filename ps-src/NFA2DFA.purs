module NFA2DFA
  ( nfa2dfa
  )
  where

import Prelude (class Ord, Unit, bind, map, not, pure, unit, when, ($))
import Control.Monad.State (State, execState, get, modify)
import Data.Foldable (any, elem)
import Data.List as L
import Data.Map as M
import Data.Set as S
import Data.Traversable (for)
import Data.Tuple (Tuple, fst)
import Data.Maybe (fromMaybe)
import Data.Tuple.Nested (over1, (/\))
import Definitions.DFA (DFA)
import Definitions.NFA (NFA)

steps :: forall a . Ord a => NFA a -> S.Set a -> Char -> S.Set a
steps nfa as c = S.unions $
  S.map (\a -> fromMaybe S.empty $ M.lookup (a /\ c) trans) as
  where trans = nfa.transition

type Transition a = M.Map (Tuple a Char) a

nfa2dfa :: forall a . Ord a => NFA a -> DFA (S.Set a)
nfa2dfa nfa =
  let (visited /\ transition) = dfs_result
  in {
    start : nfa.starts,
    alphabet : nfa.alphabet,
    accepts : S.filter (any (\a -> elem a nfa.accepts)) visited,
    transition : transition
  }

  where dfs_result :: Tuple (S.Set (S.Set a)) (Transition (S.Set a))
        dfs_result = execState (dfs nfa.starts) (S.empty /\ M.empty)

        dfs :: S.Set a ->
          State (Tuple (S.Set (S.Set a)) (Transition (S.Set a))) Unit
        dfs cur = do
          vis <- map fst get
          when (not (S.member cur vis)) do
            _ <- modify (over1 (S.insert cur))
            _ <- (
              for (L.fromFoldable nfa.alphabet) \c -> do
                let nexts = steps nfa cur c
                _ <- modify (map (M.insert (cur /\ c) nexts))
                dfs nexts)
            pure unit

