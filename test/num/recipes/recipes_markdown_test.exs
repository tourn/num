defmodule Num.RecipesTest do
  use Num.DataCase

  alias Num.Recipes

  describe "recipes" do
    alias Num.Recipes.Recipe

    @valid_attrs %{body: "some content", title: "some content"}
    @invalid_attrs %{}

    test "changeset with valid attributes" do
      changeset = Recipe.changeset(%Recipe{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Recipe.changeset(%Recipe{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "when the body includes a script tag" do
      changeset = Recipe.changeset(%Recipe{}, %{@valid_attrs | body: "Hello <script type='javascript'>alert('foo');</script>"})
      refute String.match? get_change(changeset, :body), ~r{<script>}
    end

    test "when the body includes an iframe tag" do
      changeset = Recipe.changeset(%Recipe{}, %{@valid_attrs | body: "Hello <iframe src='http://google.com'></iframe>"})
      refute String.match? get_change(changeset, :body), ~r{<iframe>}
    end

    test "body includes no stripped tags" do
      changeset = Recipe.changeset(%Recipe{}, @valid_attrs)
      assert get_change(changeset, :body) == @valid_attrs[:body]
    end

  end

end