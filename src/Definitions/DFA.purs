module Definitions.DFA (
  DFA ,
  recognize
) where

import Prelude (class Ord, ($))
import Data.List (List)
import Data.List as S
import Data.Map as M
import Data.Set (Set)
import Data.Tuple (Tuple)
import Data.Foldable (foldM)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

type DFA a = {
  start      :: a,
  accpects   :: Set a,
  transition :: M.Map (Tuple a Char) a
}

recognize :: forall a . Ord a => DFA a -> List Char -> Boolean
recognize dfa str = check $ foldM (\t c -> M.lookup (t /\ c) trans) dfa.start str
  where trans = dfa.transition
        check :: Maybe a -> Boolean
        check res = case res of
          Just r -> S.elem r dfa.accpects
          Nothing -> false
