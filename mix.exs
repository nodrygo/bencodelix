defmodule Bencodelix.Mixfile do
  use Mix.Project

  def project do
    [ app: :bencodelix,
      version: "0.0.2",
      elixir: "> 0.10.3",
      deps: deps ]
  end

  # Configuration for the OTP application
  # def application do
  #   [mod: { Bencodelix, [] }]
  # end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
  
end
