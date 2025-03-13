import { modelTextBox, viewModels } from "./selectors";

export enum Model {
  mod1 = "examples/one/one-module.json",
  mod2 = "examples/two/two-module.json",
  ins2 = "examples/two/two-instance.json",
  modB1 = "examples/boom/boom-module.json",
  modB2 = "examples/boom-smaller/boom-smaller-module.json",
  insB2 = "examples/boom-smaller/boom-smaller-instance.json",
}

export const openModel = (models: Model[]) => {
  const root = Cypress.config("projectRoot");

  cy.visit("http://localhost:8080");

  for (const model of models) {
    cy.get(modelTextBox).type(`${root}/${model}{enter}`);
  }

  cy.get(viewModels).click();
};

export const openModelFromRoot = (models: string[]) => {
  const root = Cypress.config("projectRoot");

  cy.visit("http://localhost:8080");

  for (const model of models) {
    cy.get(modelTextBox).type(`${root}/${model}{enter}`);
  }
  cy.get(viewModels).click();
}
