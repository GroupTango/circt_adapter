#!/bin/bash
python3 -m venv venv
source $PWD/.venv/bin/activate
pip install -e .
model-explorer --extensions=module_circt_adapter, instance_circt_adapter
