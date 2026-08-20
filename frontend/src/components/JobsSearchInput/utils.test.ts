import { describe, it, expect } from "vitest";

import {
  optionsToValuesConverter,
  CONTRACT_TYPE_VALUES,
  WORK_MODE_VALUES,
  STATUS_VALUES,
} from "./utils";

describe("optionsToValuesConverter", () => {
  it("prepends an 'All' option with an empty value", () => {
    expect(optionsToValuesConverter(["FULL_TIME"], CONTRACT_TYPE_VALUES)[0]).toEqual({
      label: "All",
      value: "",
    });
  });

  it("maps each value to a {label, value} pair using the given labels map", () => {
    expect(
      optionsToValuesConverter(["FULL_TIME", "PART_TIME"], CONTRACT_TYPE_VALUES),
    ).toEqual([
      { label: "All", value: "" },
      { label: "Full-Time", value: "FULL_TIME" },
      { label: "Part-Time", value: "PART_TIME" },
    ]);
  });

  it("maps work_mode values using WORK_MODE_VALUES", () => {
    expect(optionsToValuesConverter(["onsite", "remote"], WORK_MODE_VALUES)).toEqual([
      { label: "All", value: "" },
      { label: "On-site", value: "onsite" },
      { label: "Remote", value: "remote" },
    ]);
  });

  it("maps status values using STATUS_VALUES", () => {
    expect(optionsToValuesConverter(["draft", "published"], STATUS_VALUES)).toEqual([
      { label: "All", value: "" },
      { label: "Draft", value: "draft" },
      { label: "Published", value: "published" },
    ]);
  });

  it("preserves the order of the input values", () => {
    const result = optionsToValuesConverter(
      ["VIE", "FULL_TIME", "FREELANCE"],
      CONTRACT_TYPE_VALUES,
    );

    expect(result.map((option) => option.value)).toEqual([
      "",
      "VIE",
      "FULL_TIME",
      "FREELANCE",
    ]);
  });

  it("returns only the 'All' option for an empty values array", () => {
    expect(optionsToValuesConverter([])).toEqual([{ label: "All", value: "" }]);
  });

  it("returns an empty array when values is null or undefined", () => {
    expect(optionsToValuesConverter(null as unknown as string[])).toEqual([]);
    expect(optionsToValuesConverter(undefined as unknown as string[])).toEqual([]);
  });

  it("leaves the label undefined when no labels map is given for a value (e.g. office/location)", () => {
    expect(optionsToValuesConverter(["Paris", "Nantes"])).toEqual([
      { label: "All", value: "" },
      { label: undefined, value: "Paris" },
      { label: undefined, value: "Nantes" },
    ]);
  });
});
