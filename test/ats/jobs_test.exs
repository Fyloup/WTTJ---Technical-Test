defmodule Ats.JobsTest do
  use Ats.DataCase

  alias Ats.Jobs

  describe "jobs" do
    alias Ats.Jobs.Job

    import Ats.JobsFixtures

    @invalid_attrs %{
      contract_type: nil,
      description: nil,
      office: nil,
      status: nil,
      title: nil
    }

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Jobs.list_jobs() |> Enum.map(& &1.id) == [job.id]
    end

    test "list_jobs/1 filters by title, case-insensitive partial match" do
      match = job_fixture(%{title: "Senior Backend Engineer"})
      _other = job_fixture(%{title: "Frontend Developer"})

      assert Jobs.list_jobs(%{"title" => "backend"}) |> Enum.map(& &1.id) == [match.id]
    end

    test "list_jobs/1 filters by office, case-insensitive exact match" do
      match = job_fixture(%{office: "Nantes"})
      _other = job_fixture(%{office: "Paris"})

      assert Jobs.list_jobs(%{"office" => "nantes"}) |> Enum.map(& &1.id) == [match.id]
    end

    test "list_jobs/1 filters by contract_type" do
      match = job_fixture(%{contract_type: "PART_TIME"})
      _other = job_fixture(%{contract_type: "FULL_TIME"})

      assert Jobs.list_jobs(%{"contract_type" => "PART_TIME"}) |> Enum.map(& &1.id) == [
               match.id
             ]
    end

    test "list_jobs/1 filters by work_mode" do
      match = job_fixture(%{work_mode: "remote"})
      _other = job_fixture(%{work_mode: "onsite"})

      assert Jobs.list_jobs(%{"work_mode" => "remote"}) |> Enum.map(& &1.id) == [match.id]
    end

    test "list_jobs/1 filters by status" do
      match = job_fixture(%{status: "published"})
      _other = job_fixture(%{status: "draft"})

      assert Jobs.list_jobs(%{"status" => "published"}) |> Enum.map(& &1.id) == [match.id]
    end

    test "list_jobs/1 combines multiple filters" do
      match = job_fixture(%{title: "Backend Engineer", office: "Paris", work_mode: "remote"})
      _wrong_office = job_fixture(%{title: "Backend Engineer", office: "Nantes"})
      _wrong_title = job_fixture(%{title: "Frontend Engineer", office: "Paris"})

      assert Jobs.list_jobs(%{"title" => "backend", "office" => "Paris"})
             |> Enum.map(& &1.id) == [match.id]
    end

    test "list_jobs/1 ignores blank and invalid filter values" do
      job = job_fixture()

      assert Jobs.list_jobs(%{"title" => "", "contract_type" => "NOT_A_TYPE"})
             |> Enum.map(& &1.id) == [job.id]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Jobs.get_job!(job.id).id == job.id
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{
        contract_type: "FULL_TIME",
        description: "Elixir dev backend",
        office: "Paris",
        status: "draft",
        title: "Dev Backend",
        work_mode: "onsite"
      }

      assert {:ok, %Job{} = job} = Jobs.create_job(valid_attrs)
      assert job.contract_type == :FULL_TIME
      assert job.description == "Elixir dev backend"
      assert job.office == "Paris"
      assert job.status == :draft
      assert job.title == "Dev Backend"
      assert job.work_mode == :onsite
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()

      update_attrs = %{
        contract_type: "PART_TIME",
        description: "Elixir dev backend senior",
        office: "Barcelone",
        status: "published",
        title: "Dev Backend",
        work_mode: "hybrid"
      }

      assert {:ok, %Job{} = job} = Jobs.update_job(job, update_attrs)
      assert job.contract_type == :PART_TIME
      assert job.description == "Elixir dev backend senior"
      assert job.office == "Barcelone"
      assert job.status == :published
      assert job.title == "Dev Backend"
      assert job.work_mode == :hybrid
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_job(job, @invalid_attrs)
      assert job.id == Jobs.get_job!(job.id).id
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Jobs.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Jobs.change_job(job)
    end

    test "filter_options/0 returns enum values and distinct offices" do
      job_fixture(%{office: "Nantes"})
      job_fixture(%{office: "Paris"})
      job_fixture(%{office: "Paris"})

      assert Jobs.filter_options() == %{
               contract_types: [
                 :FULL_TIME,
                 :PART_TIME,
                 :TEMPORARY,
                 :FREELANCE,
                 :INTERNSHIP,
                 :APPRENTICESHIP,
                 :VIE
               ],
               work_modes: [:onsite, :remote, :hybrid],
               statuses: [:draft, :published, :filled, :archived, :cancelled],
               offices: ["Nantes", "Paris"]
             }
    end
  end
end
