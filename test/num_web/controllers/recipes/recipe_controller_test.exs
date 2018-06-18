defmodule NumWeb.Recipes.RecipeControllerTest do
  use NumWeb.ConnCase

  alias Num.Recipes

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  def fixture(:recipe) do
    {:ok, recipe} = Recipes.create_recipe(@create_attrs)
    recipe
  end

  describe "index" do
    test "lists all recipes", %{conn: conn} do
      conn = get conn, recipes_recipe_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    test "renders form", %{conn: conn} do
      conn = get conn, recipes_recipe_path(conn, :new)
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, recipes_recipe_path(conn, :create), recipe: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == recipes_recipe_path(conn, :show, id)

      conn = get conn, recipes_recipe_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Recipe"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, recipes_recipe_path(conn, :create), recipe: @invalid_attrs
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    setup [:create_recipe]

    test "renders form for editing chosen recipe", %{conn: conn, recipe: recipe} do
      conn = get conn, recipes_recipe_path(conn, :edit, recipe)
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    setup [:create_recipe]

    test "redirects when data is valid", %{conn: conn, recipe: recipe} do
      conn = put conn, recipes_recipe_path(conn, :update, recipe), recipe: @update_attrs
      assert redirected_to(conn) == recipes_recipe_path(conn, :show, recipe)

      conn = get conn, recipes_recipe_path(conn, :show, recipe)
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, recipe: recipe} do
      conn = put conn, recipes_recipe_path(conn, :update, recipe), recipe: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "delete recipe" do
    setup [:create_recipe]

    test "deletes chosen recipe", %{conn: conn, recipe: recipe} do
      conn = delete conn, recipes_recipe_path(conn, :delete, recipe)
      assert redirected_to(conn) == recipes_recipe_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, recipes_recipe_path(conn, :show, recipe)
      end
    end
  end

  defp create_recipe(_) do
    recipe = fixture(:recipe)
    {:ok, recipe: recipe}
  end
end
