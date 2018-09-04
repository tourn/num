defmodule NumWeb.Recipes.RecipeController do
  use NumWeb, :controller

  alias Num.Recipes
  alias Num.Recipes.Recipe

  def index(conn, params) do

    defaults = %{"q" => ""}
    %{"q" => title_filter} = Map.merge(defaults, params)

    recipes = Recipes.list_recipes_with_events(conn.assigns.current_user.id)
    |> Enum.filter(& String.downcase(&1.title) =~ String.downcase(title_filter))

    render(conn, "index.html", recipes: recipes)
  end

  def mine(conn, _params) do
    recipes = Recipes.list_recipes_with_events(conn.assigns.current_user.id)
    |> Enum.filter(& &1.saved == true)
    render(conn, "mine.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, "new.html", changeset: changeset, recipe: nil)
  end

  defp transform_photo_param(%{"photo" => photo} = rest) do
    import Mogrify
    full =
      open(photo.path)
      |> resize_to_limit("1000x1000")
      |> format("jpeg")
      |> save

    thumb =
      open(photo.path)
      |> resize_to_limit("200x200")
      |> format("jpeg")
      |> save

    rest
      |> Map.put("photo", File.read!(full.path))
      |> Map.put("photo_thumb", File.read!(thumb.path))
      |> Map.put("photo_type", "image/jpeg")
  end

  defp transform_photo_param(params) do
    params
  end


  def create(conn, %{"recipe" => recipe_params}) do
    case Recipes.create_recipe(transform_photo_param(recipe_params)) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, gettext "Recipe created successfully.")
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

    case Recipes.update_recipe(recipe, transform_photo_param(recipe_params)) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, gettext "Recipe updated successfully.")
        |> redirect(to: recipes_recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    conn
    |> put_flash(:info, gettext "Recipe deleted successfully.")
    |> redirect(to: recipes_recipe_path(conn, :index))
  end


  def recipe_weight(recipe) do
    import NaiveDateTime
    hours = 60 * 60
    day = hours * 24
    skipped_ignore_for = utc_now() |> add(-1 * hours, :second)
    base_weight = 10
    %{
      value: recipe.id,
      weight: case recipe do
        %{saved: false} -> 0
        %{skipped_at: skipped_at} when skipped_at > skipped_ignore_for -> 0
        %{cooked_at: nil} -> base_weight
        %{cooked_at: cooked_at} ->
          diff_days = diff(utc_now(), cooked_at, :second)
          |> Kernel./(day)
          |> Kernel.trunc
          Enum.min([base_weight, diff_days])
        _ -> base_weight
        end
    }
  end

  def random(conn, _params) do
    Recipes.list_recipes_with_events(conn.assigns.current_user.id)
    |> Enum.map(&recipe_weight/1)
    |> Enum.filter(& &1.weight > 0)
    |> IO.inspect(label: "weighted recipes")
    |> WeightedRandom.complex()
    |> render_random(conn)
  end

  defp render_random(nil, conn) do
    conn
    |> put_flash(:info, gettext("I've run out of ideas..."))
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
        |> put_flash(:info, gettext("Looks tasty. Enjoy!"))
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

  def thumb(conn, %{"id" => recipe_id}) do
    recipe = Recipes.get_recipe!(recipe_id)
    cond do
      recipe.photo_thumb == nil -> conn
                                   |> put_status(:not_found)
                                   |> put_view(NumWeb.ErrorView)
                                   |> render("404.html")
      true -> conn
              |> Plug.Conn.put_resp_header("content-type", recipe.photo_type)
              |> Plug.Conn.send_resp(200, recipe.photo_thumb)
    end
  end

  def photo(conn, %{"id" => recipe_id}) do
    recipe = Recipes.get_recipe!(recipe_id)
    cond do
      recipe.photo == nil -> conn
        |> put_status(:not_found)
        |> put_view(NumWeb.ErrorView)
        |> render("404.html")
      true -> conn
        |> Plug.Conn.put_resp_header("content-type", recipe.photo_type)
        |> Plug.Conn.send_resp(200, recipe.photo)
    end
  end

   def save_recipe(conn, %{"id" => recipe_id}) do
      recipe = Recipes.get_recipe!(recipe_id)
      case Recipes.create_recipe_event(%{
        "recipe" => recipe,
        "user" => conn.assigns.current_user,
        "event" => "save"
      }) do
        {:ok, _} ->
          conn
          |> put_flash(:info, gettext("Recipe saved"))
          |> redirect(to: recipes_recipe_path(conn, :index)<>"#r#{recipe_id}")
      end
   end

  def forget_recipe(conn, %{"id" => recipe_id}) do
    case Recipes.delete_recipe_event(conn.assigns.current_user.id, recipe_id, "save") do
      {n, _} when n > 0->
        conn
        |> put_flash(:info, gettext("Recipe removed"))
        |> redirect(to: recipes_recipe_path(conn, :index)<>"#r#{recipe_id}")
      _ ->
        conn
        |> put_flash(:error, gettext("Could not remove recipe"))
        |> redirect(to: recipes_recipe_path(conn, :index)<>"#r#{recipe_id}")
    end
  end

end
