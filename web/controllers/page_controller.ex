defmodule Robocodex.PageController do
  use Robocodex.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
