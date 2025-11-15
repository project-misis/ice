defmodule Ice.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Ice.Router, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Ice.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
