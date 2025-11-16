defmodule Repo.User.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @repo Repo.Domain

  get "" do
    case @repo.list_users() do
      {:ok, users} ->
        send_resp(conn, 200, Jason.encode!(users))

      {:error, err} ->
        send_resp(conn, 400, "List users: #{inspect(err)}")
    end
  end

  get "/:user_id" do
    case @repo.get_user(user_id) do
      {:ok, [user]} ->
        send_resp(conn, 200, Jason.encode!(user))

      {:ok, []} ->
        send_resp(conn, 404, "User Not found")
    end
  end

  post "" do
    attrs = conn.body_params

    case @repo.create_user(attrs) do
      {:ok, user} -> send_resp(conn, 200, Jason.encode!(user))
      {:error, err} -> send_resp(conn, 400, "Create user: #{inspect(err)}")
    end
  end

  put "/:user_id" do
    attrs = conn.body_params

    case @repo.update_user(user_id, attrs) do
      {:ok, user} ->
        send_resp(conn, 200, Jason.encode!(user))

      {:error, err} ->
        send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  delete "/:user_id" do
    case @repo.delete_user(user_id) do
      :ok ->
        send_resp(conn, 204, "")

      {:error, err} ->
        send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
