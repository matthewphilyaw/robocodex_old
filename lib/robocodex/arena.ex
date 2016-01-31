defmodule Robocodex.Arena do
  defstruct height: 0, width: 0, game_objects: []

  alias Robocodex.Robot
  alias Robocodex.Arena

  def hit_wall(rb = %Robot{}, a = %Arena{}) do
    {x, y} = rb.position
    r = rb.bounding_radius
    cond do
      x - r <= 1 -> true
      y - r <= 1 -> true
      x + r >= a.width - 1 -> true
      y + r >= a.height - 1 -> true
      true -> false
    end
  end
end
