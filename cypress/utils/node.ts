import {
  Attrs,
  canvas,
  closeSearchResults,
  infoPanel,
  infoPanelSegements,
  InfoPanelSegment,
  Inputs,
  Outputs,
  searchInput,
  searchInputUsed,
  searchResults,
} from "./selectors";

export const search = (search: string, select = search) => {
  cy.get(searchInput).type(search);
  cy.get(Attrs).click();
  cy.get(Inputs).click();
  cy.get(Outputs).click();
  cy.get(searchResults).contains(select).click();
};

export const searchSelect = (s: string, select = s) => {
  search(s, select);
  cy.get(closeSearchResults).click();
  cy.wait(200);
  cy.get(canvas).click();
};

// ".ng-untouched" selector used in search doesn't work on subsequent searches
export const searchNext = (s: string, select = s) => {
  cy.get(searchInputUsed).eq(1).type(s);
  cy.get(searchResults).contains(select).click(); // TBA: change to exact match
  cy.get(closeSearchResults).click();
  cy.wait(200);
  cy.get(canvas).click();
}

export const getInfoPanelSegment = (segment: InfoPanelSegment) =>
  cy.get(infoPanel).contains(infoPanelSegements[segment]).parent();

export const getInfoPanelSubfield = (sel: string, field: string) =>
  cy
    .get(sel)
    .find("table")
    .children("tr")
    .filter((_, el) => Cypress.$(el).find(".key div").text().trim() === field);

export const verifyInfoPanel = (ass: {
  [key in InfoPanelSegment]?: Record<string, string>;
}) => {
  for (const k in ass) {
    const segName = k as InfoPanelSegment;
    getInfoPanelSegment(segName).as("seg");
    for (const k in ass[segName])
      getInfoPanelSubfield("@seg", k).should("contain.text", ass[segName][k]);
  }
};
