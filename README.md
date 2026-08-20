# Technical Test for Frontend Developer - Application Tracking System

Welcome to the Frontend Developer Job Application Tracking System!

This application is a simplified job board.
An unregistered user is able to list all jobs and can apply to a job.
It provides a platform to manage job offers and track candidate information.

A registered user can create, edit, and delete job offers.
On each job offer, a registered user can see the list of candidates who have applied to the job.

## Repository Structure

This is a monorepo containing both frontend and backend:

- **Frontend (`/frontend`):** React 19 application with TypeScript
- **Backend (root):** Phoenix/Elixir REST API

## Installation

1. Clone the repository
2. Navigate to the project directory: `cd technical-test-fullstack`
3. Install language versions and dependencies:

   We suggest you use asdf (or another version manager) to manage Erlang, Elixir and Node versions.

   To install asdf, visit <http://asdf-vm.com/guide/getting-started.html>.

   Add the required plugins:

   ```bash
   asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
   asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
   asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
   ```

   Then install the versions specified in the `.tool-versions` file:

   ```bash
   asdf install
   ```

   You can now install the Elixir dependencies:

   ```bash
   mix deps.get
   ```

4. Set up the database and update the configuration in `config/dev.exs` or start a Docker container with the `docker-compose.yml` file included in the project.
5. Create and migrate the database: `mix ecto.setup`
6. Run the tests: `mix test`
7. Start the Phoenix server: `mix phx.server`
8. Frontend Setup:

   ```bash
   cd frontend
   corepack enable
   yarn install
   yarn dev  # Starts on http://localhost:5173
   ```

## Exercise

We are glad to introduce you to this technical test which will help us better understand your skills and competencies related to our tech stack. In this exercise, we will use our in-house built Applicant Tracking System (ATS) application developed with React and Phoenix Elixir.

The goal of this test is to simulate a real-world scenario where you will need to add a new feature to an existing application.
Your work will be evaluated based on your approach, your understanding of the problem and the quality of your code.

You need to implement a **Job search function** !

That new feature must allow all users to search for jobs. This should allow users to search using various parameters like job title, location, work mode, etc. You can extend this requirement to anything that makes sense for this project. You will have to implement the backend functionality (vibe coding only is ok!).

## Evaluation Criteria

**Frontend**

- React best practices and component architecture
- Proper use of hooks and state management
- Code organization and reusability
- UI/UX quality with welcome-ui
- Testing quality and coverage
- TypeScript usage and type safety
- Search functionality is done on the backend (vibe-code)

**Overall**

- Git commit history and messages
- Code documentation and comments
- Problem-solving approach
- Attention to requirements

## Job Search Feature — Implementation Notes

This section documents the search feature added to satisfy the exercise: searching jobs by title, contract type, work mode, location, and status. The backend exposes `GET /api/jobs` with optional query params (`title`, `contract_type`, `work_mode`, `office`, `status`) and `GET /api/jobs/filters` to fetch the current valid values for each filter. The frontend `JobsSearchInput` component (`frontend/src/components/JobsSearchInput/`) renders a debounced title input plus one select per filter, and calls `onSearch` with the current filter state.

### Choices

- **Selects with static filter fields, dynamic values.** Contract type, work mode, location, and status are all discrete, low-cardinality fields, so selects are a better fit than free text — they prevent typos/invalid queries from ever reaching the API and give users a clear picture of what's actually searchable. The set of *fields* to filter on is fixed in the UI, but the *values* offered in each select (except title) come from `GET /api/jobs/filters`, so contract types, work modes, statuses, and locations reflect what's actually in the database rather than a value hardcoded on the frontend.
- **Title is a free-text input.** Job titles are open-ended text, so a search box with partial, case-insensitive matching (backend `ILIKE %term%`) fits better than a fixed list.

### Improvements (given more time)

- **Fully dynamic filters.** Right now the human-readable *labels* for contract type, work mode, and status (e.g. `FULL_TIME` → "Full-Time") are hardcoded on the frontend (`utils.ts`), while only the underlying values come from the backend. A cleaner approach would have the `/api/jobs/filters` endpoint return `{value, label}` pairs directly, so the frontend never needs to know about enum values at all — new statuses or contract types added on the backend would show up correctly with zero frontend changes.
- **A `Filter` sub-component.** Each select in `JobsSearchInput` is currently wrapped by hand in a `<div><span>Label</span><Select /></div>`. Extracting a small `Filter` component (label + control) would remove that repetition and give a single place to handle label styling, spacing, and accessibility (e.g. properly associating the label with the select).
- **Search across description too.** Title-only search misses jobs whose title doesn't contain the search term but whose description does. Extending the backend query to also match `description` (`OR ilike(description, ...)`) would surface more relevant results for free-text queries.

### LLM Usage

Claude code was used to:
- Implement full backend logic for the search part
- Add the types used in JobsSearchInput
- Add the logic to request the jobs search in JobList to (handleSearch function) and the full searchJobs function
- Parts of the README
- Tests implementation (test optionsToValuesConverter function and e2e tests for JobsSearchInputs component)

## Notes

- Take your time and demonstrate your abilities
- Focus on code quality over quantity
- Don't hesitate to update the readme to explain your decisions and what you would have done if given more time
- Be transparent on LLM usage!
- If you run out of time, prioritize completing the required task over improving it
- You can add additional libraries if needed, but justify your choices

Happy coding and good luck!
