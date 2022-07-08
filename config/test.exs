import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :marley_spoon_recipe, MarleySpoonRecipeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "s4JLqs/XWL3iS6RV9jH5VkpiLiiaHDsgDyWJKF8r4XGogrlCZ1vGIMtV/UbrqaFw",
  server: false

# In test we don't send emails.
config :marley_spoon_recipe, MarleySpoonRecipe.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
