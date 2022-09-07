defmodule FoodDiaryWeb.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias Crudry.Middlewares.TranslateErrors
  alias FoodDiaryWeb.Resolvers.Meal, as: MealResolver
  alias FoodDiaryWeb.Resolvers.User, as: UserResolver

  import_types FoodDiaryWeb.Schema.Types.Meal
  import_types FoodDiaryWeb.Schema.Types.User

  object :root_query do
    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &UserResolver.get/2
    end
  end

  object :root_mutation do
    @desc "Create a new user"
    field :create_user, type: :user do
      arg :input, non_null(:create_user_input)
      resolve &UserResolver.create/2
      middleware TranslateErrors
    end

    @desc "Delete a User"
    field :delete_user, type: :user do
      arg :id, non_null(:id)
      resolve &UserResolver.delete/2
    end

    @desc "Create a new Meal"
    field :create_meal, type: :meal do
      arg :input, non_null(:create_meal_input)
      resolve &MealResolver.create/2
      middleware TranslateErrors
    end
  end

  object :root_subscription do
    field :new_meal, :meal do
      config fn _args, _context ->
        {:ok, topic: "new_meal_topic"}
      end
    end
  end
end
