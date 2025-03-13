import { searchByLabel, searchSelect, verifyInfoPanel } from "../utils/node";
import { Model, openModel } from "../utils/openModel";

describe("Explore a basic graph", () => {
  beforeEach(() => {
    openModel([Model.mod1]);
  });

  it("Finds top level node", () => {
    searchByLabel("PassthroughGenerator");
    verifyInfoPanel({
      layerInfo: {
        name: "PassthroughGenerator",
        namespace: "<root>",
      },
    });
  });

  it("Finds output node", () => {
    searchByLabel("io_out");
    verifyInfoPanel({
      nodeInfo: {
        "op name": "io_out",
        namespace: "PassthroughGenerator",
      },
    });
  });
});
