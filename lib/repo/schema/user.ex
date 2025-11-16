defmodule Repo.User do
  use Ash.Resource,
    domain: Repo.Domain,
    data_layer: Ash.DataLayer.Ets,
    extensions: [AshJason.Resource]

  actions do
    defaults([:read, :destroy, :create, :update])

    default_accept([:first_name, :last_name, :email, :telegram, :role, :password, :pfp])

    # update :become_mentor do
    #   accept([])
    #
    #   validate attribute_does_not_equal(:role, :mentor) do
    #     message("Account is already a mentor")
    #   end
    #
    #   change(set_attribute(:role, :mentor))
    # end
    #
    # update :become_normie do
    #   accept([])
    #
    #   validate attribute_does_not_equal(:role, :normie) do
    #     message("Account is already a normie")
    #   end
    #
    #   change(set_attribute(:role, :normie))
    # end
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
      public?(false)
    end

    attribute :role, :atom do
      default(:normie)
      public?(true)
      constraints(one_of: [:mentor, :normie])
    end
  end

  # identities do
  #   identity :unique_email, [:email]
  # end
end
