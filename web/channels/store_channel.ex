defmodule BabyStore.StoreChannel do
  use BabyStore.Web, :channel

  def join("store:products", payload, socket) do
    if authorized?(payload) do
      {:ok, %{message: "Successfully connected!"}, socket}
    else
      {:error, %{reason: "Unauthorized!"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("products", _, socket) do
    products = BabyStore.Product.getProducts()
    broadcast socket, "products", %{products: products}
    {:reply, {:ok, %{message: "Sending products..."}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
