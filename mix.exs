defmodule ExLearn.Mixfile do
  use Mix.Project

  def project do
    [
      app:               :ExLearn,
      version:           "0.1.0",
      elixir:            "1.3.2",
      build_embedded:    Mix.env == :prod,
      start_permanent:   Mix.env == :prod,
      deps:              deps,
      dialyzer: [
        flags: [
          "-Wno_return",
          "-Wno_unused",
          "-Wno_improper_lists",
          "-Wno_fun_app",
          "-Wno_match",
          "-Wno_opaque",
          "-Wno_fail_call",
          "-Wno_contracts",
          "-Wno_behaviours",
          "-Wno_missing_calls",
          "-Wno_undefined_callbacks",
          "-Wunmatched_returns",
          "-Werror_handling",
          "-Wrace_conditions",
          "-Wunderspecs",
          "-Wunknown",
          "-Woverspecs",
          "-Wspecdiffs"
        ]
      ],
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls":        :test,
        "coveralls.html":   :test,
        "coveralls.travis": :test
      ]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchfella,  "0.3.2", only: :dev },
      {:dialyxir,    "0.3.5", only: :dev },
      {:excoveralls, "0.5.5", only: :test}
    ]
  end
end
