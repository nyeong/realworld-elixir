defmodule RealWorld.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, null: false)
      add(:username, :string, null: false)
      add(:bio, :string)
      add(:image, :string)
      add(:hashed_password, :string)

      timestamps()
    end

    create(unique_index(:users, [:username]))
    create(unique_index(:users, [:email]))
  end
end
