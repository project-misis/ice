defmodule Test.User do
  use ExUnit.Case, async: false
  import Plug.Test
  import Plug.Conn

  @test_user %{
    first_name: "Sam",
    last_name: "Hyde",
    email: "pepe@snl.com",
    role: "mentor",
    telegram: "@snl",
    password: "nihao",
    pfp: "https://extremepeace.com/image.jpg"
  }

  @opts Ice.Router.init([])

  setup do
    table = Ash.DataLayer.Ets.Info.table(Repo.User)

    case :ets.info(table) do
      :undefined ->
        :ok

      _ ->
        :ets.delete_all_objects(table)
        :ok
    end
  end

  test "GET [/users] returns empty list -> 200" do
    conn = conn(:get, "/users")

    conn = Ice.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert length(JSON.decode!(conn.resp_body)) == 0
  end

  test "GET [/users] returns list with one item -> 200" do
    conn =
      conn(:post, "/users", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    conn = conn(:get, "/users") |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    assert length(JSON.decode!(conn.resp_body)) == 1
  end

  test "POST [/users] invalid fields -> 400" do
    body = JSON.encode!(%{year: "200", role: "mentor"})

    conn =
      conn(:post, "/users", body)
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 400
  end

  # TODO: maybe someday we gonna move to postgres... but not today ^.^

  # test "POST [/users] unique email violation -> 400" do
  #   conn =
  #     conn(:post, "/users", JSON.encode!(@test_user))
  #     |> put_req_header("content-type", "application/json")
  #     |> Ice.Router.call(@opts)
  #
  #   assert conn.state == :sent
  #   assert conn.status == 200
  #
  #   conn =
  #     conn(:post, "/users", JSON.encode!(@test_user))
  #     |> put_req_header("content-type", "application/json")
  #     |> Ice.Router.call(@opts)
  #
  #   assert conn.state == :sent
  #   assert conn.status == 400
  # end

  test "POST [/users] OK -> 200" do
    conn =
      conn(:post, "/users", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert resp["first_name"] == "Sam"
    assert not Map.has_key?(resp, "password")
  end

  test "GET [/users] OK -> 200" do
    conn =
      conn(:post, "/users", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/users/#{id}"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 200
    answer_get = JSON.decode!(conn.resp_body)
    assert id == answer_get["id"]
    assert answer_get["name"] == resp["name"]
  end

  test "GET [/users] Not found -> 404" do
    path = "/users/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:get, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "DELETE [/users] OK -> 204" do
    conn =
      conn(:post, "/users", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    id = resp["id"]

    path = "/users/#{id}"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 204
  end

  test "DELETE [/users] Not found -> 404" do
    path = "/users/fae3a9c4-be81-48bf-b527-d0006628a3bd"

    conn = conn(:delete, path) |> Ice.Router.call(@opts)
    assert conn.state == :sent
    assert conn.status == 404
  end

  test "PUT [/users] Change email -> 200" do
    conn =
      conn(:post, "/users", JSON.encode!(@test_user))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    resp = JSON.decode!(conn.resp_body)
    assert Map.has_key?(resp, "id")

    upd_body = %{"first_name" => "John"}
    path = "/users/#{resp["id"]}"

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

  test "PUT [/users] User not found -> 404" do
    body = %{"first_name" => "John"}
    path = "/users/43391d68-f529-43df-9974-c381d5f14060"

    conn =
      conn(:put, path, JSON.encode!(body))
      |> put_req_header("content-type", "application/json")
      |> Ice.Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
