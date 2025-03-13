# Cloning Correctly
Ensure you have cloned the 'main' branch of repository with --recursive, as to have our fork of circt.
If you have not cloned recursively please run `git submodule update --init --recursive` 

# Building CIRCT
To use the adapter, you will need to have a working build of our CIRCT fork.
To build CIRCT quickly, run the `get_started.sh` script, should it fail to build CIRCT,
follow the original build instructions to make your own build script: https://circt.llvm.org/docs/GettingStarted/

# Launching the adapter
To use the adapter you first need to setup the 'CIRCT_PATH' environment variable,
which needs to point to the 'circt-opt' executable, which should be found at `YOURCIRCTPATH/build/bin/circt-opt`.
Next you can run the `run_adapter.sh` script to launch the adapter.

# Using the adapter
In the Model Explorer GUI, you should be able to select MLIR files from your computer, once selected, click the adapter drop down and select either the Instance Graph or Operation Graph adapters,
they will generate the respective graphs for Model Explorer to render.
Depending on graph size, the 'Converting' stage of Model Explorer (which is when it is running our C++ backend) may take some time.
If Model Explorer is stuck on the 'Processing' stage for a long time, this means Model Explorer has failed to launch correctly (bug on their end),
and you need to restart the adapter and open the files again.
