import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

import { JobsSearchInput } from "./JobsSearchInput";

describe("JobsSearchInput", () => {
  it("renders the title input and all four filter selects", () => {
    render(<JobsSearchInput onSearch={vi.fn()} />);

    expect(screen.getByPlaceholderText(/search by job title/i)).toBeVisible();

    expect(screen.getByPlaceholderText("Contract type")).toBeVisible();
    expect(screen.getByPlaceholderText("Work mode")).toBeVisible();
    expect(screen.getByPlaceholderText("Location")).toBeVisible();
    expect(screen.getByPlaceholderText("Status")).toBeVisible();
  });

  it("renders exactly 4 selects, one per filter", () => {
    render(<JobsSearchInput onSearch={vi.fn()} />);

    expect(screen.getAllByRole("combobox")).toHaveLength(4);
  });

  it("still renders the selects when no filterOptions are provided yet", () => {
    render(<JobsSearchInput onSearch={vi.fn()} filterOptions={undefined} />);

    expect(screen.getAllByRole("combobox")).toHaveLength(4);
  });

  it("renders selects populated from filterOptions", () => {
    render(
      <JobsSearchInput
        onSearch={vi.fn()}
        filterOptions={{
          contract_types: ["FULL_TIME"],
          work_modes: ["remote"],
          statuses: ["published"],
          offices: ["Paris"],
        }}
      />,
    );

    expect(screen.getAllByRole("combobox")).toHaveLength(4);
  });
});
