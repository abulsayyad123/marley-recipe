defmodule MarleySpoonRecipeWeb.RecipesLive do
  use MarleySpoonRecipeWeb, :live_view
  alias MarleySpoonRecipe.Recipe
  alias MarleySpoonRecipeWeb.RecipeDetailLive

  def mount(_params, _session, socket) do
    recipes = Recipe.get_all_recipes()
    {:ok, assign(socket, recipes: recipes)}
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
          <%= for {{title, image}, id} <- @recipes do %>
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
