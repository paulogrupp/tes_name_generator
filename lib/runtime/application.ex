defmodule TesNameGenerator.Runtime.Application do
  use Application

  def start(_type, _args) do
    children = [{TesNameGenerator.Runtime.Server, []}]

    options = [
      name: TesNameGenerator.Runtime.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, options)
  end
end
