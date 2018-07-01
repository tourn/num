defmodule NumWeb.Recipes.RecipeController do
  use NumWeb, :controller

  alias Num.Recipes
  alias Num.Recipes.Recipe

  plug :require_user

  def index(conn, _params) do
    #recipes = Recipes.list_recipes()
    recipes = Recipes.list_recipes_with_events(conn.assigns.current_user.id)
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset)
  end


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


  def recipe_weight(recipe) do
    import NaiveDateTime
    hours = 60 * 60
    day = hours * 24
    four_hours_ago = utc_now() |> add(-4 * hours, :second)
    base_weight = 10
    %{
      value: recipe.id,
      weight: case recipe do
        %{skipped_at: skipped_at} = rest when skipped_at > four_hours_ago -> 0
        %{skipped_at: nil} = rest -> base_weight
        %{cooked_at: cooked_at} = rest ->
          diff_days = diff(utc_now(), cooked_at, :second)
          |> Kernel./(day)
          |> Float.round
          Enum.max([0, base_weight - diff_days])
        _ -> base_weight
        end
    }
  end

  def random(conn, _params) do
    recipe = Recipes.list_recipes_with_events(conn.assigns.current_user.id)
    |> Enum.map(&recipe_weight/1)
    |> Enum.filter(& &1.weight > 0)
    |> IO.inspect(label: "weighted recipes")
    |> WeightedRandom.complex()
    |> render_random(conn)
  end

  defp render_random(nil, conn) do
    conn
    |> put_flash(:info, "Mir sind die Ideen ausgegangen...")
    |> redirect(to: recipes_recipe_path(conn, :index))
  end

  defp render_random(recipe_id, conn) do
    recipe =  Recipes.get_recipe!(recipe_id)
    last_cooked = Recipes.last_cooked(recipe.id, conn.assigns.current_user.id)
    render(conn, "pick.html", recipe: recipe, last_cooked: last_cooked)
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
