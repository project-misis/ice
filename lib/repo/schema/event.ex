defmodule Repo.Event do
  use Ash.Resource,
    domain: Repo.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshJason.Resource]

  actions do
    defaults([:read, :destroy, :create, :update])
    default_accept([:name, :where, :link, :desc, :start, :end])
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :where, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :link, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :desc, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :start, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :end, :string do
      allow_nil?(false)
      public?(true)
    end
  end
end
