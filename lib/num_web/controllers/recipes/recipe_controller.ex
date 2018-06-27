defmodule NumWeb.Recipes.RecipeController do
  use NumWeb, :controller

  alias Num.Recipes
  alias Num.Recipes.Recipe

  plug :require_user when action in [:cook]

  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end

#  defp transform_params(%{"photo" => photo} = params) do
#    data = File.read()
#  end
#
#  defp transform_params(recipe_params) do
#    recipe_params
#  end


  def create(conn, %{"recipe" => recipe_params}) do
    IO.inspect recipe_params
    params = case recipe_params do
      %{"photo" => photo} = rest -> rest
        |> Map.put("photo", File.read!(photo.path))
        |> Map.put("photo_type", photo.content_type)
      rest -> rest
    end
    case Recipes.create_recipe(params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: recipes_recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    changeset = Recipes.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(id)

    case Recipes.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: recipes_recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: recipes_recipe_path(conn, :index))
  end

  def random(conn, _params) do
    recipes = Recipes.list_recipes()
    recipe = Enum.random(recipes)
    render(conn, "pick.html", recipe: recipe)
  end

  def cook(conn, %{"id" => recipe_id}) do
    recipe = Recipes.get_recipe!(recipe_id)
    case Recipes.create_recipe_event(%{
      "recipe" => recipe,
      "user" => conn.assigns.current_user,
      "event" => "cook"
    }) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "mjam mjam")
        |> redirect(to: recipes_recipe_path(conn, :show, recipe_id))
    end
  end

  def skip(conn, %{"id" => recipe_id}) do
    recipe = Recipes.get_recipe!(recipe_id)
    case Recipes.create_recipe_event(%{
      "recipe" => recipe,
      "user" => conn.assigns.current_user,
      "event" => "skip"
    }) do
      {:ok, _} ->
        conn
        |> redirect(to: recipes_recipe_path(conn, :random))
    end
  end

  defp require_user(conn, _) do
    case get_session(conn, :user_id) do
      nil -> conn
      |> put_flash(:error, "User required!")
      |> halt()
      id -> conn
      |> assign(:current_user, Num.Accounts.get_user!(id))
    end
  end

end
