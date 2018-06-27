defmodule Num.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias Num.Repo

  alias Num.Recipes.Recipe

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end


  import Ecto.Query, only: [from: 2]

  alias Num.Recipes.RecipeEvent

  def last_cooked(recipe_id) do
    query = from e in RecipeEvent,
      where: e.recipe_id == ^recipe_id and e.event == "cooked",
      order_by: [desc: :inserted_at],
      limit: 1,
      select: e.inserted_at

    Repo.one(query)
  end


  def list_recipes_with_events do
    stats_query = """
    select id, title, cooked_at, coalesce(cooked, 0) cooked, coalesce(skipped, 0) skipped from recipes
    left join (select recipe_id, count(*) cooked, max(inserted_at) cooked_at from recipe_event where event = 'cook' group by recipe_id) c  on recipes.id = c.recipe_id
    left join (select recipe_id, count(*) skipped from recipe_event where event = 'skip' group by recipe_id) s  on recipes.id = s.recipe_id
    """

    types = %{id: :integer, title: :string, cooked_at: :naive_datetime, cooked: :integer, skipped: :integer}

    {:ok, result} = Ecto.Adapters.SQL.query(Repo, stats_query)
    Enum.map(result.rows, &Repo.load(types, {result.columns, &1}))
  end


  @doc """
  Returns the list of recipe_event.

  ## Examples

      iex> list_recipe_event()
      [%RecipeEvent{}, ...]

  """
  def list_recipe_event do
    Repo.all(RecipeEvent)
  end

  @doc """
  Gets a single recipe_event.

  Raises `Ecto.NoResultsError` if the Recipe event does not exist.

  ## Examples

      iex> get_recipe_event!(123)
      %RecipeEvent{}

      iex> get_recipe_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_event!(id), do: Repo.get!(RecipeEvent, id)

  @doc """
  Creates a recipe_event.

  ## Examples

      iex> create_recipe_event(%{field: value})
      {:ok, %RecipeEvent{}}

      iex> create_recipe_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_event(attrs \\ %{}) do
    %RecipeEvent{}
    |> RecipeEvent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_event.

  ## Examples

      iex> update_recipe_event(recipe_event, %{field: new_value})
      {:ok, %RecipeEvent{}}

      iex> update_recipe_event(recipe_event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_event(%RecipeEvent{} = recipe_event, attrs) do
    recipe_event
    |> RecipeEvent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RecipeEvent.

  ## Examples

      iex> delete_recipe_event(recipe_event)
      {:ok, %RecipeEvent{}}

      iex> delete_recipe_event(recipe_event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe_event(%RecipeEvent{} = recipe_event) do
    Repo.delete(recipe_event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_event changes.

  ## Examples

      iex> change_recipe_event(recipe_event)
      %Ecto.Changeset{source: %RecipeEvent{}}

  """
  def change_recipe_event(%RecipeEvent{} = recipe_event) do
    RecipeEvent.changeset(recipe_event, %{})
  end
end
