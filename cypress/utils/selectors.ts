export const searchInput = ".input-container > .ng-untouched";
export const closeSearchResults = ".input-container .btn-clear-container";
export const modelTextBox = ".mat-mdc-autocomplete-trigger";
export const viewModels = ".btn-view-models";
export const searchResults = ".search-results-container .mat-tree";
export const canvas = "webgl-renderer > .container > .main";
export const infoPanel = "info-panel";
export const infoPanelSegements = {
  nodeInfo: "Node info",
  layerInfo: "Layer info",
  attrs: "Attributes",
};

export type InfoPanelSegment = keyof typeof infoPanelSegements;
