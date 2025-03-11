# main.py
import os
import subprocess
import json
from typing import Dict
from model_explorer import Adapter, AdapterMetadata
from model_explorer.types import GraphCollection, ModelExplorerGraphs
from cirt_adapter_common import ConvertCirctToJson, ConvertJsonToGraphs

class ModuleCirctAdapter(Adapter):
  metadata = AdapterMetadata(
      id='module_circt_adapter',
      name='Module CIRCT Adapter',
      description=(
          'Model Explorer Adapter for CIRCT generated JSON and MLIR files.'
      ),
      source_repo='https://github.com/GroupTango/circt-adapter/tree/main',
      fileExts=['mlir', 'json'],
  )

  # Required.
  def __init__(self):
    super().__init__()

  def convert(self, model_path: str, settings: Dict) -> ModelExplorerGraphs:
    src_string = ''
    if model_path.endswith('.mlir'):
      src_string = ConvertCirctToJson(model_path,  "--hw-print-module-json")
    elif model_path.endswith('.json'):
      with open(model_path, mode='rb') as src_file:
        src_string = src_file.read()

    return {'graphCollections': ConvertJsonToGraphs(src_string)}

