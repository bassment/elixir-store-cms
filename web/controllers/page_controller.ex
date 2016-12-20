defmodule BabyStore.PageController do
  use BabyStore.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
