defmodule UserTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  @test_user %{
    first_name: "Sam",
    last_name: "Hyde",
    email: "pepe@snl.com",
    role: "mentor",
    telegram: "@snl",
    password: "nihao"
  }

  @opts Ice.Router.init([])

  setup do
    table = Ash.DataLayer.Ets.Info.table(Accounts.Schema.User)

    case :ets.info(table) do
      :undefined ->
        :ok

      _ ->
        :ets.delete_all_objects(table)
        :ok
    end
  end

  test "GET [/users/many] returns empty list -> 200" do
    conn = conn(:get, "/users/many")

    conn = Ice.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert JSON.decode(conn.resp_body) == {:ok, []}
  end

  test "POST [/users/create] invalid fields -> 400" do
    body = JSON.encode!(%{year: "200", role: "mentor"})

    conn =
      conn(:post, "/users/create", body)
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  test "POST [/users/create] OK -> 200" do
    conn =
      conn(:post, "/users/create", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert resp["first_name"] == "Sam"
    assert not Map.has_key?(resp, "password")
  end

  test "GET [/users/one] OK -> 200" do
    conn =
      conn(:post, "/users/create", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/users/one/#{id}"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 200
    answer_get = JSON.decode!(conn.resp_body)
    assert id == answer_get["id"]
    assert answer_get["name"] == resp["name"]
  end

  test "GET [/users/one] Not found -> 404" do
    path = "/users/one/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE [/users/delete] OK -> 204" do
    conn =
      conn(:post, "/users/create", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/users/delete/#{id}"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE [/users/delete] Not found -> 404" do
    path = "/users/delete/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "PUT [/users/update] Change email -> 200" do
    conn =
      conn(:post, "/users/create", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert Map.has_key?(resp, "id")

    upd_body = %{"first_name" => "John"}
    path = "/users/update/#{resp["id"]}"

    conn =
      conn(:put, path, JSON.encode!(upd_body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    put_resp = JSON.decode!(conn.resp_body)

    assert put_resp["first_name"] == upd_body["first_name"]
    assert put_resp["id"] == resp["id"]
  end

  test "PUT [/users/update] User not found -> 404" do
    body = %{"first_name" => "John"}
    path = "/users/update/43391d68-f529-43df-9974-c381d5f14060"

    conn =
      conn(:put, path, JSON.encode!(body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
