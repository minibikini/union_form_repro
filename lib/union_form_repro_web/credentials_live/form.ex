defmodule UnionFormReproWeb.CredentialsLive.Form do
  use UnionFormReproWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage credentials records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="credentials-form"
        phx-change="validate"
        phx-submit="save"
      >
        <.inputs_for :let={form_access} field={@form[:access]}>
          <.input type="text" label="API Key" field={form_access[:api_key]} />
        </.inputs_for>

        <.button phx-disable-with="Saving..." variant="primary">Save Credentials</.button>
        <.button navigate={return_path(@return_to, @credentials)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    credentials =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(UnionFormRepro.Services.Credentials, id)
      end

    action = if is_nil(credentials), do: "New", else: "Edit"
    page_title = action <> " " <> "Credentials"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(credentials: credentials)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"credentials" => credentials_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, credentials_params))}
  end

  def handle_event("save", %{"credentials" => credentials_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: credentials_params) do
      {:ok, credentials} ->
        notify_parent({:saved, credentials})

        socket =
          socket
          |> put_flash(:info, "Credentials #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, credentials))

        {:noreply, socket}

      {:error, form} ->
        IO.inspect(form)
        IO.inspect(AshPhoenix.Form.raw_errors(form))
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{credentials: credentials}} = socket) do
    form =
      if credentials do
        AshPhoenix.Form.for_update(credentials, :update, as: "credentials")
      else
        AshPhoenix.Form.for_create(UnionFormRepro.Services.Credentials, :create,
          as: "credentials"
        )
        |> AshPhoenix.Form.add_form(:access,
          params: %{"_union_type" => "xyz"}
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _credentials), do: ~p"/credentials"
  defp return_path("show", credentials), do: ~p"/credentials/#{credentials.id}"
end
