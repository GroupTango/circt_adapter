#!/bin/bash
python3 -m venv venv
source $PWD/.venv/bin/activate
pip install -e .
model-explorer --extensions=circt_adapter