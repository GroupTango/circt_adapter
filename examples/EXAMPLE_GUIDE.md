# Example Guide

Every example folder should follow the following naming convention for scripts to work correctly:

```
example
├── example.scala
├── example.fir
├── example.mlir
├── example-module-graph-N.png
├── example-instance-graph.png
├── example-module.json
└── example-instance.json
```

# Example Generation

## Generating Examples using Chisel

Chisel is a high-level hardware description language written in Scala. An online Chisel compiler can be found at [https://www.chisel-lang.org/docs/resources](), and comes with a bunch of nifty examples.

Alternatively, install it via the guide at [https://www.chisel-lang.org/docs/installation]().

The documentation for the Scala Chisel library can be found at [this link](https://javadoc.io/static/edu.berkeley.cs/chisel3_2.11/3.2.1/index.html#chisel3.Driver$).

Chisel compiles to the `firrtl` dialect. You can perform the compilation like so:

```scala
println(chisel3.Driver.emit(() => new ModuleName))
```

The results should be saved in a `.fir` file prefixed with the line `FIRRTL version 2.0.0` (this is the version the online compiler uses).

## Compiling `firrtl` to `hw`

We can use `firtool` to reduce the `firrtl` dialect down to `hw`. Run the following command:

```
firtool -format=fir --ir-hw foo/bar.fir -o foo/bar.mlir
```

## CIRCT Instance and Module Graphs

Recall that a "module" is a self-contained functional hardware unit (akin to a Verilog module), and an "instance" is a (usually named) instance of the module. For example, we might have two instances `m1`, `m2` of a `Mux2` module.

CIRCT comes with the `hw-print-instance-graph` and `hw-print-module-graph` passes pre-built, which generate instance dependency graphs, and module flow graphs respectively.

To run:

```
circt-opt --hw-print-instance-graph foo/bar.mlir -o /dev/null 2>&1 | dot -Tpng -o foo/bar-instance-graph.png
circt-opt --hw-print-module-graph foo/bar.mlir -o /dev/null 2>&1 | dot -Tpng -O
```

## Instance and Module JSONs