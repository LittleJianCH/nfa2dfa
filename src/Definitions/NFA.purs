module Definitions.NFA
  ( NFA
  , recognize
  , recognizeStr
  )
  where

import Data.Foldable (class Foldable, any, elem, foldl)
import Data.Map as M
import Data.Maybe (fromMaybe)
import Data.Set as S
import Data.String.CodeUnits (toCharArray)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Prelude (class Ord, ($), (<<<))

type NFA a = {
  starts     :: S.Set a,
  accpects   :: S.Set a,
  transition :: M.Map (Tuple a Char) (S.Set a),
  alphabet   :: S.Set Char
}

recognize :: forall a f .
  Ord a => Foldable f =>
  NFA a -> f Char -> Boolean
recognize nfa str = check $
  foldl step nfa.starts str
  where check :: S.Set a -> Boolean
        check as = any (\a -> elem a nfa.accpects) as
        step :: S.Set a -> Char -> S.Set a
        step ts c = S.unions $
          S.map (\t ->fromMaybe S.empty $ M.lookup (t /\ c) trans) ts
          where trans = nfa.transition

recognizeStr :: forall a .
  Ord a =>
  NFA a -> String -> Boolean
recognizeStr nfa = recognize nfa <<< toCharArray
