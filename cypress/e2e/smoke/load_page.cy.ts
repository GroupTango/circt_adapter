it("conencts to page", () => {
  const path =
    Cypress.config("projectRoot") + "/examples/one/one-module.json{enter}";
  cy.visit("http://localhost:8080");
  cy.get(".mat-mdc-autocomplete-trigger").type(path);
  cy.get(".btn-view-models").click();
});
