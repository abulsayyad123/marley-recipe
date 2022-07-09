defmodule MarleySpoonRecipe.ApiHelper do

  @space_id "kk2bw5ojx476"
  @env "master"
  @base_url "https://cdn.contentful.com/spaces/#{@space_id}/environments/#{@env}/"
  @tail_url "?access_token=7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c"

  def get_single_record(resource, id) do
    "#{resource}/#{id}"
    |> http_request()
  end

  def all_records(resource) do
    http_request(resource)
  end

  # Private
  defp http_request(endpoint) do
    url = @base_url <> endpoint <> @tail_url
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %{status: 404, message: "Remote Not Found"}
      {:ok, %HTTPoison.Response{status_code: 500}} ->
        %{status: 500, message: "Remote Server Error"}
      {:error, %HTTPoison.Error{}} ->
        %{status: 500, message: "Remote Server Error"}
    end
  end
end
