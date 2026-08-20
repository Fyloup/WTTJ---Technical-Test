// Type definitions for the ATS frontend

export interface Job {
  id: number;
  title: string;
  description: string;
  contract_type: string;
  office: string;
  status: string;
  work_mode: string;
  profession_id: number;
  inserted_at: string;
  updated_at: string;
}

export interface ApiResponse<T> {
  data: T;
}

export interface JobsApiResponse {
  data: Job[];
}

export interface JobSearchParams {
  title?: string;
  contract_type?: string;
  work_mode?: string;
  office?: string;
  status?: string;
}

export interface JobFilterOptions {
  contract_types: string[];
  work_modes: string[];
  statuses: string[];
  offices: string[];
}

export interface Applicant {
  id: number;
  application_date: string;
  status: string;
  salary_expectation: number;
  candidate: Candidate;
}

export interface Candidate {
  id: number;
  full_name: string;
  email: string;
  phone: string;
  last_known_job: string;
}
