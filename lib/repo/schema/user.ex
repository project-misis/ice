defmodule Repo.User do
  use Ash.Resource,
    domain: Repo.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshJason.Resource]

  import Utils.Argon

  actions do
    defaults([:read, :destroy, :update])

    create :create do
      change fn changeset, _ ->
        pwd = Ash.Changeset.get_attribute(changeset, :password)
        if pwd do
          Ash.Changeset.change_attribute(changeset, :password, encode_pwd(pwd))
        else
          changeset
        end
      end

    end
    read :login do
      get? true
      argument :email, :string, allow_nil?: false
      argument :pwd, :string, allow_nil?: false

      filter expr(email == ^arg(:email) and verify_pwd(^arg(:pwd), password))
    end

    default_accept([:first_name, :last_name, :email, :telegram, :role, :password, :pfp])
  end

  attributes do
    uuid_primary_key(:id)

    attribute :first_name, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :last_name, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :email, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :telegram, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :password, :string do
      allow_nil?(false)
      public?(false)
    end

    attribute :pfp, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :role, :atom do
      default(:normie)
      public?(true)
      constraints(one_of: [:mentor, :normie])
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
