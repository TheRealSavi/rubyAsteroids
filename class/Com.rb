#this is an object i use to easily keep track of x and y vectors instead of making 2 variables i just make one object
class Pos
  #this allows read and writes of the x and y
  attr_accessor :x, :y
  #this defines the vectors x and y
  def initialize(x,y)
    @x = x
    @y = y
  end
end

#this is the fucking LerpTable
#it knows how to do shit
class LerpTable
  def initialize(lastVal, newVal)
    @l = lastVal
    @n = newVal
  end
  def calculate()
    case @l
    when "w"
      case @n
      when "w"
        return 0
      when "a"
        return -9
      when "s"
        return 18
      when "d"
        return 9
      end
    when "a"
      case @n
      when "a"
        return 0
      when "w"
        return 9
      when "s"
        return -9
      when "d"
        return 18
      end
    when "s"
      case @n
      when "s"
        return 0
      when "w"
        return 18
      when "a"
        return 9
      when "d"
        return -9
      end
    when "d"
      case @n
      when "d"
        return 0
      when "w"
        return -9
      when "a"
        return 18
      when "s"
        return 9
      end
    end
  end
end
