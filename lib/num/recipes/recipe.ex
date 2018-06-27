defmodule Num.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Num.Recipes.RecipeEvent

  schema "recipes" do
    field :body, :string
    field :title, :string
    field :photo, :binary
    field :photo_type, :string
    has_many :events, RecipeEvent

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :body, :photo, :photo_type])
    |> validate_required([:title, :body])
  end
end
