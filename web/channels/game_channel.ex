defmodule Robocodex.GameChannel do
  use Robocodex.Web, :channel

  alias Robocodex.Arena
  alias Robocodex.Robot
  
  require Logger

  def join("games:lobby", _payload, socket) do

    arena = %Arena{height: 600, width: 600}
    tank = Robot.create(100, 30) 
    |> Robot.set_heading_angle(-(:math.pi / 4))
    |> Robot.set_speed(8)

    {:ok, pid} = Agent.start_link fn -> %{arena: arena, tank: tank} end

    :timer.send_interval(trunc(1000/30), {:run_tick, pid})
    {:ok, socket}
  end


  def handle_info({:run_tick, pid}, socket) do
    %{arena: arena, tank: tank} = Agent.get pid, fn state -> state end

    next_tank = Robot.move tank

    tank = case Arena.hit_wall(next_tank, arena) do
      # sim reflection but don't apply move
      # very temporary
      true ->
        angle = Robot.get_heading_angle(tank)
        Robot.set_heading_angle(tank, :math.pi)
      false -> next_tank # take the next move
    end

    {x, y} = tank.position
    Logger.debug "n tank #{inspect(next_tank)}"
    Logger.debug "c tank #{inspect(tank)}"
    broadcast! socket, "frame", %{ :bots => [
        %{x: x,
          y: y,
          name: "test"}
      ]
    }

    Agent.update pid, fn state -> %{state | tank: tank} end

    {:noreply, socket}
  end
end
