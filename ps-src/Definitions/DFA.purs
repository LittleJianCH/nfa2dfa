module Definitions.DFA
  ( DFA
  , recognize
  , recognizeStr
  )
  where

import Data.Foldable (class Foldable, foldM)
import Data.List as L
import Data.Map as M
import Data.Maybe (Maybe(..))
import Data.Set as S
import Data.String.CodeUnits (toCharArray)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Prelude (class Ord, ($), (<<<))

type DFA a = {
  start      :: a,
  accepts    :: S.Set a,
  transition :: M.Map (Tuple a Char) a,
  alphabet   :: S.Set Char
}

recognize :: forall a f .
  Ord a => Foldable f =>
  DFA a -> f Char -> Boolean
recognize dfa str = check $ foldM (\t c -> M.lookup (t /\ c) trans) dfa.start str
  where trans = dfa.transition
        check :: Maybe a -> Boolean
        check res = case res of
          Just r -> L.elem r dfa.accepts
          Nothing -> false

recognizeStr :: forall a .
  Ord a =>
  DFA a -> String -> Boolean
recognizeStr dfa = recognize dfa <<< toCharArray
