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

  alias Num.Recipes.RecipeEvent

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
