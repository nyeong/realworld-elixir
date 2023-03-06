defmodule RealWorldWeb.UserController do
  use RealWorldWeb, :controller

  alias RealWorld.Accounts
  alias RealWorld.Accounts.User
  alias RealWorldWeb.Auth

  action_fallback RealWorldWeb.FallbackController

  @doc """
  https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints#registration
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.registrate_user(user_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc """
  https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints#get-current-userg
  """
  def get_current(conn, _) do
    user = Auth.get_current_user_from_token(conn)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"user" => user_params}) do
    user = Auth.get_current_user_from_token(conn)
    with {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end
end
