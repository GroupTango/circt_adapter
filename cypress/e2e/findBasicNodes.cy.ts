import { searchSelect, verifyInfoPanel } from "../utils/node";
import { mod1, openModel } from "../utils/openModel";

describe("Explore a basic graph", () => {
  it("Finds top level node", () => {
    openModel([mod1]);
    searchSelect("PassthroughGenerator");
    verifyInfoPanel({
      layerInfo: {
        name: "PassthroughGenerator",
        namespace: "<root>",
      },
    });
  });

  it("Finds output node", () => {
    openModel([mod1]);
    searchSelect("hw.output");
    verifyInfoPanel({
      nodeInfo: {
        "op name": "hw.output",
        namespace: "PassthroughGenerator",
      },
    });
  });
});
