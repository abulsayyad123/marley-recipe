defmodule MarleySpoonRecipeWeb.RecipesLive do
  use MarleySpoonRecipeWeb, :live_view
  alias MarleySpoonRecipe.Recipe
  alias MarleySpoonRecipeWeb.RecipeDetailLive

  def mount(_params, _session, socket) do
    recipes = Recipe.get_all_entries()

    ids = Enum.map(recipes, fn res -> get_in(res, ["sys","id"]) end)
    titles = Enum.map(recipes, fn res -> get_in(res, ["fields","title"]) end)
    images = Enum.map(recipes, fn res -> get_in(res, ["fields","photo","sys","id"]) end)
        |> Enum.map(fn(lt) -> Task.async(fn -> MarleySpoonRecipe.Recipe.link_type("Asset", lt) end) end)
        |> Enum.map(&Task.await/1)
        |> Enum.map(fn photo -> get_in(photo, ["fields", "file", "url"]) end)

    tuple = Enum.zip(titles, images) |> Enum.zip(ids)
    socket = assign(socket, recipes: recipes, tuple: tuple)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      Recipes
      <table>
        <thead>
          <tr>
            <th>
              Title
            </th>
            <th>
              Photo
            </th>
            <th></th>
          </tr>
        </thead>

        <tbody>
          <%= for {{title, image}, id} <- @tuple do %>
            <tr>
              <td><%= title %></td>
              <td><img src={image} /></td>
              <td>
                <%= live_patch to: Routes.live_path(@socket, RecipeDetailLive, id) do %>
                  View
                <% end %>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    """
  end
end
