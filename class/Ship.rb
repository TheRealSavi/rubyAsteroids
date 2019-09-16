class Ship
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :health, :pos, :model, :rot, :vel, :bullets, :speed, :size, :lerp, :lerps, :lastDir

  def initialize(health, pos, color)
    @health = health
    @pos = pos
    #this tells the ship how many degrees to rotate when lerping
    @lerp = 0
    #this holds the last direction the ship was moving so it knows what angle to lerp from
    @lastDir = ""
    #this holds the ships new direction so it knows where to lerp to
    @dir = "w"
    #this holds how many frams the ship has lerped for so it knows when to stop rotating
    @lerps = 0
    #this is how many pixels the ship moves per frame
    @speed = 2
    @size = 54
    @vel = Pos.new(0,0)
    #This is the ships array of bullets that hold holds all the bullet objects this ship creates
    @bullets = []
    #This is the ships model object so that there is something to actually display
    @model = Image.new(
      'imgs/ship.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      rotate: -90,
      z: 200
    )
  end

  #this is called when the user presses a direction key, it is used to keep track of the current and old directions for lerping
  def changeDir(newDir)
    @lastDir = @dir
    @dir = newDir
  end

  #This gets called every frame by the ships update method
  #It first checks if the ship is in a valid position to move and then moves it
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
    #this moves the ship by its velocity
    @pos.x += @vel.x
    @pos.y += @vel.y
  end

  #this gets called if the user presses the shoot key
  def shoot()
    #this added a new bullet object to the ships bullet array with the same position and velocity of the ship
    @bullets.push(Bullet.new(Pos.new(@pos.x,@pos.y),Pos.new(@vel.x,@vel.y),@bullets,@size/2))
  end

  #this gets called every frame by the windows update method
  #it calls the ships move method and then updates the models position to match the new decided position
  def update()
    self.move()

    #this asks the lerp table to know how many degrees to rotate per fram for 10 frames until it has rotated to the new direction
    @lerp = LerpTable.new(@lastDir,@dir).calculate()
    #this checks if it needs to lerp
    if @lerp != 0 && @lerp != nil
      #iterates the frames lerped by one so it knows when to stop
      @lerps += 1
      #this rotates the model by the degree specified by the LerpTable
      @model.rotate += @lerp
      #checks if its done lerping yet
      if @lerps >= 10
        #if it is it resets everything for next time and says that the last direction is now its current direction
        @lerps = 0
        @lerp = 0
        @lastDir = @dir
      end
    end

    #this updates the models postion to the position made by the move function
    @model.x = @pos.x
    @model.y = @pos.y
  end
end
