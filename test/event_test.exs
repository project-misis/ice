defmodule Test.Event do
  use ExUnit.Case, async: false
  import Plug.Test
  import Plug.Conn

  @test_event %{
    name: "ElixirConf",
    where: "Austin, TX",
    link: "https://example.com/elixirconf",
    desc: "Annual Elixir conference",
    start: "2025-09-10",
    end: "2025-09-13"
  }

  @opts Ice.Router.init([])

  setup do
    table = Ash.DataLayer.Ets.Info.table(Repo.Event)

    case :ets.info(table) do
      :undefined ->
        :ok

      _ ->
        :ets.delete_all_objects(table)
        :ok
    end
  end

  test "GET [/events] returns empty list -> 200" do
    conn = conn(:get, "/events")

    conn = Ice.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert length(JSON.decode!(conn.resp_body)) == 0
  end

  test "GET [/events] returns list with one item -> 200" do
    conn =
      conn(:post, "/events", JSON.encode!(@test_event))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    conn = conn(:get, "/events") |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert length(JSON.decode!(conn.resp_body)) == 1
  end

  test "POST [/events] invalid fields -> 400" do
    body = JSON.encode!(%{year: "2000", foo: "bar"})

    conn =
      conn(:post, "/events", body)
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "POST [/events] OK -> 200" do
    conn =
      conn(:post, "/events", JSON.encode!(@test_event))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert resp["name"] == @test_event.name
    assert Map.has_key?(resp, "id")
  end

  test "GET [/events/:id] OK -> 200" do
    conn =
      conn(:post, "/events", JSON.encode!(@test_event))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/events/#{id}"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 200

    answer_get = JSON.decode!(conn.resp_body)
    assert id == answer_get["id"]
    assert answer_get["name"] == resp["name"]
  end

  test "GET [/events/:id] Not found -> 404" do
    path = "/events/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE [/events/:id] OK -> 204" do
    conn =
      conn(:post, "/events", JSON.encode!(@test_event))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/events/#{id}"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE [/events/:id] Not found -> 404" do
    path = "/events/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "PUT [/events/:id] Change name -> 200" do
    conn =
      conn(:post, "/events", JSON.encode!(@test_event))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert Map.has_key?(resp, "id")

    upd_body = %{"name" => "Elixir Meetup"}
    path = "/events/#{resp["id"]}"

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

  test "PUT [/events/:id] Event not found -> 404" do
    body = %{"name" => "Elixir Meetup"}
    path = "/events/43391d68-f529-43df-9974-c381d5f14060"

    conn =
      conn(:put, path, JSON.encode!(body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
