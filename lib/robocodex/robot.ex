defmodule Robocodex.Robot do
  defstruct center: nil, radius: nil, velocity: nil

  alias Robocodex.Robot
  alias Robocodex.Point

  def new(x,y) do
    %Robot{center: %Robocodex.Point{x: x, y: y}, radius: 20}
  end

  def set_velocity(rb = %Robot{}, vel) do
    %{rb | velocity: vel}
  end

  def move(rb = %Robot{velocity: nil}) do
    rb
  end

  def move(rb = %Robot{}) do
    {speed, bearing} = rb.velocity
    x = rb.center.x + (speed * :math.cos(bearing))
    y = rb.center.y + (speed * :math.sin(bearing))

    %{rb | center: %Point{x: x, y: y}}
  end
end
