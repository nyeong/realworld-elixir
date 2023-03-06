defmodule RealWorldWeb.AuthController do
  use RealWorldWeb, :controller

  alias RealWorld.Accounts

  action_fallback RealWorldWeb.FallbackController

  @doc """
  https://realworld-docs.netlify.app/docs/specs/backend-specs/endpoints#authentication
  """
  def new(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, user} <- Accounts.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> put_view(json: RealWorldWeb.UserJSON)
      |> render(:show, user: user)
    else
      {:error, :not_found} ->
        {:error, :unprocessable_entity}

      {:error, :invalid} ->
        {:error, :unprocessable_entity}
    end
  end
end
