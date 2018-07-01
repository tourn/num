defmodule Num.Repo.Migrations.AddPhotoThumbToRecipe do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :photo_thumb, :binary
    end
  end
end
