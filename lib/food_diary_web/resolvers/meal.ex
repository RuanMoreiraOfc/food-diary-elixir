defmodule FoodDiaryWeb.Resolvers.Meal do
  alias Absinthe.Subscription
  alias FoodDiary.Meals
  alias FoodDiaryWeb.Endpoint

  def create(%{input: parmas}, _context) do
    with {:ok, meal} = response <- Meals.Create.call(parmas) do
      Subscription.publish(Endpoint, meal, new_meal: "new_meal_topic")
      response
    else
      error -> error
    end
  end
end
