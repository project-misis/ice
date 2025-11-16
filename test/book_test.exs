defmodule Test.Book do
  use ExUnit.Case, async: false
  import Plug.Test
  import Plug.Conn

  @test_book %{
    name: "Metaprogramming Elixir",
    author: "Chris McCord",
    language: "en",
    link: "https://example.com/metaprogramming-elixir"
  }

  @opts Ice.Router.init([])

  setup do
    table = Ash.DataLayer.Ets.Info.table(Repo.Book)

    case :ets.info(table) do
      :undefined ->
        :ok

      _ ->
        :ets.delete_all_objects(table)
        :ok
    end
  end

  test "GET [/books] returns empty list -> 200" do
    conn = conn(:get, "/books")

    conn = Ice.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert length(JSON.decode!(conn.resp_body)) == 0
  end

  test "GET [/books] returns list with one item -> 200" do
    conn =
      conn(:post, "/books", JSON.encode!(@test_book))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    conn = conn(:get, "/books") |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert length(JSON.decode!(conn.resp_body)) == 1
  end

  test "POST [/books] invalid fields -> 400" do
    body = JSON.encode!(%{year: "2000", foo: "bar"})

    conn =
      conn(:post, "/books", body)
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "POST [/books] OK -> 200" do
    conn =
      conn(:post, "/books", JSON.encode!(@test_book))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert resp["name"] == @test_book.name
    assert Map.has_key?(resp, "id")
  end

  test "GET [/books/:id] OK -> 200" do
    conn =
      conn(:post, "/books", JSON.encode!(@test_book))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/books/#{id}"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 200

    answer_get = JSON.decode!(conn.resp_body)
    assert id == answer_get["id"]
    assert answer_get["name"] == resp["name"]
  end

  test "GET [/books/:id] Not found -> 404" do
    path = "/books/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE [/books/:id] OK -> 204" do
    conn =
      conn(:post, "/books", JSON.encode!(@test_book))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/books/#{id}"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE [/books/:id] Not found -> 404" do
    path = "/books/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "PUT [/books/:id] Change name -> 200" do
    conn =
      conn(:post, "/books", JSON.encode!(@test_book))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert Map.has_key?(resp, "id")

    upd_body = %{"name" => "Programming Phoenix"}
    path = "/books/#{resp["id"]}"

    conn =
      conn(:put, path, JSON.encode!(upd_body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    put_resp = JSON.decode!(conn.resp_body)

    assert put_resp["name"] == upd_body["name"]
    assert put_resp["id"] == resp["id"]
  end

  test "PUT [/books/:id] Book not found -> 404" do
    body = %{"name" => "Programming Phoenix"}
    path = "/books/43391d68-f529-43df-9974-c381d5f14060"

    conn =
      conn(:put, path, JSON.encode!(body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
