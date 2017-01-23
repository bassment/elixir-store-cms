defmodule TestListener do
  use Boltun, otp_app: :baby_store

  alias BabyStore.Product

  listen do
    channel "my_channel", :get_message
  end

  def get_message(channel, payload) do
    products = Product |> Product.sorted |> BabyStore.Repo.all()
    BabyStore.Endpoint.broadcast("store:products", "allProducts", %{products: products})
  end
end
