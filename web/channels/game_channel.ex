defmodule Robocodex.GameChannel do
  use Robocodex.Web, :channel

  def join("games:lobby", _payload, socket) do

    bots = build_bots
    {:ok, pid} = Agent.start_link fn -> bots end

    :timer.send_interval(500, {:run_tick, pid})
    {:ok, socket}
  end


  def handle_info({:run_tick, pid}, socket) do
    bots = Agent.get pid, fn state -> state end
    broadcast! socket, "frame", %{ :bots => bots }

    bots = move_bots bots
    Agent.update pid, fn _ -> bots end

    {:noreply, socket}
  end

  def build_bots do
    [
      %{x: 10, y: 10, name: "b1"},
      %{x: 60, y: 30, name: "b2"},
      %{x: 140, y: 40, name: "b2"}
    ]
  end

  def move_bots(bots) do
    Enum.map bots, fn b = %{x: x, y: y} ->
      %{ b | x: x + 10, y: y + 10 }
    end
  end
end
