import { modelTextBox, viewModels } from "./selectors";

export const openModel = (models: string[]) => {
  const root = Cypress.config("projectRoot");

  cy.visit("http://localhost:8080");

  for (const model of models) {
    cy.get(modelTextBox).type(`${root}/${model}{enter}`);
  }

  cy.get(viewModels).click();
};

export const mod1 = "examples/one/one-module.json";
export const mod2 = "examples/two/two-module.json";
export const ins2 = "examples/two/two-instance.json";
export const modB1 = "examples/boom/boom-module.json";
export const modB2 = "examples/boom-smaller/boom-smaller-module.json";
export const insB2 = "examples/boom-smaller/boom-smaller-instance.json";
