defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true
  use FoodDiaryWeb.SubscriptionCase

  import FoodDiary.Factory

  defp setupSubscription(socket, subscription, mutation) do
    # subscription setup
    subscription_socket_ref = push_doc(socket, subscription)
    assert_reply subscription_socket_ref, :ok, %{subscriptionId: subscription_id}

    # mutation setup
    mutation_socket_ref = push_doc(socket, mutation)
    assert_reply mutation_socket_ref, :ok, mutation_response

    %{mutation_response: mutation_response, subscription_id: subscription_id}
  end

  describe "RootQuery/User" do
    test "gets a user by id from database when id is valid", %{conn: conn} do
      %{id: user_id, name: name, email: email} = insert(:user)

      query = """
      {
        user(id: "#{user_id}") {
          name
          email
        }
      }
      """

      expected_response = %{
        "data" => %{
          "user" => %{
            "name" => name,
            "email" => email
          }
        }
      }

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert expected_response === response
    end

    test "fails to get a user by id from database when id is invalid", %{conn: conn} do
      query = """
      {
        user(id: id) {
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "message" => "Argument \"id\" has invalid value id."
                 }
               ]
             } = response
    end

    test "fails to get a user by id from database when it doesn't exists", %{conn: conn} do
      query = """
      {
        user(id: 0) {
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert %{
               "errors" => [
                 %{
                   "message" => "User not found",
                   "path" => ["user"]
                 }
               ]
             } = response
    end
  end

  describe "RootMutation/User" do
    test "create a user in database when all params are valid", %{conn: conn} do
      %{name: name, email: email} = build(:user_params)

      mutation = """
      mutation {
        createUser(input: {
          name: "#{name}"
          email: "#{email}"
        }) {
          id
          name
          email
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "id" => _id,
                   "name" => ^name,
                   "email" => ^email
                 }
               }
             } = response
    end
  end

  describe "RootSubscription/Meals" do
    test "watch any meal creation in database", %{socket: socket} do
      %{id: user_id} = insert(:user)

      %{
        description: description,
        calories: calories,
        category: category
      } = build(:meal_params, description: "wow a drink")

      mutation = """
      mutation {
        createMeal(input: {
          user_id: "#{user_id}",
          description: "#{description}",
          calories: #{calories},
          category: #{category}
        }) {
          description
          calories
          category
        }
      }
      """

      subscription = """
      subscription {
        newMeal {
          id
          description
          calories
          category
        }
      }
      """

      expected_mutation_response = %{
        data: %{
          "createMeal" => %{
            "description" => description,
            "calories" => calories,
            "category" => [category]
          }
        }
      }

      %{
        subscription_id: subscription_id,
        mutation_response: mutation_response
      } = setupSubscription(socket, subscription, mutation)

      assert expected_mutation_response === mutation_response

      assert_push "subscription:data", subscription_response

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "newMeal" => %{
                     "id" => _id,
                     "description" => ^description,
                     "calories" => ^calories,
                     "category" => [^category]
                   }
                 }
               }
             } = subscription_response
    end
  end
end
