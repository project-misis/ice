defmodule Accounts.Router do
  use Plug.Router
  require Ash.Query

  plug(:match)
  plug(:dispatch)

  @schema Accounts.Schema.User

  defp create(p) do
    @schema |> Ash.Changeset.for_create(:new, p) |> Ash.create()
  end

  get "/many" do
    case Ash.read(@schema) do
      {:ok, users} ->
        send_resp(conn, 200, Jason.encode!(users))

      {:error, err} ->
        send_resp(conn, 400, "List users: #{inspect(err)}")
    end
  end

  get "/one/:user_id" do
    case @schema |> Ash.Query.filter(id: user_id) |> Ash.read() do
      {:ok, [user]} ->
        send_resp(conn, 200, Jason.encode!(user))

      {:ok, []} ->
        send_resp(conn, 404, "User Not found")
    end
  end

  post "/create" do
    attrs = conn.body_params

    case create(attrs) do
      {:ok, user} -> send_resp(conn, 200, Jason.encode!(user))
      {:error, err} -> send_resp(conn, 400, "Create user: #{inspect(err)}")
    end
  end

  put "/update/:user_id" do
    attrs = conn.body_params

    with {:ok, user} <- @schema |> Ash.get(user_id),
         {:ok, user} <-
           user
           |> Ash.Changeset.for_update(:put, attrs)
           |> Ash.update() do
      body = Jason.encode!(user)
      send_resp(conn, 200, body)
    else
      {:error, err} -> send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  delete "/delete/:user_id" do
    with {:ok, user} <- @schema |> Ash.get(user_id),
         :ok <-
           user
           |> Ash.destroy() do
      send_resp(conn, 204, "")
    else
      {:error, err} -> send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
