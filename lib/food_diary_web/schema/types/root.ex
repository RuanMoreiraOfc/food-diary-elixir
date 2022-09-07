defmodule FoodDiaryWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias FoodDiaryWeb.Resolvers.User, as: UserResolver

  import_types FoodDiaryWeb.Schema.Types.User

  object :root_query do
    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &UserResolver.get/2
    end
  end
end
