defmodule DemoRocksdb.MixProject do
  use Mix.Project

  def project do
    [
      app: :demo_rocksdb,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DemoRocksdb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rocksdb, "~> 1.6"},
      {:sext, "~> 1.8"},
    ]
  end
end
