defmodule RealWorld.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealWorld.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        email: "admin@example.com",
        password: "some hashed_password",
        image: "some image",
        username: "my_username"
      })
      |> RealWorld.Accounts.registrate_user()

    user
  end
end
