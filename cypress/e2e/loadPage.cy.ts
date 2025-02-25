import { openModel, mod1, mod2, modB2, insB2 } from "../utils/openModel";

describe("Page connection", () => {
  it("conencts to one", () => openModel([mod1]));
  it("conencts to two", () => openModel([mod2]));
  it("conencts to boom smaller graph", () => openModel([modB2, insB2]));
});
