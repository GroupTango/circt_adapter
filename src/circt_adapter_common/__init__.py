import os
import subprocess
import json
from model_explorer.types import GraphCollection

__all__ = ["ConvertCirctToJson", "ConvertJsonToGraphs"]

def ConvertCirctToJson(model_path: str, command : str) -> str:
  circt_path = os.environ.get('CIRCT_PATH', 'circt-opt')
  subprocess.run([
      circt_path,
      command,
      model_path,
      '--outfile',
      'out.json',
  ])
  with open('out.json', mode='rb') as src_file:
    result = src_file.read()
  return result.decode()


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
