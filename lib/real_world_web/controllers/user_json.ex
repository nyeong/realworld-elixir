defmodule RealWorldWeb.UserJSON do
  alias RealWorld.Accounts
  alias RealWorld.Accounts.User

  def show(%{user: %User{} = user}) do
    {:ok, token} = Accounts.sign_token(user)

    %{
      user: %{
        email: user.email,
        username: user.username,
        bio: user.bio,
        image: user.image,
        token: token
      }
    }
  end
end
