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
    |> validate_required([:title])
    |> strip_unsafe_body(recipe)
  end

  defp strip_unsafe_body(model, %{"body" => nil}) do
    model
  end

  defp strip_unsafe_body(model, %{"body" => body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    model |> put_change(:body, clean_body)
  end

  defp strip_unsafe_body(model, _) do
    model
  end


end
