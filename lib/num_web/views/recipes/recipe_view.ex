defmodule NumWeb.Recipes.RecipeView do
  use NumWeb, :view

  def encode_photo(recipe) do
    IO.inspect recipe.photo
    encoded = Base.encode64(recipe.photo)
    "data:#{recipe.photo_type};base64, #{encoded}"
  end
end
