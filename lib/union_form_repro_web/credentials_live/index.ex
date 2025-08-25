defmodule UnionFormReproWeb.CredentialsLive.Index do
  use UnionFormReproWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Credentials
        <:actions>
          <.button variant="primary" navigate={~p"/credentials/new"}>
            <.icon name="hero-plus" /> New Credentials
          </.button>
        </:actions>
      </.header>

      <.table
        id="credentials"
        rows={@streams.credentials}
        row_click={fn {_id, credentials} -> JS.navigate(~p"/credentials/#{credentials}") end}
      >
        <:col :let={{_id, credentials}} label="Id">{credentials.id}</:col>

        <:col :let={{_id, credentials}} label="Access">{credentials.access}</:col>

        <:action :let={{_id, credentials}}>
          <div class="sr-only">
            <.link navigate={~p"/credentials/#{credentials}"}>Show</.link>
          </div>

          <.link navigate={~p"/credentials/#{credentials}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, credentials}}>
          <.link
            phx-click={JS.push("delete", value: %{id: credentials.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Credentials")
     |> stream(:credentials, Ash.read!(UnionFormRepro.Services.Credentials))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    credentials = Ash.get!(UnionFormRepro.Services.Credentials, id)
    Ash.destroy!(credentials)

    {:noreply, stream_delete(socket, :credentials, credentials)}
  end
end
