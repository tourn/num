defmodule Num.RecipesTest do
  use Num.DataCase

  alias Num.Recipes

  describe "recipes" do
    alias Num.Recipes.Recipe

    @valid_attrs %{body: "some body", title: "some title"}
    @update_attrs %{body: "some updated body", title: "some updated title"}
    @invalid_attrs %{body: nil, title: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@valid_attrs)
      assert recipe.body == "some body"
      assert recipe.title == "some title"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, recipe} = Recipes.update_recipe(recipe, @update_attrs)
      assert %Recipe{} = recipe
      assert recipe.body == "some updated body"
      assert recipe.title == "some updated title"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end

    test "list_recipes_with_events" do
      stuff = Recipes.list_recipes_with_events()
      IO.inspect(stuff)
    end
  end

  describe "recipe_event" do
    alias Num.Recipes.RecipeEvent

    @valid_attrs %{date: ~D[2010-04-17], event: "some event"}
    @update_attrs %{date: ~D[2011-05-18], event: "some updated event"}
    @invalid_attrs %{date: nil, event: nil}

    def recipe_event_fixture(attrs \\ %{}) do
      {:ok, recipe_event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_recipe_event()

      recipe_event
    end

    test "list_recipe_event/0 returns all recipe_event" do
      recipe_event = recipe_event_fixture()
      assert Recipes.list_recipe_event() == [recipe_event]
    end

    test "get_recipe_event!/1 returns the recipe_event with given id" do
      recipe_event = recipe_event_fixture()
      assert Recipes.get_recipe_event!(recipe_event.id) == recipe_event
    end

    test "create_recipe_event/1 with valid data creates a recipe_event" do
      assert {:ok, %RecipeEvent{} = recipe_event} = Recipes.create_recipe_event(@valid_attrs)
      assert recipe_event.date == ~D[2010-04-17]
      assert recipe_event.event == "some event"
    end

    test "create_recipe_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe_event(@invalid_attrs)
    end

    test "update_recipe_event/2 with valid data updates the recipe_event" do
      recipe_event = recipe_event_fixture()
      assert {:ok, recipe_event} = Recipes.update_recipe_event(recipe_event, @update_attrs)
      assert %RecipeEvent{} = recipe_event
      assert recipe_event.date == ~D[2011-05-18]
      assert recipe_event.event == "some updated event"
    end

    test "update_recipe_event/2 with invalid data returns error changeset" do
      recipe_event = recipe_event_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe_event(recipe_event, @invalid_attrs)
      assert recipe_event == Recipes.get_recipe_event!(recipe_event.id)
    end

    test "delete_recipe_event/1 deletes the recipe_event" do
      recipe_event = recipe_event_fixture()
      assert {:ok, %RecipeEvent{}} = Recipes.delete_recipe_event(recipe_event)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe_event!(recipe_event.id) end
    end

    test "change_recipe_event/1 returns a recipe_event changeset" do
      recipe_event = recipe_event_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe_event(recipe_event)
    end
  end
end
