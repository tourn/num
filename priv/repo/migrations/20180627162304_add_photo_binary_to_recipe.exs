defmodule Num.Repo.Migrations.AddImageBinaryToRecipe do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :photo, :binary
      add :photo_type, :string
    end

  end
end
