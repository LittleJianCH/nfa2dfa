import { mkNFA, nfa2dfa } from "../../output/NFA2DFA/index.js";
import { drawDFA } from "./drawDFA";

function edge(from, char, to) {
  return {from, to, char};
}

// Here is a example of Test.nfa1
const nfa = mkNFA([1], [3, 4], [edge(1, '0', 2)
                              , edge(1, '0', 3)
                              , edge(1, '1', 2)
                              , edge(2, '0', 1)
                              , edge(2, '1', 1)
                              , edge(2, '1', 4)], ['0', '1']);
const dfa = nfa2dfa(nfa);

drawDFA(dfa, "network");
