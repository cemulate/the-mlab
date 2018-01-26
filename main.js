// Generated automatically by nearley
// http://github.com/Hardmath123/nearley
(function () {
function id(x) {return x[0]; }
var grammar = {
    Lexer: undefined,
    ParserRules: [
    {"name": "core$string$1", "symbols": [{"literal":"c"}, {"literal":"o"}, {"literal":"r"}, {"literal":"e"}], "postprocess": function joiner(d) {return d.join('');}},
    {"name": "core", "symbols": ["core$string$1"]},
    {"name": "doA$string$1", "symbols": [{"literal":"a"}, {"literal":" "}], "postprocess": function joiner(d) {return d.join('');}},
    {"name": "doA", "symbols": ["doA$string$1", "core"]},
    {"name": "MAIN$string$1", "symbols": [{"literal":"M"}, {"literal":"a"}, {"literal":"i"}, {"literal":"n"}, {"literal":":"}, {"literal":" "}], "postprocess": function joiner(d) {return d.join('');}},
    {"name": "MAIN", "symbols": ["MAIN$string$1", "doA"]}
]
  , ParserStart: "MAIN"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
