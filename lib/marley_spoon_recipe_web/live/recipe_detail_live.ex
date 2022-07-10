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

      <%= live_patch to: Routes.recipes_path(@socket, :index)  do %>
        <p style="font-size: 150%; cursor: pointer;">&larr;</p>
      <% end %>

      <b> Title </b> <br>
      <%= if @recipe.title do %>
        <%= @recipe.title %>
      <% else %>
        No description
      <% end %>
      <br>
      <br>

      <b> Description </b> <br>
      <%= if @recipe.description do %>
        <%= raw(Earmark.as_html!(@recipe.description)) %>
      <% else %>
        No description
      <% end %>
      <br>
      <br>

      <b> Chef </b> <br>
      <%= if @recipe.chef["fields"]["name"] do %>
        <%= @recipe.chef["fields"]["name"] %>
      <% else %>
        No Chef details
      <% end %>
      <br>
      <br>

      <b> Photo </b> <br>
      <img src={@recipe.photo["fields"]["file"]["url"]} />
      <br>
      <br>

      <b> Tags </b> <br>
      <%= if length(@recipe.tags || []) > 0 do %>
        <%= for tag <- @recipe.tags || [] do %>
          <%= tag["fields"]["name"] %>,
        <% end %>
      <% else %>
        No tags
      <% end %>
    """
  end
end
