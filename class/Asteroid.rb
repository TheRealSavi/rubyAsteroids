class Asteroid
  #read and writes outside of class
  attr_accessor :size, :pos

  def initialize(size, pos)
    @size = size
    @pos = pos
    @vel = Pos.new(rand(-0.35..0.35),rand(-0.35..0.35))
    #asteroids model
    @model = Image.new(
      'imgs/asteroid.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      rotate: 0,
      z: 101
    )

    #this is a number that appears on every asteroid that shows its position in the asteroids array
    @id = Text.new($asteroids.index(self).to_s, x: @pos.x, y: @pos.y, z:102)
    #shows the number
    @id.add
  end

  #this gets called by a bullet when the bullet detects it has hit this asteroid
  def split()
    #if the asteroid is too small to split then it will kill itself
    if @size <= 32
      self.kill()
    else
      #if it is good to go then the size will be halved, kill itself, ans create two new asteroids
      @size = @size/2
      self.kill()
      $asteroids.push(Asteroid.new(@size, Pos.new(rand(@pos.x-64..@pos.x+64).clamp(0,Window.width),rand(@pos.y-64..@pos.y+64).clamp(0,Window.height))))
      $asteroids.push(Asteroid.new(@size, Pos.new(rand(@pos.x-64..@pos.x+64).clamp(0,Window.width),rand(@pos.y-64..@pos.y+64).clamp(0,Window.height))))
    end
  end

  #this gets called by the split function if it is too small to split
  def kill()
    #this removes itself from the asteroids array
    $asteroids.delete(self)
    #this gets rid of the model from the window
    @model.remove
    #this gets rid of the text on the asteroid that shows its postion in the array
    @id.remove
  end

  def move()
    if (
    @model.x >= Window.width-@size ||
    @model.x <= 0 ||
    @model.y >= Window.height-@size ||
    @model.y <= 0
    )
      #if the ship isnt in a valid position to complete its user decide move it will just reverse the direction and bounce
      @vel.x = -@vel.x
      @vel.y = -@vel.y
    end
    @pos.x += @vel.x
    @pos.y += @vel.y
    @model.x = @pos.x
    @model.y = @pos.y
  end

  #this gets called every fram by the windows update method
  def update()
    self.move()
    #this gets rid of the text on the asteroid that shows its postion in the array
    @id.remove
    #this updates the text to whatever positon it might be in now
    @id = Text.new($asteroids.index(self).to_s, x: @pos.x, y: @pos.y, z:102)
    #this redisplays the text
    @id.add
  end
end
