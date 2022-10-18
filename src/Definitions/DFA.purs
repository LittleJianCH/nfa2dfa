module Definitions.DFA
  ( DFA
  , recognize
  , recognizeStr
  )
  where

import Data.Foldable (class Foldable, foldM)
import Data.List as S
import Data.Map as M
import Data.Maybe (Maybe(..))
import Data.Set (Set)
import Data.String.CodeUnits (toCharArray)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Prelude (class Ord, ($), (<<<))

type DFA a = {
  start      :: a,
  accpects   :: Set a,
  transition :: M.Map (Tuple a Char) a,
  alphabet   :: Set Char
}

recognize :: forall a f .
  Ord a => Foldable f =>
  DFA a -> f Char -> Boolean
recognize dfa str = check $ foldM (\t c -> M.lookup (t /\ c) trans) dfa.start str
  where trans = dfa.transition
        check :: Maybe a -> Boolean
        check res = case res of
          Just r -> S.elem r dfa.accpects
          Nothing -> false

recognizeStr :: forall a .
  Ord a =>
  DFA a -> String -> Boolean
recognizeStr dfa = recognize dfa <<< toCharArray
