import { openModel, Model } from "../utils/openModel";

describe("Page connection", () => {
  it("conencts to one", () => openModel([Model.mod1]));
  it("conencts to two", () => openModel([Model.mod2]));
  it("conencts to boom smaller graph", () =>
    openModel([Model.modB2, Model.insB2]));
});
