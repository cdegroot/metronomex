defmodule Metronomex.Application do
  use Application

  def start(_type, _args) do
    Supervisor.start_link([{Metronomex.Worker, []}], strategy: :one_for_one, name: Metronomex.Supervisor)
  end
end
