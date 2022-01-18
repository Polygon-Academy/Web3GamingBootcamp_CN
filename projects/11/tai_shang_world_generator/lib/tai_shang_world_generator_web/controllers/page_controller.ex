defmodule TaiShangWorldGeneratorWeb.PageController do
  use TaiShangWorldGeneratorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
