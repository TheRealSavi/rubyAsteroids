class Bullet
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :pos, :vel, :size

  def initialize(pos, vel, bullets, buffer, ship)
    @ship = ship
    @bullets = bullets

    @speed = 10
    @size = 16

    case ship.dir
    when 0
      @vel = Pos.new(@speed,0)
    when 90
      @vel = Pos.new(0,@speed)
    when 180
      @vel = Pos.new(-@speed,0)
    when 270
      @vel = Pos.new(0,-@speed)
    end

    @pos = Pos.new(pos.x + buffer-@size/2, pos.y + buffer-@size/2)

    #here is the bullets model object
    @model = Image.new(
      'imgs/bullet.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      rotate: 0,
      z: 99
    )

  end

  #this function gets called every frame by the update method
  def hit()
    #first it runs through all the asteroids and checks if itself is inside one
    for k in GameManager.getAsteroids()
      if Intersect.new([@model.x,@model.y,@size],[k.pos.x,k.pos.y,k.size]).calculate()
        #if it detects it is in an asteroid it calls that asteroids split function and then kills itself
        #it sends the ship that shot it its powerup value and tint so the ship can interpret it
        @ship.powerUp(k.type,k.tint[k.type])
        k.split()
        @ship.points += @ship.pointAdd
        if @ship.pierce == false
          self.kill()
        end
      end
    end
  end

  #this gets called by the hit function if it collides with something
  def kill()
    #this removes the bullet object from the bullets array
    @bullets.delete(self)
    #this removes the model so it is no longer displayed on the window
    @model.remove
  end

  #this gets called by the update method every frame
  def move()
    #first it checks if it is on an edge
    if (
    @model.x >= Window.width-@size ||
    @model.x <= 0 ||
    @model.y >= Window.height-@size ||
    @model.y <= 0
    )
      #if the bullet is on the edge then it will die
      self.kill()
    end
    #this moves the bullet by the velocity of the bullet
    @pos.x += @vel.x
    @pos.y += @vel.y
    #moves the bullets model
    @model.x = @pos.x
    @model.y = @pos.y
  end

  #this gets called every frame by the windows update method
  def update()
    #checks if it has hit an asteroid
    self.hit()
    #moves the bullet
    self.move()
  end
end
