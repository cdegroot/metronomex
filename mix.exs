defmodule Metronomex.MixProject do
  use Mix.Project

  def project do
    [
      app: :metronomex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Metronomex.Application, []},
      extra_applications: [:rabbit, :rabbit_common]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      #{:rabbit_common, "~> 3.7"}
      {:amqp, "~> 1.2"}
    ]
  end
end
