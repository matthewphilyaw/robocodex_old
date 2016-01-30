defmodule Robocodex.Arena do
  defstruct height: 0, width: 0, game_objects: []

  alias Robocodex.Robot
  alias Robocodex.Arena

  def hit_wall(rb = %Robot{}, a = %Arena{}) do
    cond do
      rb.center.x - rb.radius <= 0 -> true
      rb.center.y - rb.radius <= 0 -> true
      rb.center.x + rb.radius >= a.width -> true
      rb.center.y + rb.radius >= a.height -> true
      true -> false
    end
  end
end
