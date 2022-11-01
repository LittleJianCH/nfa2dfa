import {mkNFA, nfa2dfa} from "../../output/NFA2DFA/index.js";

const hash = require('object-hash');
const vis = require('vis-network/standalone');

function edge(from, char, to) {
  return {from, to, char};
}

function getNodes(dfa) {
  var nodes = new vis.DataSet();
  for (var i = 0; i < dfa.nodes.length; i++) {
    nodes.add({id: hash(dfa.nodes[i]), label: dfa.nodes[i].toString()});
  }
  return nodes;
}

function getEdges(dfa) {
  var edges = new vis.DataSet();
  for (var i = 0; i < dfa.edges.length; i++) {
    edges.add({
      from: hash(dfa.edges[i].from),
      to: hash(dfa.edges[i].to),
      label: dfa.edges[i].char,
      arrows: {
        to: {
          enabled: true,
          type: 'arrow'
        }
      }
    });
  }
  return edges;
}


// Here is a example of Test.nfa1

const nfa = mkNFA([1], [3, 4], [edge(1, '0', 2)
                              , edge(1, '0', 3)
                              , edge(1, '1', 2)
                              , edge(2, '0', 1)
                              , edge(2, '1', 1)
                              , edge(2, '1', 4)], ['0', '1']);
const dfa = nfa2dfa(nfa);

var nodes = getNodes(dfa);
var edges = getEdges(dfa);

var container = document.getElementById("network");
var data = {
  nodes: nodes,
  edges: edges,
};
var options = {};
var network = new vis.Network(container, data, options);
