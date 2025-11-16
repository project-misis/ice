defmodule Repo.Book do
  use Ash.Resource,
    domain: Repo.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshJason.Resource]

  actions do
    defaults([:read, :destroy, :create, :update])

    default_accept([:name, :author, :language, :link])
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :author, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :language, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :link, :string do
      allow_nil?(false)
      public?(true)
    end
  end
end
