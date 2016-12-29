defmodule BabyStore.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :type,      :string
      add :category,  :string
      add :title,     :string
      add :price,     :integer
      add :image,     :string
      add :available, :boolean
      add :createdBy, :string
      add :createAt,  :utc_datetime
    end
  end
end
