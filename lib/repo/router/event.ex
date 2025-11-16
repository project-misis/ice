defmodule Repo.Event.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "" do
    case Repo.Domain.list_events() do
      {:ok, events} ->
        send_resp(conn, 200, Jason.encode!(events))

      {:error, err} ->
        send_resp(conn, 400, "List events: #{inspect(err)}")
    end
  end

  get "/:event_id" do
    case Repo.Domain.get_event(event_id) do
      {:ok, event} ->
        send_resp(conn, 200, Jason.encode!(event))

      {:error, _} ->
        send_resp(conn, 404, "Event Not found")
    end
  end

  post "" do
    attrs = conn.body_params

    case Repo.Domain.create_event(attrs) do
      {:ok, event} ->
        send_resp(conn, 200, Jason.encode!(event))

      {:error, err} ->
        send_resp(conn, 400, "Create event: #{inspect(err)}")
    end
  end

  put "/:event_id" do
    attrs = conn.body_params

    case Repo.Domain.update_event(event_id, attrs) do
      {:ok, event} ->
        send_resp(conn, 200, Jason.encode!(event))

      {:error, err} ->
        send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  delete "/:event_id" do
    case Repo.Domain.delete_event(event_id) do
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
