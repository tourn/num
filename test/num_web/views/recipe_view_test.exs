defmodule NumWeb.Recipes.RecipeViewTest do
  use NumWeb.ConnCase, async: true

  describe "markdown" do
    test "converts markdown to html" do
      {:safe, result} = NumWeb.Recipes.RecipeView.markdown("**bold me**")
      assert String.contains? result, "<strong>bold me</strong>"
    end

    test "leaves text with no markdown alone" do
      {:safe, result} = NumWeb.Recipes.RecipeView.markdown("leave me alone")
      assert String.contains? result, "leave me alone"
    end

    test "gracefully handles nil values" do
      {:safe, result} = NumWeb.Recipes.RecipeView.markdown(nil)
      assert String.equivalent? result, ""
    end
  end

  describe "urls_to_anchors" do
    test "converts something that looks like an url to an anchor" do
      result = NumWeb.Recipes.RecipeView.urls_to_anchors("Look what i found: http://example.com - Neat huh?")
      assert String.contains? result, ~s(<a href="http://example.com">http://example.com</a>)
    end

    test "also includes the path" do
      result = NumWeb.Recipes.RecipeView.urls_to_anchors("Look what i found: http://example.com/potatoes - Neat huh?")
      assert String.contains? result, ~s(<a href="http://example.com/potatoes">http://example.com/potatoes</a>)
    end

    test "leaves text with no urls alone" do
      result = NumWeb.Recipes.RecipeView.urls_to_anchors("leave me alone")
      assert String.contains? result, "leave me alone"
    end

    test "gracefully handles nil values" do
      result = NumWeb.Recipes.RecipeView.urls_to_anchors(nil)
      assert String.equivalent? result, ""
    end
  end

end