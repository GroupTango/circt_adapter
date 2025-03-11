export const searchInput = ".input-container > .ng-untouched";
export const searchInputUsed = ".input-container > .ng-dirty";
export const closeSearchResults = ".input-container .btn-clear-container";
export const modelTextBox = ".mat-mdc-autocomplete-trigger";
export const viewModels = ".btn-view-models";
export const searchResults = ".edge-node > .label-and-metadata > .label-container > .label";
export const canvas = "webgl-renderer > .container > .main";
export const infoPanel = "info-panel";
export const Attrs = ".options-container > :nth-child(2)";
export const Inputs = ".options-container > :nth-child(3)";
export const Outputs = ".options-container > :nth-child(4)";
export const infoPanelSegements = {
  nodeInfo: "Node info",
  layerInfo: "Layer info",
  attrs: "Attributes",
};

export type InfoPanelSegment = keyof typeof infoPanelSegements;
