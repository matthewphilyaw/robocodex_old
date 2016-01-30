defmodule Robocodex.GameChannel do
  use Robocodex.Web, :channel

  alias Robocodex.Arena
  alias Robocodex.Robot

  def join("games:lobby", _payload, socket) do

    arena = %Arena{height: 600, width: 600}
    tank = Robot.new(30, 30) |> Robot.set_velocity({8, :math.pi / 3})

    {:ok, pid} = Agent.start_link fn -> %{arena: arena, tank: tank} end

    :timer.send_interval(trunc(1000/60), {:run_tick, pid})
    {:ok, socket}
  end


  def handle_info({:run_tick, pid}, socket) do
    %{arena: arena, tank: tank} = Agent.get pid, fn state -> state end

    {speed, bearing} = tank.velocity

    next_tank = Robot.move tank

    tank = case Arena.hit_wall(next_tank, arena) do
      # sim reflection but don't apply move
      true -> tank |> Robot.set_velocity({speed, bearing - :math.pi / 4})
      false -> next_tank # take the next move
    end

    broadcast! socket, "frame", %{ :bots => [
        %{x: tank.center.x,
          y: tank.center.y,
          name: "test"}
      ]
    }

    Agent.update pid, fn state -> %{state | tank: tank} end

    {:noreply, socket}
  end
end
