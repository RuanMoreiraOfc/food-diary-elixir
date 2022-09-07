defmodule FoodDiaryWeb.Resolvers.Meal do
  alias FoodDiary.Meals

  def create(%{input: parmas}, _context) do
    Meals.Create.call(parmas)
  end
end
