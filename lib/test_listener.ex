defmodule TestListener do
  use Boltun, otp_app: :baby_store

  listen do
    channel "my_channel", :get_message
  end

  def get_message(channel, payload) do
    IO.puts inspect payload
  end
end
