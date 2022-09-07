defmodule FoodDiaryWeb.Resolvers.User do
  alias FoodDiary.Users

  def get(%{id: user_id}, _context) do
    Users.Get.call(user_id)
  end

  def create(%{input: parmas}, _context) do
    Users.Create.call(parmas)
  end

  def delete(%{id: id}, _context) do
    Users.Delete.call(id)
  end
end
