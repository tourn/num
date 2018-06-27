defmodule NumWeb.Recipes.RecipeViewTest do
  use NumWeb.ConnCase, async: true

  test "converts markdown to html" do
    {:safe, result} = NumWeb.Recipes.RecipeView.markdown("**bold me**")
    assert String.contains? result, "<strong>bold me</strong>"
  end

  test "leaves text with no markdown alone" do
    {:safe, result} = NumWeb.Recipes.RecipeView.markdown("leave me alone")
    assert String.contains? result, "leave me alone"
  end
end