defmodule BabyStore.Product do
  use Ecto.Schema

  schema "products" do
    field :title, :string
    field :price, :integer
    field :image, :string
  end

  def changeset(product, params \\ %{}) do
    product
    |> Ecto.Changeset.cast(params, [:title, :price, :image])
    |> Ecto.Changeset.validate_required([:title, :price])
  end
end
