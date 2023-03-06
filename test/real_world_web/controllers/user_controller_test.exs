defmodule RealWorldWeb.UserControllerTest do
  use RealWorldWeb.ConnCase

  import RealWorld.AccountsFixtures

  alias RealWorld.Accounts.User

  @create_attrs %{
    email: "some@email.com",
    password: "some hashed_password",
    username: "some_username"
  }

  @update_attrs %{
    bio: "some updated bio",
    email: "valid@user.mai",
    password: "some updated hashed_password",
    image: "some updated image",
    username: "valid_username"
  }

  @invalid_attrs %{
    email: "invalid@email",
    username: "lorem ipsum",
    password: "  "
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"email" => email} = json_response(conn, 201)["user"]
    end

    test "renders 422 when data is invalid", %{conn: conn} do
      @invalid_attrs 
      |> Enum.filter(fn {k, _} -> k in [:email, :username, :password] end)
      |> Enum.each(fn {k, v} ->
        wrong_attr = %{k => v} |> Enum.into(@create_attrs)
        conn = post(conn, ~p"/api/users", user: wrong_attr)
        assert json_response(conn, 422)["errors"] != %{}
      end)
    end
  end

  describe "get current user" do
    setup [:create_user]

    test "renders user when conn is authenticated", %{conn: conn, user: %User{} = user} do
      conn =
        conn
        |> sign_with_user(user)
        |> get(~p"/api/user")

      assert json_response(conn, 200)["user"]
    end

    test "renders 401 when the token is not provided", %{conn: conn} do
      conn = get(conn, ~p"/api/user")
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders 401 when the token is invalid", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Token " <> "invalid_token")
        |> get(~p"/api/user")

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders updated user when the provided token is valid", %{conn: conn, user: %User{} = user} do
      conn =
        conn
        |> sign_with_user(user)
        |> put(~p"/api/user", user: @update_attrs)

      assert json_response(conn, 200)["user"] 
    end

    test "renders 422 when the update param is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> sign_with_user(user)
        |> put(~p"/api/user", user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 401 when the token is invalid", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Token " <> "invalid_token")
        |> put(~p"/api/user")
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders 401 when the token is not provided", %{conn: conn} do
      conn = put(conn, ~p"/api/user")
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp sign_with_user(conn, user) do
    {:ok, token} = RealWorld.Accounts.sign_token(user)

    put_req_header(conn, "authorization", "Token " <> token)
  end
end
