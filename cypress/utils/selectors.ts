export const searchInput = ".input-container > .ng-untouched";
export const searchInputUsed = ".input-container > .ng-dirty";
export const closeSearchResults = ".input-container .btn-clear-container";
export const modelTextBox = ".mat-mdc-autocomplete-trigger";
export const viewModels = ".btn-view-models";
export const searchResults = ".label-container > .label";
export const canvas = "webgl-renderer > .container > .main";
export const infoPanel = "info-panel";
export const label = ".options-container > :nth-child(1)";
export const attrs = ".options-container > :nth-child(2)";
export const inputs = ".options-container > :nth-child(3)";
export const outputs = ".options-container > :nth-child(4)";
export const infoPanelSegements = {
  nodeInfo: "Node info",
  layerInfo: "Layer info",
  attrs: "Attributes",
};
export const singularAttributeKey =  ".metadata-table > tr.ng-star-inserted > .key > hoverable-label > .bubble";
export const singularAttributeValue = ".metadata-table > tr.ng-star-inserted > .value > expandable-info-text > .container > .one-line-text"

export type InfoPanelSegment = keyof typeof infoPanelSegements;

export const getAttributeValueLabel = (attributeNumber: number) => {
  return `.metadata-table > :nth-child(${attributeNumber}) > .value > expandable-info-text > .container > .one-line-text`;
}

export const getAttributeKeyLabel = (attributeNumber: number) => {
  return `.metadata-table > :nth-child(${attributeNumber}) > .key > hoverable-label > .bubble`
}