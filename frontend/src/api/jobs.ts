import { Job, JobFilterOptions, JobSearchParams } from "../types";

export const searchJobs = async (
  params: JobSearchParams = {},
): Promise<Job[]> => {
  const query = new URLSearchParams();

  Object.entries(params).forEach(([key, value]) => {
    if (value) query.set(key, value);
  });

  const queryString = query.toString();
  const res = await fetch(`/api/jobs${queryString ? `?${queryString}` : ""}`);

  if (!res.ok) {
    throw new Error("Failed to fetch jobs");
  }

  const body: { data: Job[] } = await res.json();
  return body.data;
};

export const getJobFilterOptions = async (): Promise<JobFilterOptions> => {
  const res = await fetch("/api/jobs/filters");

  if (!res.ok) {
    throw new Error("Failed to fetch job filters");
  }

  const body: { data: JobFilterOptions } = await res.json();
  return body.data;
};
