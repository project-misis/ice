defmodule Ice.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  forward("/users", to: Repo.User.Router)
  forward("/books", to: Repo.Book.Router)
  forward("/events", to: Repo.Event.Router)

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
