defmodule RealWorld.AccountsTest do
  use RealWorld.DataCase

  alias RealWorld.Accounts

  describe "users" do
    alias RealWorld.Accounts.User

    import RealWorld.AccountsFixtures

    @invalid_attrs %{bio: nil, email: nil, hashed_password: nil, image: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "register_user/1 with valid data creates a user" do
      valid_attrs = %{
        email: "some@email.com",
        password: "some hashed_password",
        username: "some_username"
      }

      assert {:ok, %User{} = user} = Accounts.registrate_user(valid_attrs)
      assert user.bio == nil
      assert user.image == nil
      assert user.email == "some@email.com"
      assert user.username == "some_username"
      # assert user.hashed_password == "some hashed_password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.registrate_user(@invalid_attrs)
    end

    # test "update_user/2 with valid data updates the user" do
    #   user = user_fixture()

    #   update_attrs = %{
    #     bio: "some updated bio",
    #     email: "some updated email",
    #     hashed_password: "some updated hashed_password",
    #     image: "some updated image",
    #     username: "some updated username"
    #   }

    #   assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
    #   assert user.bio == "some updated bio"
    #   assert user.email == "some updated email"
    #   assert user.hashed_password == "some updated hashed_password"
    #   assert user.image == "some updated image"
    #   assert user.username == "some updated username"
    # end

    # test "update_user/2 with invalid data returns error changeset" do
    #   user = user_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    #   assert user == Accounts.get_user!(user.id)
    # end

    test "authenticate/2 with valid email and password returns user" do
      password = "password"
      user = user_fixture(password: password)
      assert {:ok, %User{}} = Accounts.authenticate(user.email, password)
    end

    test "authenticate/2 with invalid email and password pair, returns :invalid" do
      password = "password"
      user = user_fixture(password: password)
      assert {:error, :invalid} = Accounts.authenticate(user.email, password <> "a")
    end

    test "authenticate/2 returns :not_found when user not found with the provided email" do
      password = "password"
      user = user_fixture(password: password)
      assert {:error, :not_found} = Accounts.authenticate(user.email <> "a", password)
    end
  end
end
