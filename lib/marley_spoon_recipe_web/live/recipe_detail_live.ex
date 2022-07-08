defmodule MarleySpoonRecipeWeb.RecipeDetailLive do
  use MarleySpoonRecipeWeb, :live_view
  alias MarleySpoonRecipe.Recipe
  import Phoenix.HTML

  def mount(%{"id" => id}, _session, socket) do
    recipe = Recipe.get_recipe_detail(id)
    {:ok, assign(socket, recipe: recipe)}
  end

  def render(assigns) do
    ~H"""
      <h1> Recipe Detail </h1>

      <b> Title </b> <br>
      <%= @recipe.title %>
      <br>

      <b> Description </b> <br>
      <%= raw(@recipe.description) %>
      <br>

      <b> Photo </b> <br>
      <img src={@recipe.photo["fields"]["file"]["url"]} />
      <br>

      <b> Tags </b> <br>

      <%= for tag <- @recipe.tags || [] do %>
        <%= tag["fields"]["name"] %>,
      <% end %>
    """
  end
end
