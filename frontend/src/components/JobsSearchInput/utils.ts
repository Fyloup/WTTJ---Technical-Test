
export const CONTRACT_TYPE_VALUES: Record<string, string> = {
  FULL_TIME: "Full-Time",
  PART_TIME: "Part-Time",
  TEMPORARY: "Temporary",
  FREELANCE: "Freelance",
  INTERNSHIP: "Internship",
  APPRENTICESHIP: "Apprenticeship",
  VIE: "VIE",
};

export const WORK_MODE_VALUES: Record<string, string> = {
  onsite: "On-site",
  remote: "Remote",
  hybrid: "Hybrid",
};

export const STATUS_VALUES: Record<string, string> = {
  draft: "Draft",
  published: "Published",
  filled: "Filled",
  archived: "Archived",
  cancelled: "Cancelled",
};

export function optionsToValuesConverter(values: string[], labels: Record<string, string> = {}) {

    if (!values)
        return []

    return ([
        {label: "All", value: ""},
        ...values.map((value) => ({label: labels[value], value: value}))
    ])
}
