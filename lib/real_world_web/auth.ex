defmodule RealWorldWeb.Auth do
  @doc """
  Define JWT payloads via `Guardian`.

  Refer: [uberauth/guardian](https://github.com/ueberauth/guardian)
  """
  defmodule Pipeline do
    use Guardian.Plug.Pipeline, otp_app: :real_world

    plug Guardian.Plug.VerifyHeader, scheme: "Token"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  defmodule ErrorHandler do
    @behaviour Guardian.Plug.ErrorHandler
    use Phoenix.Controller

    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {_type, _reason}, _opts) do
      conn
      |> put_status(:unauthorized)
      |> put_view(json: RealWorldWeb.ErrorJSON)
      |> render(:"401")
    end
  end

  alias RealWorld.Accounts

  use Guardian, otp_app: :real_world

  @spec subject_for_token(map, map) :: {:ok, String.t()} | {:error, :invalid}
  def subject_for_token(%{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :invalid}
  end

  @spec resource_from_claims(map) :: {:ok, Accounts.User.t()} | {:error, :invalidj}
  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid}
  end

  @spec get_current_user_from_token(Plug.Conn.t()) :: User.t()
  def get_current_user_from_token(%Plug.Conn{} = conn) do
    __MODULE__.Plug.current_resource(conn)
  end
end
