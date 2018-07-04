defmodule Num.Recipes.RecipeEvent do
  use Ecto.Schema
  import Ecto.Changeset

  alias Num.Accounts.User
  alias Num.Recipes.Recipe


  schema "recipe_event" do
    field :event, :string
    belongs_to :user, User
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(recipe_event, %{"user" => user, "recipe" => recipe} = attrs) do
    recipe_event
    |> cast(attrs, [:event])
    |> put_assoc(:user, user)
    |> put_assoc(:recipe, recipe)
    |> validate_required([:event])
    |> validate_required([:user])
    |> validate_required([:recipe])
    |> validate_inclusion(:event, ["cook", "skip", "save"])
  end
end
