# main.py
import json
from typing import Dict
from model_explorer import *
from model_explorer.utils import convert_builtin_resp
from model_explorer.types import GraphCollection, ModelExplorerGraphs


class MyAdapter(Adapter):

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
    with open(model_path, mode='rb') as src_file:
      src_string = src_file.read()

    if model_path.endswith('.mlir'):
      src_string = ConvertCirctToJson(src_string)

    return {'graphCollections': ConvertJsonToGraphs(src_string)}


def ConvertCirctToJson(mlir_str: str) -> str:
  # Add C++ call here
  return ''


def ConvertJsonToGraphs(json_str: str):
  style_dict = {"hw":{"backgroundColor":"cyan"}, "I/O":{"backgroundColor":"yellow"}, "comb":{"backgroundColor":"red"}, "instance":{"backgroundColor":"lime"}, "seq":{"backgroundColor":"orange"}}  
  def hasNodeDialect(node):
    return (("attrs" in node) and (len(node["attrs"]) > 0) and (node["attrs"][-1]["value"]) in style_dict)
  
  resp = json.loads(json_str)
  for i in range(len(resp)):
    for j in range(len(resp[i]['subgraphs'])):
      for k in range(len(resp[i]['subgraphs'][j]["nodes"])):
        if hasNodeDialect(resp[i]['subgraphs'][j]["nodes"][k]):
          resp[i]['subgraphs'][j]["nodes"][k]["style"] = style_dict[resp[i]['subgraphs'][j]["nodes"][k]["attrs"][-1]["value"]]
  graph_out = [GraphCollection(label=item['label'], graphs=item['subgraphs']) for item in resp]
  return graph_out
  

def CloneModule(src_node: graph_builder.GraphNode) -> graph_builder.GraphNode:
  return None
