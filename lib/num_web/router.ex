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
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/hello", HelloController, :index

    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true

  end

  scope "/recipes", NumWeb.Recipes, as: :recipes do
    pipe_through [:browser, :authenticate_user]

    get "/random", RecipeController, :random
    resources "/recipes", RecipeController
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
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
