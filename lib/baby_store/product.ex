defmodule BabyStore.Product do
  use Ecto.Schema
  import Ecto.Query

  def sorted(query) do
    from p in query,
    order_by: [asc: p.title]
  end

  @derive {Poison.Encoder, only: [:title, :price, :image]}
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
