defmodule Ddog.MixProject do
  use Mix.Project

  def project do
    [
      app: :ddog,
      name: "Ddog",
      source_url: "https://github.com/lenfree/ddog",
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Unofficial package to manage Datadog monitors.",
      package: package()
    ]
  end

  defp package do
    [
      maintainers: ["Lenfree Yeung"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lenfree/ddog"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.19", only: :dev},
      {:earmark, "~> 1.3", only: :dev},
      {:stream_data, "~> 0.4.3", only: :test},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end
end
