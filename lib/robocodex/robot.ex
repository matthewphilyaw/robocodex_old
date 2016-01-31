defmodule Robocodex.Robot do
  defstruct position: nil, heading: nil, speed: 0, bounding_radius: nil

  alias Robocodex.Robot
  alias Graphmath.Vec2

  @bounding_radius 20

  def create(x,y) do
    %Robot{
      position: Vec2.create(x,y),
      # positive y I dont know had to choose something.. *shrugs*
      heading: Vec2.create(0,1),
      bounding_radius: @bounding_radius
    }
  end

  def set_heading_angle(rb = %Robot{}, angle) do
    %{rb | heading: Vec2.rotate(rb.heading, angle)}
  end

  def get_heading_angle(rb = %Robot{}) do
    {x, y} = rb.heading
    :math.atan2(y, x)
  end

  def set_speed(rb = %Robot{}, speed) do
    %{rb | speed: speed}
  end

  def move(rb = %Robot{}) do
    vel_vec = Vec2.scale rb.heading, rb.speed

    %{rb | position: Vec2.add(rb.position, vel_vec)}
  end
end
