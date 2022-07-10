defmodule MarleySpoonRecipe.Recipe do
  alias MarleySpoonRecipe.ApiHelper

  def get_all_recipes() do
    ApiHelper.all_records("entries")
    |> Map.get("items")
    |> Enum.filter(fn item -> get_in(item, ["sys", "contentType", "sys", "id"]) == "recipe" end)
    |> get_recipe_list_map
  end

  def get_recipe_detail(id) do
    ApiHelper.get_single_record("entries", id)
    |> get_fields_record
  end

  # Private
  def link_type("Entry", id) do
    ApiHelper.get_single_record("entries", id)
  end

  def link_type("Asset", id) do
    ApiHelper.get_single_record("assets", id)
  end

  defp get_recipe_list_map(recipes) do
    Enum.map(recipes, fn res ->
      %{
        id: get_in(res, ["sys","id"]),
        title: get_in(res, ["fields","title"]),
        photo: Task.async(fn -> link_type("Asset", get_in(res, ["fields","photo","sys","id"])) end)
      }
    end)
    |> Enum.map(fn lt ->
      photo = Task.await(lt.photo)
      Map.put(lt, :photo, get_in(photo, ["fields", "file", "url"]))
    end)
  end

  defp get_fields_record(recipe) do
    %{
      description: get_in(recipe, ["fields", "description"]),
      title: get_in(recipe, ["fields", "title"]),
      photo: get_in(recipe, ["fields", "photo", "sys"]),
      tags: get_in(recipe, ["fields", "tags"]),
      chef: get_in(recipe, ["fields", "chef", "sys"])
    }
    |> Map.new(fn {k, lt} -> {k, Task.async(fn -> get_record_by_link_type(lt) end)} end)
    |> Map.new(fn {k, lt} -> {k, Task.await(lt)} end)
  end

  defp get_record_by_link_type(linkType) when is_map(linkType) do
    link_type(linkType["linkType"], linkType["id"])
  end

  defp get_record_by_link_type(linkType) when is_list(linkType) do
    linkType
    |> Enum.map(fn(lt) ->
      Task.async(fn ->
        link_type(lt["sys"]["linkType"], lt["sys"]["id"])
      end)
     end)
    |> Enum.map(&Task.await/1)
  end

  defp get_record_by_link_type(linkType) when is_nil(linkType), do: linkType

  defp get_record_by_link_type(linkType) when is_binary(linkType), do: linkType
end
