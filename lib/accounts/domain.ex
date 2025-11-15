defmodule Accounts.Domain do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource(Accounts.Schema.User)
  end
end
