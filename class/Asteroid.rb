class Asteroid
  #read and writes outside of class
  attr_accessor :size, :pos, :type, :tint

  def initialize(size, pos)
    @size = size
    @pos = pos
    @vel = Pos.new(rand(-0.35..0.35),rand(-0.35..0.35))

    #this defines the powerups the asteroid could get and those powerups colors
    @types = ['Triple','Speed','1Up','Pierce','Immune']
    @tint = {
      'Triple' => [0.98, 0.93, 0.30, 1], #these are RGBA values
      'Speed'  => [0.98, 0.36, 0.30, 1],
      '1Up'    => [0.30, 0.98, 0.49, 1],
      'Pierce' => [0.75, 0.30, 0.80, 1],
      'Immune' => [0.36, 0.90, 0.71, 1],
      'None'   => [1.00, 1.00, 1.00, 1]
    }

    #this is the way the asteroid decides whether it should get a powerup or not
    #the value is the percentage of not having a powerup
    if rand(1..100) >= 75
      @type = @types.sample()
    else
      @type = 'None'
    end

    #asteroids model
    @model = Image.new(
      'imgs/asteroid.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      color: @tint[@type],
      rotate: 0,
      z: 101
    )
  end

  #this gets called by a bullet when the bullet detects it has hit this asteroid
  def split()
    SoundManager.play("boom")
    #if the asteroid is too small to split then it will kill itself
    if @size <= 32
      self.kill()
    else
      #if it is good to go then the size will be halved, kill itself, ans create two new asteroids
      @size = @size/2
      self.kill()
      GameManager.getAsteroids().push(Asteroid.new(@size, Pos.new(rand(@pos.x-64..@pos.x+64).clamp(0,Window.width-@size),rand(@pos.y-64..@pos.y+64).clamp(0,Window.height-@size))))
      GameManager.getAsteroids().push(Asteroid.new(@size, Pos.new(rand(@pos.x-64..@pos.x+64).clamp(0,Window.width-@size),rand(@pos.y-64..@pos.y+64).clamp(0,Window.height-@size))))
    end
  end

  #this gets called by the split function if it is too small to split
  def kill()
    #this removes itself from the asteroids array
    GameManager.getAsteroids().delete(self)
    #this gets rid of the model from the window
    @model.remove
  end

  def move()
    if (
    @model.x >= Window.width-@size ||
    @model.x <= 0 ||
    @model.y >= Window.height-@size ||
    @model.y <= 0
    )
      #if the asteroid isnt in a valid position to complete its move it will just reverse the direction and bounce
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
  end
end
