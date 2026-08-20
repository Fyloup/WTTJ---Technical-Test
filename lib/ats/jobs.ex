defmodule Ats.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false
  alias Ats.Repo

  alias Ats.Jobs.Job
  alias Ats.Professions.Profession

  @contract_types %{
    FULL_TIME: "Full-Time",
    PART_TIME: "Part-Time",
    TEMPORARY: "Temporary",
    FREELANCE: "Freelance",
    INTERNSHIP: "Internship"
  }

  @doc """
  Returns a job contract type.

  ## Examples

      iex> contract_type(%Job{contract_type: "FULL_TIME"})
      "Full-Time"

  """
  @spec contract_type(%Job{}) :: binary() | nil
  def contract_type(job) do
    @contract_types[job.contract_type]
  end

  @doc """
  Returns a job profession name.

  ## Examples

      iex> profession_name(%Job{profession: %Profession{name: "Software Engineer"}})
      "Software Engineer"
  """
  @spec profession_name(%Job{}) :: binary()
  def profession_name(%Job{profession: %Profession{name: profession_name}}) do
    profession_name
  end

  def profession_name(_job), do: ""

  @doc """
  Returns the list of jobs, optionally filtered by search params.

  Supported filters (all optional, all string-keyed):

    * `"title"` - case-insensitive partial match on the job title
    * `"office"` - case-insensitive exact match on the job location
    * `"contract_type"` - exact match, one of `#{inspect(Ecto.Enum.values(Job, :contract_type))}`
    * `"work_mode"` - exact match, one of `#{inspect(Ecto.Enum.values(Job, :work_mode))}`
    * `"status"` - exact match, one of `#{inspect(Ecto.Enum.values(Job, :status))}`

  Unknown or invalid filter values are ignored rather than raising.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

      iex> list_jobs(%{"title" => "engineer", "work_mode" => "remote"})
      [%Job{}, ...]

  """
  @spec list_jobs(map()) :: [%Job{}]
  def list_jobs(params \\ %{}) do
    Job
    |> filter_by_title(params["title"])
    |> filter_by_office(params["office"])
    |> filter_by_enum(:contract_type, params["contract_type"])
    |> filter_by_enum(:work_mode, params["work_mode"])
    |> filter_by_enum(:status, params["status"])
    |> Repo.all()
    |> Repo.preload(:profession)
  end

  @doc """
  Returns the set of values available for each job search filter, for
  populating filter UIs (e.g. select options).
  """
  @spec filter_options() :: map()
  def filter_options do
    %{
      contract_types: Ecto.Enum.values(Job, :contract_type),
      work_modes: Ecto.Enum.values(Job, :work_mode),
      statuses: Ecto.Enum.values(Job, :status),
      offices: list_offices()
    }
  end

  defp list_offices do
    Job
    |> select([j], j.office)
    |> distinct(true)
    |> order_by([j], asc: j.office)
    |> Repo.all()
  end

  defp filter_by_title(query, title) when is_binary(title) do
    case String.trim(title) do
      "" -> query
      title -> where(query, [j], ilike(j.title, ^"%#{escape_like(title)}%"))
    end
  end

  defp filter_by_title(query, _title), do: query

  defp filter_by_office(query, office) when is_binary(office) do
    case String.trim(office) do
      "" -> query
      office -> where(query, [j], ilike(j.office, ^escape_like(office)))
    end
  end

  defp filter_by_office(query, _office), do: query

  defp filter_by_enum(query, field, value) when is_binary(value) do
    case cast_enum(field, value) do
      {:ok, value} -> where(query, [j], field(j, ^field) == ^value)
      :error -> query
    end
  end

  defp filter_by_enum(query, _field, _value), do: query

  defp cast_enum(field, value) do
    Enum.find_value(Ecto.Enum.values(Job, field), :error, fn possible_value ->
      if Atom.to_string(possible_value) == value, do: {:ok, possible_value}
    end)
  end

  defp escape_like(value), do: String.replace(value, ~r/[\\%_]/, &("\\" <> &1))

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_job!(integer() | binary()) :: %Job{}
  def get_job!(id), do: Repo.get!(Job, id) |> Repo.preload(applicants: [:candidate])

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_job(map()) :: {:ok, %Job{}} | {:error, Ecto.Changeset.t()}
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update_job(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update_job(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_job(%Job{}, map()) :: {:ok, %Job{}} | {:error, Ecto.Changeset.t()}
  def update_job(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job.

  ## Examples

      iex> delete_job(job)
      {:ok, %Job{}}

      iex> delete_job(job)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_job(%Job{}) :: {:ok, %Job{}} | {:error, Ecto.Changeset.t()}
  def delete_job(%Job{} = job) do
    Repo.delete(job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change_job(job)
      %Ecto.Changeset{data: %Job{}}

  """
  @spec change_job(%Job{}, map()) :: Ecto.Changeset.t()
  def change_job(%Job{} = job, attrs \\ %{}) do
    Job.changeset(job, attrs)
  end
end
