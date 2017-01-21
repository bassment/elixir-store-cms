defmodule BabyStore.StoreChannel do
  use BabyStore.Web, :channel

  alias BabyStore.Product
  alias BabyStore.Repo

  def join("store:products", payload, socket) do
    if authorized?(payload) do
      products = Product |> Repo.all
      {:ok, products, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("allProducts", _, socket) do
    {:reply, {:ok, %{products: "A lot of products here!"}}, socket}
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
