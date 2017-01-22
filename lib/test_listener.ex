defmodule TestListener do
  use Boltun, otp_app: :baby_store

  listen do
    channel "my_channel", :get_message
  end

  def get_message(channel, payload) do
    IO.puts inspect payload
    products = [
      %{title: "Product one", price: 123, image: "default"},
    ]
    BabyStore.Endpoint.broadcast("store:products", "allProducts", %{products: products})
  end
end
