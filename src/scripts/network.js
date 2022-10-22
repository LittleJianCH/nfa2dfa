import * as vis from "vis-network/standalone";

var nodes = new vis.DataSet([
  { id: 1, label: "NFA" },
  { id: 2, label: "DFA" },
]);

var edges = new vis.DataSet([
  {
    from: 1,
    to: 2,
    arrows: {
      to: {
        enabled: true,
        type: "arrow",
      },
    },
  },
]);

var container = document.getElementById("network");
var data = {
  nodes: nodes,
  edges: edges,
};
var options = {};
var network = new vis.Network(container, data, options);
