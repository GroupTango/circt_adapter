# Visual Analytics for Hardware Design

This project connects the open-source CIRCT (circt.llvm.org) EDA stack with the [Google Model Explorer](https://github.com/google-ai-edge/model-explorer) and augments the product with CIRCT-specific interactive analyses, as well as bi-directional analysis-transformations that allow to visualise and influence the compilation process.

The project includes a [fork of CIRCT](https://github.com/GroupTango/circt) that includes the necessary changes to enable the integration with the Model Explorer.

## Installation

We have a quick-start script `./get_started.sh` which installs the necessary dependencies and builds the project.

Ensure you have `git clone`d the `main` branch of our repository with `--recursive`, as to have our fork of circt.
If you have not cloned recursively please run `git submodule update --init --recursive`. 

The project file structure is as follows:

```
.
├── circt/       (CIRCT fork)
│   ├── build/       (cmake build directory)
│   ├── lib/
│   │   └── Dialect/
│   │       └── HW/      (C++ header files and Passes.td)
│   ├── include/
│   │   └── circt/
│   │       └── Dialect/
│   │           └── HW/  (C++ source code for CIRCT passes)
│   └── llvm/            (submodule)
│       └── llvm/        (cmake source directory)
├── cypress/         (Model Explorer tests)
├── examples/        (example mlir files, as well as their generated JSON output)
└── src/             (Python code for Model Explorer adapter)
```

### C++ Development

We develop using the `gcc/g++ 11.4.0` compilers and the `c++17` standard. 

To reduce IntelliSense parsing time on IDEs, restrict your `includePath` to the following folders. VSCode users can add this to their `c_cpp_properties.json` file:

```json
{
    "includePath": [
        "${workspaceFolder}/circt/include/**",
        "${workspaceFolder}/circt/llvm/llvm/include/**",
        "${workspaceFolder}/circt/llvm/mlir/include/**",
        "${workspaceFolder}/circt/build/tools/circt/include/**",
        "${workspaceFolder}/circt/build/tools/mlir/include/**"
    ],
    "defines": [],
    "cStandard": "c17",
    "cppStandard": "c++17",
    "intelliSenseMode": "${default}"
}
```

We use the `Ninja` generator for `cmake`. Install both `Ninja` and `cmake` before doing anything else. 

The following commands should be run from the build directory.

Build the project with the following `cmake` variables:

```
cmake -G Ninja ../llvm/llvm \
    -DCMAKE_BUILD_TYPE=DEBUG \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_EXTERNAL_PROJECTS=circt \
    -DLLVM_EXTERNAL_CIRCT_SOURCE_DIR=.. \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DLLVM_TARGETS_TO_BUILD="" \
    -DLLVM_ENABLE_LLD=ON \
    -DLLVM_CCACHE_BUILD=ON \
    -DLLVM_BUILD_SHARED_LIBS=ON \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DCIRCT_BINDINGS_PYTHON_ENABLED=ON \
    -DPython_EXECUTABLE="/usr/bin/python3.12" \
    -DPython_INCLUDE_DIRS="/usr/include/python3.12"
```

Install the build with the following command:

```
ninja -j 4
```

Run the following tests to validate correct installation:

```
ninja check-mlir
ninja check-circt
ninja check-circt-integration
```

If using the VSCode `cmake` extension, add the following to your `.vscode/settings.json`:

```json
{
    "C_Cpp.default.compilerPath": "/usr/bin/g++",
    "cmake.sourceDirectory": "${workspaceFolder}/circt/llvm/llvm",
    "cmake.buildDirectory": "${workspaceFolder}/circt/build",
    "cmake.generator": "Ninja",
    "cmake.configureOnOpen": false,
    "cmake.configureSettings": {
        "CMAKE_BUILD_TYPE": "Debug",
        "LLVM_ENABLE_PROJECTS": "mlir",
        "LLVM_EXTERNAL_PROJECTS": "circt",
        "LLVM_EXTERNAL_CIRCT_SOURCE_DIR": "${workspaceFolder}/circt",
        "LLVM_ENABLE_ASSERTIONS": "ON",
        "CMAKE_EXPORT_COMPILE_COMMANDS": "ON",
        "LLVM_TARGETS_TO_BUILD": "",
        "LLVM_CCACHE_BUILD": "ON",
        "LLVM_BUILD_SHARED_LIBS": "ON",
        "MLIR_ENABLE_BINDINGS_PYTHON": "ON",
        "CIRCT_BINDINGS_PYTHON_ENABLED": "ON",
        "Python_EXECUTABLE": "/usr/bin/python3.12",
        "Python_INCLUDE_DIRS": "/usr/include/python3.12"
    },
    "cmake.buildToolArgs": ["-j", "4"],
}
```


### Python Development

We use the `uv` package manager for Python. All `pip` commands should be prefixed with `uv`: for example, `uv pip install -e`.

We do not use the CIRCT Python bindings in our Model Explorer adapter code. However, if future development so requires, ensure that the following is added to your `PYTHONPATH`:

```
export PYTHONPATH="$PWD/tools/circt/python_packages/circt_core"
```

This is required to `import circt` successfully.

### Cypress Development

We use the `yarn` NodeJS package manager. It suffices to install Typescript and Cypress.

## Usage


See `./run_adapter.sh` for an example of how to start the Model Explorer server with the CIRCT adapter and load a sample MLIR file. If you already have the virtual environment set up and dependencies installed, then it suffices to execute

```
model-explorer --extensions=module_circt_adapter,instance_circt_adapter
```

### Step-by-Step Usage

Our CIRCT passes may be run using the `circt-opt` command. Firstly, add the following line to your `~/.bashrc` (or any local terminal configuration file) so that your terminal can access the command:
```
export PATH=~/path/to/project/circt/build/bin:$PATH
```

Now, execute the following commands from the resident directory of your `file.mlir`:

```
circt-opt --hw-print-module-json "file.mlir" -o /dev/null --outfile "file-module.json";
circt-opt --hw-print-instance-json "file.mlir" -o /dev/null --outfile "file-instance.json";
```

Two JSON files will be generated.

Next, start the Model Explorer server, then from the GUI select and load in your JSON files, choosing the appropriate adapter where necessary.

### Example Folder

We have a folder of `examples/` containing sample `.mlir` codefiles, their JSON output from running our passes, as well as the DOT graphs generated from the existing passes (converted into PNG format). Refer to [EXAMPLE_GUIDE.md](./EXAMPLE_GUIDE.md) to see how the examples were generated, as well as how to run the passes on them.