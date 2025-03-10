# main.py
import os
import subprocess
import json
from typing import Dict
from model_explorer import *
from model_explorer.types import GraphCollection, ModelExplorerGraphs

class CirctAdapter(Adapter):

  metadata = AdapterMetadata(
      id='circt_adapter',
      name='CIRCT Adapter',
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
      src_string = ConvertCirctToJson(model_path)    
    elif model_path.endswith('.json'): 
      with open(model_path, mode='rb') as src_file:
        src_string = src_file.read()

    return {'graphCollections': ConvertJsonToGraphs(src_string)}


def ConvertCirctToJson(model_path: str) -> str:
  circt_path = os.environ.get('CIRCT_PATH','circt-opt')
  result = subprocess.run([circt_path, '--hw-print-module-json',model_path,'-o', '/dev/null'], stderr=subprocess.PIPE).stderr.decode('utf-8')
  result = result[result.find("JSON:")+5:]
  return result


def ConvertJsonToGraphs(json_str: str):
  file_path = os.path.join(os.path.dirname(__file__), 'nodeColours.json')
  style_dict = {}
  resp = json.loads(json_str)

  try:
    with open(file_path, mode='rb') as style_file:
      style_string = style_file.read()
    style_dict = json.loads(style_string)
  except FileNotFoundError:
    return [
        GraphCollection(label=item['label'], graphs=item['subgraphs'])
        for item in resp
    ]

  for i, ni in enumerate(resp):
    for j, nj in enumerate(ni['subgraphs']):
      for k, nk in enumerate(nj['nodes']):
        if 'attrs' in nk:
          for l, nl in enumerate(nk['attrs']):
            if (nl['key'] == 'type') and (nl['value'] in style_dict):
              nk['style'] = style_dict[nl['value']]

  return [
      GraphCollection(label=item['label'], graphs=item['subgraphs'])
      for item in resp
  ]


def CloneModule(src_node: graph_builder.GraphNode) -> graph_builder.GraphNode:
  return None
