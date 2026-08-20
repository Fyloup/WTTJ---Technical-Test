defmodule AtsWeb.Api.JobControllerTest do
  use AtsWeb.ConnCase
  import Ats.JobsFixtures

  describe "index" do
    test "returns all jobs when no filters are given", %{conn: conn} do
      job_fixture(%{title: "Backend Engineer"})
      job_fixture(%{title: "Frontend Engineer"})

      conn = get(conn, ~p"/api/jobs")

      assert %{"data" => data} = json_response(conn, 200)
      assert length(data) == 2
    end

    test "filters by title, case-insensitive partial match", %{conn: conn} do
      match = job_fixture(%{title: "Senior Backend Engineer"})
      job_fixture(%{title: "Frontend Developer"})

      conn = get(conn, ~p"/api/jobs?title=backend")

      assert %{"data" => [%{"id" => id}]} = json_response(conn, 200)
      assert id == match.id
    end

    test "filters by office", %{conn: conn} do
      match = job_fixture(%{office: "Nantes"})
      job_fixture(%{office: "Paris"})

      conn = get(conn, ~p"/api/jobs?office=Nantes")

      assert %{"data" => [%{"id" => id}]} = json_response(conn, 200)
      assert id == match.id
    end

    test "filters by contract_type, work_mode and status combined", %{conn: conn} do
      match =
        job_fixture(%{
          contract_type: "PART_TIME",
          work_mode: "remote",
          status: "published"
        })

      job_fixture(%{contract_type: "FULL_TIME", work_mode: "remote", status: "published"})

      conn =
        get(
          conn,
          ~p"/api/jobs?contract_type=PART_TIME&work_mode=remote&status=published"
        )

      assert %{"data" => [%{"id" => id}]} = json_response(conn, 200)
      assert id == match.id
    end

    test "ignores invalid filter values instead of erroring", %{conn: conn} do
      job_fixture()

      conn = get(conn, ~p"/api/jobs?contract_type=NOT_A_TYPE")

      assert %{"data" => data} = json_response(conn, 200)
      assert length(data) == 1
    end
  end

  describe "filters" do
    test "returns available filter values", %{conn: conn} do
      job_fixture(%{office: "Paris"})

      conn = get(conn, ~p"/api/jobs/filters")

      assert %{"data" => data} = json_response(conn, 200)
      assert "FULL_TIME" in data["contract_types"]
      assert "onsite" in data["work_modes"]
      assert "draft" in data["statuses"]
      assert "Paris" in data["offices"]
    end
  end
end
