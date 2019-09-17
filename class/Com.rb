#this is an object i use to easily keep track of x and y vectors instead of making 2 variables i just make one object
class Pos
  #this allows read and writes of the x and y
  attr_accessor :x, :y
  #this defines the vector of x and y
  def initialize(x,y)
    @x = x
    @y = y
  end
end

#this is the circular lerping function
#it calculates the shortest path to get between two points on a circle and then divides that into equal rotations over time
class CircleLerp

  def initialize(start, stop, time)
    @start = start
    @stop = stop
    @time = time
  end

  def calculate()
    delta = @stop - @start

    if 360-delta.abs < delta.abs
      if 360-delta > 360
        direction = 1
      else
        direction = -1
      end
      delta = (360-delta.abs)*direction
    end

    step = delta/@time
    return step

  end
end
