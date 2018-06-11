defmodule NumWeb.HelloController do
  use NumWeb, :controller

  def index(conn, _params) do
    conn
    |> render(:index)
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, "show.html", messenger: messenger
  end
end