defmodule BabyStore.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :price, :integer
      add :image, :string
    end
  end
end
