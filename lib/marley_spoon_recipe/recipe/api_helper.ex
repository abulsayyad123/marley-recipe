defmodule MarleySpoonRecipe.ApiHelper do

  @base_url "https://cdn.contentful.com"
  @tail_url "?access_token=7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c"
  @space_id "kk2bw5ojx476"
  @env "master"

  def http_request(endpoint) do
    url = @base_url <> endpoint <> @tail_url
    IO.puts url
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

  def get_assets(id) do
    "/spaces/#{@space_id}/environments/#{@env}/assets/#{id}"
    |> http_request()
  end
end
