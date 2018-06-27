defmodule Num.Repo.Migrations.CreateRecipeEvent do
  use Ecto.Migration

  def change do
    create table(:recipe_event) do
      add :event, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end
  end
end
