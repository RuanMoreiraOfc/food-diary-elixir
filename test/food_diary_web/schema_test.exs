defmodule FoodDiaryWeb.SchemaTest do
  use FoodDiaryWeb.ConnCase, async: true

  import FoodDiary.Factory

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
end