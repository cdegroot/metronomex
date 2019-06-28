defmodule Metronomex.Worker do
  use GenServer

  @exchange "metronomex"
  @queue "metronomex_ticker"

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
    {date = {year, month, day}, {hour, min, sec}} = :erlang.universaltime()
    day_of_week = :calendar.day_of_the_week(date)
    routing_key = message = "#{year}.#{month}.#{day}.#{day_of_week}.#{hour}.#{min}.#{sec}"
    AMQP.Basic.publish(channel, exchange, routing_key, message)
    :timer.apply_after(1000, __MODULE__, :fire, [])
    {:noreply, state}
  end

  def fire() do
    GenServer.cast(__MODULE__, :fire)
  end

  # The Elixir AMQP library does not support a direct (in-VM) connection. This
  # does a direct connection and returns an AMQP library compatible connection.
  # We only do a direct connection if RabbitMQ is already running.
  defp amqp_connect_direct() do
    in_rabbitmq_vm = Application.started_applications()
    |> Enum.map(fn {n, _d, _v} -> n end)
    |> Enum.member?(:rabbit)

    amqp_connect_direct(in_rabbitmq_vm)
  end

  defp amqp_connect_direct(true) do
    import AMQP.Core
    {:ok, pid} = :amqp_connection.start(amqp_params_direct(node: node()))
    {:ok, %AMQP.Connection{pid: pid}}
  end

  defp amqp_connect_direct(false) do
    AMQP.Connection.open()
  end
end
