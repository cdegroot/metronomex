defmodule Metronomex.Worker do
  use GenServer

  @exchange "metronomex"
  @queue "metronomex_ticket"

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # GenServer implementation

  def init([]) do
    {:ok, connection} = amqp_connect_direct()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, @queue)
    AMQP.Exchange.declare(channel, @exchange, :topic)
    AMQP.Queue.bind(channel, @queue, @exchange)
    fire()
    {:ok, %{channel: channel, exchange: @exchange}}
  end

  def handle_cast(:fire, state = %{channel: channel, exchange: exchange}) do
    AMQP.Basic.publish(channel, exchange, "", "Tick!")
    :timer.apply_after(1000, __MODULE__, :fire, [])
    {:noreply, state}
  end

  def fire() do
    GenServer.cast(__MODULE__, :fire)
  end

  # The Elixir AMQP library does not support a direct (in-VM) connection. This
  # does a direct connection and returns an AMQP library compatible connection.
  defp amqp_connect_direct() do
    import AMQP.Core
    {:ok, pid} = :amqp_connection.start(amqp_params_direct())
    {:ok, %AMQP.Connection{pid: pid}}
  end
end
