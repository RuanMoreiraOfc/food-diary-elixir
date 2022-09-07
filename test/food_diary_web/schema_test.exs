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
  end
end
