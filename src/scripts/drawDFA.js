const hash = require('object-hash');
const vis = require('vis-network/standalone');
const str = JSON.stringify;

function getNodes(dfa) {
  var nodes = new vis.DataSet();
  for (var i = 0; i < dfa.nodes.length; i++) {
    var color = "#97C2FC";

    if (dfa.accepts.map(p => str(p)).indexOf(str(dfa.nodes[i])) !== -1) {
      color = "#56E39F";
    }

    if (str(dfa.start) === str(dfa.nodes[i])) {
      color = "#E2A76F";
    }

    nodes.add({
      id: hash(dfa.nodes[i]),
      label: dfa.nodes[i].toString(),
      color: color
    });
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
      },
      color: "#97C2FC"
    });
  }
  return edges;
}

export function drawDFA(dfa, elementId) {
  var container = document.getElementById(elementId);
  var data = {
    nodes: getNodes(dfa),
    edges: getEdges(dfa),
  };
  var options = {};
  var network = new vis.Network(container, data, options);
}
