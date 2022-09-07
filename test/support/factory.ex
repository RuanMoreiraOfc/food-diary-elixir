defmodule FoodDiary.Factory do
  use ExMachina.Ecto, repo: FoodDiary.Repo

  alias FoodDiary.User

  def user_factory do
    %User{
      id: 0,
      name: "Some body",
      email: "email-0@example.com",
      meals: []
    }
  end
end
