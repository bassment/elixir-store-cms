defmodule BabyStore.Product do
  use Ecto.Schema

  schema "products" do
    field :type,      :string
    field :category,  :string
    field :title,     :string
    field :price,     :integer
    field :image,     :string
    field :available, :boolean
    field :createdBy, :string
    field :createAt,  :utc_datetime
  end

  def changeset(product, params \\ %{}) do
    product
    |> Ecto.Changeset.cast(params, [:type, :category, :title, :price, :image, :available, :createdBy, :createdAt])
    |> Ecto.Changeset.validate_required([:title, :price])
  end
end
