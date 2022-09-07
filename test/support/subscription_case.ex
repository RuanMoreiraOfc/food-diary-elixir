defmodule FoodDiaryWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  alias Absinthe.Phoenix.SubscriptionTest
  alias FoodDiaryWeb.{ChannelCase, Schema, Endpoint, FoodSocket}
  alias Phoenix.ChannelTest

  using do
    quote do
      # Import conveniences for testing with channels
      import ChannelTest
      import ChannelCase

      use SubscriptionTest, schema: Schema

      # The default endpoint for testing
      @endpoint Endpoint

      setup do
        {:ok, channelSocket} = ChannelTest.connect(FoodSocket, %{})
        {:ok, absintheSocket} = SubscriptionTest.join_absinthe(channelSocket)

        {:ok, socket: absintheSocket}
      end
    end
  end
end
