defmodule Repo.Book.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "" do
    case Repo.Domain.list_books() do
      {:ok, books} ->
        send_resp(conn, 200, Jason.encode!(books))

      {:error, err} ->
        send_resp(conn, 400, "List books: #{inspect(err)}")
    end
  end

  get "/:book_id" do
    case Repo.Domain.get_book(book_id) do
      {:ok, book} ->
        send_resp(conn, 200, Jason.encode!(book))

      {:error, _} ->
        send_resp(conn, 404, "Book Not found")
    end
  end

  post "" do
    attrs = conn.body_params

    case Repo.Domain.create_book(attrs) do
      {:ok, book} ->
        send_resp(conn, 200, Jason.encode!(book))

      {:error, err} ->
        send_resp(conn, 400, "Create book: #{inspect(err)}")
    end
  end

  put "/:book_id" do
    attrs = conn.body_params

    case Repo.Domain.update_book(book_id, attrs) do
      {:ok, book} ->
        send_resp(conn, 200, Jason.encode!(book))

      {:error, err} ->
        send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  delete "/:book_id" do
    case Repo.Domain.delete_book(book_id) do
      :ok ->
        send_resp(conn, 204, "")

      {:error, err} ->
        send_resp(conn, 404, "Error: #{inspect(err)}")
    end
  end

  match _ do
    IO.puts(conn.path)
    send_resp(conn, 404, "Not Found")
  end
end
