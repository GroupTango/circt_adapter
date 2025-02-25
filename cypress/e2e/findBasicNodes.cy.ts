import { searchSelect, verifyInfoPanel } from "../utils/node";
import { Model, openModel } from "../utils/openModel";

describe("Explore a basic graph", () => {
  beforeEach(() => {
    openModel([Model.mod1]);
  });

  it("Finds top level node", () => {
    searchSelect("PassthroughGenerator");
    verifyInfoPanel({
      layerInfo: {
        name: "PassthroughGenerator",
        namespace: "<root>",
      },
    });
  });

  it("Finds output node", () => {
    searchSelect("hw.output");
    verifyInfoPanel({
      nodeInfo: {
        "op name": "hw.output",
        namespace: "PassthroughGenerator",
      },
    });
  });
});
