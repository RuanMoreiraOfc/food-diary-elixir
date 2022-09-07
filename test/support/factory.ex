defmodule FoodDiary.Factory do
  use ExMachina.Ecto, repo: FoodDiary.Repo

  alias FoodDiary.{User, Meal}

  def user_factory do
    %User{
      id: 0,
      name: "Some body",
      email: "email-0@example.com",
      meals: [
        build(:meal_base, user_id: 0),
        build(:meal_base, user_id: 0)
      ]
    }
  end

  def meal_base_factory do
    calories =
      "20.00"
      |> Decimal.new()
      |> Decimal.to_float()

    %Meal{
      id: sequence(:id, & &1),
      user_id: 0,
      category: :food,
      calories: calories,
      description: "content here"
    }
  end

  def meal_factory do
    build(:meal_base, build(:user).id)
  end
end
