class Bullet
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :pos, :model, :vel, :size

  def initialize(pos, vel, bullets, buffer, ship)
    #i multiply the velocity by 3 so the bullet moves faster than the ship that shot it
    @vel = Pos.new(vel.x * 5, vel.y * 5)
    @size = 16
    @ship = ship
    @pos = Pos.new(pos.x + buffer-@size/2, pos.y + buffer-@size/2)
    @bullets = bullets
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
    for k in $asteroids
      if (
      @model.x >= k.pos.x &&
      @model.x <= k.pos.x + k.size &&
      @model.y >= k.pos.y &&
      @model.y <= k.pos.y + k.size ||
      @model.x + @size >= k.pos.x &&
      @model.x + @size <= k.pos.x + k.size &&
      @model.y + @size >= k.pos.y &&
      @model.y + @size <= k.pos.y + k.size
      )
        #if it detects it is in an asteroid it calls that asteroids split function and then kills itself
        @ship.powerUp(k.type,k.tint[k.type])
        k.split()
        self.kill()
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
  end

  #this gets called every frame by the windows update method
  def update()
    #checks if it has hit an asteroid
    self.hit()
    #moves the bullet
    self.move()
    #moves the bullets model
    @model.x = @pos.x
    @model.y = @pos.y
  end
end
