defmodule NumWeb.Router do
  use NumWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NumWeb do
    pipe_through [:browser, :authenticate_user]

    get "/", PageController, :index

    resources "/users", UserController
  end

  scope "/", NumWeb do
    pipe_through [:browser]
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end

  scope "/recipes", NumWeb.Recipes, as: :recipes do
    pipe_through [:browser, :authenticate_user]

    get "/mine", RecipeController, :mine
    get "/random", RecipeController, :random

    put "/recipes/:id/bookmark", RecipeController, :save_recipe
    delete "/recipes/:id/bookmark", RecipeController, :forget_recipe

    post "/recipes/:id/cook", RecipeController, :cook
    post "/recipes/:id/skip", RecipeController, :skip

    get "/recipes/:id/thumb", RecipeController, :thumb
    get "/recipes/:id/photo", RecipeController, :photo
    resources "/recipes", RecipeController
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Bitte einloggen!")
        |> Phoenix.Controller.redirect(to: "/sessions/new")
        |> halt()
      user_id ->
        assign(conn, :current_user, Num.Accounts.get_user!(user_id))
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", NumWeb do
  #   pipe_through :api
  # end
end
