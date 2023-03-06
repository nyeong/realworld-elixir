defmodule RealWorld.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias RealWorld.Repo

  alias RealWorld.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(attrs), do: Repo.get_by(User, attrs)

  @doc """
  Authenticate a user.
  """
  def registrate_user(attrs \\ %{}) do
    %User{}
    |> User.registrate_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Authenticate a user with email and password.
  """
  @spec authenticate(String.t(), String.t()) :: {:ok, User.t()} | {:error, :invalid | :not_found}
  def authenticate(email, password) do
    user = get_user_by(email: email)

    cond do
      user && Argon2.verify_pass(password, user.hashed_password) ->
        {:ok, user}

      user ->
        {:error, :invalid}

      true ->
        Argon2.no_user_verify()
        {:error, :not_found}
    end
  end

  @doc """
  Returns a signed token
  """
  @spec sign_token(User.t()) :: {:ok, String.t()} | {:error, any()}
  def sign_token(%User{} = user) do
    case RealWorldWeb.Auth.encode_and_sign(%{id: user.id}) do
      {:ok, token, _} ->
        {:ok, token}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
