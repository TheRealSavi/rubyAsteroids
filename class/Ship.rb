class Ship
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :pos, :model, :dir, :vel, :bullets, :speed, :size, :lerp, :lerps, :lastDir, :points, :controls, :Control

  def initialize(health, pos, controls, shipID)
    @health = health
    @pos = pos
    @vel = Pos.new(0,0)
    @size = 32
    @points = 0

    @shipID = shipID

    @controls = controls
    @Control = {
      "forward" => @controls[0],
      "left" => @controls[1],
      "backward" => @controls[2],
      "right" => @controls[3],
      "shoot" => @controls[4]
    }

    #says if it should calculate a lerp or not
    @lerp = false
    #this holds how many frames the ship has lerped for so it knows when to stop rotating
    @lerps = 0

    #this holds the last direction the ship was moving so it knows what angle to lerp from
    @lastDir = 0
    #this holds the ships new direction so it knows where to lerp to
    @dir = 270

    #this is how many bullets are made when the shoot key is pressed
    #d versions of variables hold the defualt version of the var so it can be reverted to later
    @shotCount = 1
    @dShotCount = @shotCount

    #this is how many pixels it moves per frame
    @speed = 2
    @dSpeed = @speed

    #these are for deciding when powerups shold end
    @powerUpTimer = 0
    @tick = 0

    #This is the ships array of bullets that holds all the bullet objects this ship creates
    @bullets = []

    #this is how the ship displays how many lives it has in the top left
    @healthModels = []
    for i in 0..@health-1
      @healthModels.push(Image.new(
        'imgs/ship.png',
        x: i*@size+20, y: @size * @shipID,
        width: @size, height: @size,
        rotate: @dir,
        z: 200
      ))
    end

    #This is the ships model object so that there is something to actually display
    @model = Image.new(
      'imgs/ship.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      rotate: 270,
      z: 200
    )

    #this is the number that appears to show when a powerup will end
    @id = Text.new(@powerUpTimer.to_s, x: @pos.x, y: @pos.y, z:202)
    @id.remove

    #this displays the points for the ship in the bottom left
    @pointModel = Text.new(@points.to_s, x: 0, y: Window.height-20, z:255, size:20)
  end

  #this is called when the user presses a direction key, it is used to keep track of the current and old directions for lerping
  def changeDir(newDir)
    @lastDir = @dir
    @dir = newDir
    @lerp = true
  end

  #this is called when a new life is added to the ship it is used to create another model for the top left health display
  def addHealth(add)
    @health += add
    add.times do
      @healthModels.push(Image.new(
        'imgs/ship.png',
        x: @healthModels.count * @size + 20, y: @size * @shipID,
        width: @size, height: @size,
        rotate: 270,
        z: 200
      ))
    end
  end


  #This gets called every frame by the ships update method
  #It first checks if the ship is in a valid position to move
  #if its not if turns it around otherwise it just goes
  def move()
  if @lerps == 0
    if @model.x >= Window.width-@size
      @vel = Pos.new(-@speed,0)
      self.changeDir(180)
    end
    if @model.x <= 0
      @vel = Pos.new(@speed,0)
      self.changeDir(0)
    end
    if @model.y >= Window.height-@size
      @vel = Pos.new(0,-@speed)
      self.changeDir(270)
    end
    if @model.y <= 0
      @vel = Pos.new(0,@speed)
      self.changeDir(90)
    end
  end

    #this moves the ship by its velocity
    @pos.x += @vel.x
    @pos.y += @vel.y
    #this updates the models postion to the position made by the move function
    @model.x = @pos.x
    @model.y = @pos.y
  end

  #this gets called if the user presses the shoot key
  def shoot()
    #this adda a new bullet object to the ships bullet array with the same position and velocity of the ship
    $pew.play
    for i in 1..@shotCount
      @bullets.push(Bullet.new(Pos.new(@pos.x + (i-1)*16,@pos.y + (i-1)*16),Pos.new(@vel.x,@vel.y),@bullets,@size/2, self))
    end
  end

  #this is called whenever the ships powerup informarion needs to be reset
  #it reverts to default speed and shotcount, re evaluates current velocity, and returns to standard color
  def clearPowerUps()
    @speed = @dSpeed
    if @vel.x == 0
      if @vel.y <= 0
        @vel.y = -@speed
      else
        @vel.y = @speed
      end
    elsif @vel.x <= 0
      @vel.x = -@speed
    else
      @vel.x = @speed
    end
    @shotCount = @dShotCount
    @model.color = [1,1,1,1]
  end

  #this is called by the bullet object when it detects it has hit an asteroid
  def powerUp(type, tint)
    if type != 'None'
      case type
      when 'Speed'
        $speedUp.play
        self.clearPowerUps()
        @speed *= 3
        @vel.x *= 3
        @vel.y *= 3
        @model.color = tint
        @powerUpTimer = 7
      when '1Up'
        $lifeUp.play
        self.addHealth(1)
      when 'Triple'
        $triple.play
        self.clearPowerUps()
        @shotCount *=3
        @model.color = tint
        @powerUpTimer = 12
      else
        puts 'Undefinded Powerup : ' + type
      end
    end
  end

  #this checks if the ship has colided with an asteroid
  #it gets called everyframe by the ships update method
  def collideCheck()
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
        #if it detects it is in an asteroid it removes one health
        @health-=1
        if @health >=1
          #if it still has lives left it returns to the center and has everything reset
          @pos = Pos.new(Window.width/2,Window.height/2)
          @model.color = [1,1,1,1]
          @healthModels[@health].remove
          @healthModels.delete(@healthModels[@health])
          self.clearPowerUps()
          @powerUpTimer = 0
          @id.remove
          @vel = Pos.new(0,0)
          $crash.play
        else
          #if it has no more lives then it stops the windows update method and displays game over
          @healthModels[@health].remove
          @healthModels.delete(@healthModels[@health])
          gameOver = Text.new('GAME OVER', x: Window.width/2-100, y: Window.height/2, z: 255, size: 32)
          gameOver.add
          $crash.play
          self.kill()
        end
      end
    end
  end

  #this gets called when the ship has no more lives
  def kill()
    $stop = true
  end

  def powerUpCheck()
    #this checks if there is a powerup active
    if @powerUpTimer >= 1
      #this updates the text to the seconds left on the powerup
      @id.remove
      @id = Text.new(@powerUpTimer.to_s, x: @pos.x-10, y: @pos.y-10, z:202, size:12)
      @id.add

      #this checks if it has been a second (60 frames)
      @tick += 1
      if @tick % 60 == 0
        @powerUpTimer-=1
        if @powerUpTimer <= 0
          #this removes the powerup if there is no time left
          $downgrade.play
          self.clearPowerUps()
          @id.remove
        end
      end
    end
  end

  #this gets called every frame by the ships update method
  #it manages the animation of the rotation of the ship
  def rotationLerp()
    #how many frames it will take to complete the rotation (must be a factor of 90)
    # aka one of these 1,2,3,5,6,9,10,15,18,30,45,90
    steps = 6
    step = CircleLerp.new(@lastDir,@dir,steps).calculate() #returns how many degrees to turn per frame given steps

    if @lerp == true      #lerp gets set to true everytime an arrow key is pressed
      @lerps += 1         #counts how many steps it gone through
      @model.rotate += step

      if @lerps >= steps  #if its done lerping because it hit the said steps
        @lerps = 0        #reset
        @lerp = false     #finish lerping
        @lastDir = @dir   #finalize direction
      end

    end
  end

  #this gets called every frame by the windows update method
  #it calls the ships move method and then updates the models position to match the new decided position
  def update()
    self.powerUpCheck()
    self.collideCheck()
    self.move()
    self.rotationLerp()

    @pointModel.remove
    @pointModel = Text.new('Player ' + (@shipID + 1).to_s + ' Points:' + @points.to_s, x: 0, y: Window.height-(20 * (@shipID+1)), z:255, size:20)
    @pointModel.add
  end
end
