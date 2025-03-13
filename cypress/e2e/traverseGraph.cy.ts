import { searchNext, searchSelect, verifyInfoPanel } from "../utils/node";
import { Model, openModel, openModelFromRoot } from "../utils/openModel";
import { getAttributeKeyLabel, getAttributeValueLabel, modelTextBox, singularAttributeKey, singularAttributeValue } from "../utils/selectors";

// test doesn't run in CLI ("GPU stall due to readpixels")
// give filepath arguments in cypress environment (relative from project root)

describe("Check membership of all graph nodes", () => {
  const filepaths = Cypress.env("filepaths");
  filepaths.forEach((filepath) => {
    it(`Correctly loads file ${filepath}`, () => {
      cy.fixture("../../"+filepath).then((jsonData) => {
        const subgraphs = jsonData[0].subgraphs

        openModelFromRoot([filepath]);
        let seen = new Set();

        // for input checking, need mapping from id : label
        let labels: {[id: string]: string} = {};
        subgraphs.forEach((sub) => {
          const subgraph = sub.nodes;
          subgraph.forEach((node) => {
            labels[node.id] = node.label;
          })
        })

        subgraphs.forEach((sub) => {
          const subgraph = sub.nodes;
          for (let i = 0; i < subgraph.length; i++) {
            let currentNode = subgraph[i];
            //cy.log(currentNode);
            if (seen.has(currentNode.id)) {} else { // this check is pointless, but the test page was hanging before I added it
              describe(`Correctly loads node ${currentNode.id} of json file ${filepath}`, () => {
                seen.add(currentNode.id);
                let label = currentNode.label;
                let id = currentNode.id;
  
                label = label.replace(/[-[\]{}()*+?.,\\^$|]/g, "\\$&") // escape all special characters, because the modelexp search takes regex
    
                if (i == 0) {
                  searchSelect(id, currentNode.label);
                } else {
                  searchNext(id, currentNode.label);
                }
      
                // input checking
                // for each each (i, edge):
                // search (n-i) child for text of label[edge]
                if (currentNode.hasOwnProperty("incomingEdges")) {
                  const edgeCount = currentNode.incomingEdges.length;
                  if (edgeCount == 1) {
                    cy.get(`.name-row .name`).contains(labels[currentNode.incomingEdges[0].sourceNodeId])
                  } else {
                    for (i = 0; i < edgeCount; i++) {
                      cy.get(`:nth-child(${i+1}) > .name-row .name`).contains(labels[currentNode.incomingEdges[i].sourceNodeId]);
                      cy.wait(200);
                    }
                  }
                }

                if (currentNode.hasOwnProperty("attrs") && currentNode.attrs.length > 0) {
                  let toVerify = {};
                  currentNode.attrs.forEach((attr) => {
                    toVerify[attr.key] = attr.value;
                  })
                  verifyInfoPanel({
                    attrs: toVerify
                  });
                }

                /*
                if (currentNode.hasOwnProperty("attrs")) {
                  let attrs = currentNode.attrs;
                  const attrCount = attrs.length;
                  if (attrCount == 1) {
                    cy.get(singularAttributeKey).contains(attrs[0].key);
                    cy.wait(200);
                    cy.get(singularAttributeValue).contains(attrs[0].value);
                    cy.wait(200);
                  } else {
                    for (i = 0; i < attrCount; i++) {
                      cy.get(getAttributeKeyLabel(i+1)).contains(attrs[i].key);
                      cy.wait(200);
                      cy.get(getAttributeValueLabel(i+1)).contains(attrs[i].value);
                      cy.wait(200);
                    }
                  }
                }
                */
              })
            }
          }
        })
      })
    })
  })
})