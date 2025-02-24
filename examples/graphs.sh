#!/bin/bash

# Generates the Graphviz plots for the specified file
# ./graphs [folder-name]
./../circt/build/bin/circt-opt --hw-print-module-graph "$1/$1.mlir" -o /dev/null 2>&1 | awk '/^digraph/{f="graph"++c".dot"} {print > f}';
c=1; for file in ./*.dot; do dot -Tpng $file -o "$1/$1-module-graph-$c.png"; ((c++)); rm $file; done

./../circt/build/bin/circt-opt --hw-print-instance-graph "$1/$1.mlir" -o /dev/null 2>&1 | dot -Tpng -o "$1/$1-instance-graph.png";