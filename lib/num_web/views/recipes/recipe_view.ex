defmodule NumWeb.Recipes.RecipeView do
  use NumWeb, :view
  use Timex

  def encode_thumb(recipe) do
    encoded = Base.encode64(recipe.photo_thumb)
    "data:#{recipe.photo_type};base64, #{encoded}"
  end

  def encode_photo(recipe) do
    IO.inspect recipe.photo
    encoded = Base.encode64(recipe.photo)
    "data:#{recipe.photo_type};base64, #{encoded}"
  end

  def markdown(nil) do
    {:safe, ""}
  end

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end

  def urls_to_anchors(nil) do "" end
  def urls_to_anchors(body) do
    regex = ~r<(https?|ftp)://[^\s/$.?#].[^\s]*>i
    Regex.replace(regex, body, ~s(<a href="\\0">\\0</a>))
  end

  def format_date(nil) do
    gettext "Never"
  end

  def format_date(date) do
    date
#    |> Timex.to_datetime()
    |> Timex.format!("{D}.{M}.{YYYY}")
  end
end
