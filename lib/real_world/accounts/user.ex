defmodule RealWorld.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @username_regex ~r/^[a-zA-Z0-9_-]+$/
  @email_regex ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/

  @type t :: %__MODULE__{
          bio: String.t(),
          email: String.t(),
          hashed_password: String.t(),
          username: String.t(),
          image: String.t(),
          password: String.t()
        }

  schema "users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :username, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :bio, :image, :username])
    |> validate_format(:email, @email_regex)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_format(:username, @username_regex)
    |> validate_length(:username, min: 3, max: 40)
    |> update_change(:username, &String.downcase/1)
    |> unique_constraint(:username)
  end

  def registrate_changeset(user, attrs) do
    changeset(user, attrs)
    |> cast(attrs, [:password])
    |> validate_required([:email, :password, :username])
    |> validate_length(:password, min: 6)
    |> put_hashed_password()
  end

  def update_changeset(user, attrs) do
    changeset(user, attrs)
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset = %Ecto.Changeset{}) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        changeset
        |> delete_change(:password)
        |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
