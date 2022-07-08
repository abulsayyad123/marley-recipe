defmodule MarleySpoonRecipeWeb.PageController do
  use MarleySpoonRecipeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
