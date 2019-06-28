defmodule Metronomex.Worker do
  use GenServer

  @exchange "metronomex"
  @queue "metronomex_ticket"

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # GenServer implementation

  def init([]) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, @queue)
    AMQP.Exchange.declare(channel, @exchange)
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
end
