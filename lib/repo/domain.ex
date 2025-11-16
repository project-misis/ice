defmodule Repo.Domain do
  use Ash.Domain
  require Ash.Query

  resources do
    resource(Repo.User)
    resource(Repo.Book)
    resource(Repo.Event)
  end

  @user Repo.User
  @book Repo.Book
  @event Repo.Event

  def list_users do
    Ash.read(@user)
  end

  def get_user(user_id) do
    @user
    |> Ash.Query.filter(id: user_id)
    |> Ash.read()
  end

  def create_user(attrs) do
    @user
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create()
  end

  def update_user(user_id, attrs) do
    with {:ok, user} <- @user |> Ash.get(user_id),
         {:ok, user} <-
           user
           |> Ash.Changeset.for_update(:update, attrs)
           |> Ash.update() do
      {:ok, user}
    end
  end

  def delete_user(user_id) do
    with {:ok, user} <- @user |> Ash.get(user_id),
         :ok <-
           user
           |> Ash.destroy() do
      :ok
    end
  end

  def list_books do
    Ash.read(@book)
  end

  def get_book(book_id) do
    @book
    |> Ash.get(book_id)
  end

  def create_book(attrs) do
    @book
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create()
  end

  def update_book(book_id, attrs) do
    with {:ok, book} <- @book |> Ash.get(book_id),
         {:ok, book} <-
           book
           |> Ash.Changeset.for_update(:update, attrs)
           |> Ash.update() do
      {:ok, book}
    end
  end

  def delete_book(book_id) do
    with {:ok, book} <- @book |> Ash.get(book_id),
         :ok <- Ash.destroy(book) do
      :ok
    end
  end

  def list_events do
    Ash.read(@event)
  end

  def get_event(event_id) do
    @event
    |> Ash.get(event_id)
  end

  def create_event(attrs) do
    @event
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create()
  end

  def update_event(event_id, attrs) do
    with {:ok, event} <- @event |> Ash.get(event_id),
         {:ok, event} <-
           event
           |> Ash.Changeset.for_update(:update, attrs)
           |> Ash.update() do
      {:ok, event}
    end
  end

  def delete_event(event_id) do
    with {:ok, event} <- @event |> Ash.get(event_id),
         :ok <- Ash.destroy(event) do
      :ok
    end
  end
end
