defmodule UnionFormReproWeb.CredentialsLive.Show do
  use UnionFormReproWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Credentials {@credentials.id}
        <:subtitle>This is a credentials record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/credentials"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/credentials/#{@credentials}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Credentials
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@credentials.id}</:item>

        <:item title="Access">{@credentials.access}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Credentials")
     |> assign(:credentials, Ash.get!(UnionFormRepro.Services.Credentials, id))}
  end
end
