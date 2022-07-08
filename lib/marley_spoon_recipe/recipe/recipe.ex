defmodule MarleySpoonRecipe.Recipe do

  def get_all_entries() do
    url = "#{base_url()}/spaces/#{space_id()}/environments/#{environment()}/entries?#{tail_url()}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        recipes =
          body
          |> Jason.decode!
          |> Map.get("items")
          |> Enum.filter(fn item -> get_in(item, ["sys", "contentType", "sys", "id"]) == "recipe" end)

        IO.inspect recipes
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def get_recipe_detail(id) do
    "#{base_url()}/spaces/#{space_id()}/environments/#{environment()}/entries/#{id}?#{tail_url()}"
    |> http_request
    |> get_nested_data
  end

  def link_type("Entry", id) do
    "#{base_url()}/spaces/#{space_id()}/environments/#{environment()}/entries/#{id}?#{tail_url()}"
    |> http_request
  end

  def link_type("Asset", id) do
    "#{base_url()}/spaces/#{space_id()}/environments/#{environment()}/assets/#{id}?#{tail_url()}"
    |> http_request
  end


  # Private
  defp get_nested_data(recipe) do
    %{
      description: get_in(recipe, ["fields", "description"]),
      title: get_in(recipe, ["fields", "title"]),
      photo: get_in(recipe, ["fields", "photo", "sys"]),
      tags: get_in(recipe, ["fields", "tags"])
    }
    |> Enum.map(fn {k, lt} -> {k, Task.async(fn -> get_record_by_link_type(lt) end)} end)
    |> Enum.map(fn {k, lt} -> {k, Task.await(lt)} end)
    |> Enum.into(%{})
  end

  defp http_request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Result Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
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

  defp base_url(), do: "https://cdn.contentful.com"
  defp tail_url(), do: "access_token=7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c"
  defp space_id(), do: "kk2bw5ojx476"
  defp environment(), do: "master"
end
