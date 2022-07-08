defmodule MarleySpoonRecipe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MarleySpoonRecipeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MarleySpoonRecipe.PubSub},
      # Start the Endpoint (http/https)
      MarleySpoonRecipeWeb.Endpoint
      # Start a worker by calling: MarleySpoonRecipe.Worker.start_link(arg)
      # {MarleySpoonRecipe.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarleySpoonRecipe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarleySpoonRecipeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
