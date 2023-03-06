defmodule RealWorldWeb.AuthControllerTest do
  use RealWorldWeb.ConnCase

  import RealWorld.AccountsFixtures

  @auth_attrs %{
    username: "username",
    email: "some@email.com",
    password: "some hashed_password"
  }

  describe "authenticate user" do
    setup [:create_user]

    test "renders user when email and password are valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users/login", user: @auth_attrs)
      body = json_response(conn, 201)["user"]
      assert @auth_attrs[:username] == body["username"]
      assert @auth_attrs[:email] == body["email"]
    end

    test "return 422 when email and password are invalid", %{conn: conn} do
      auth_attrs = %{email: @auth_attrs.email, password: @auth_attrs.password <> "a"}
      conn = post(conn, ~p"/api/users/login", user: auth_attrs)
      assert json_response(conn, 422)["errors"]
    end

    test "return 422 when can't find the user with the provided email", %{conn: conn} do
      auth_attrs = %{email: @auth_attrs.email <> "a", password: @auth_attrs.password}
      conn = post(conn, ~p"/api/users/login", user: auth_attrs)
      assert json_response(conn, 422)["errors"]
    end
  end

  defp create_user(_) do
    user = user_fixture(@auth_attrs)
    %{user: user}
  end
end
