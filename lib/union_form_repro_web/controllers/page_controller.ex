defmodule UnionFormReproWeb.PageController do
  use UnionFormReproWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
