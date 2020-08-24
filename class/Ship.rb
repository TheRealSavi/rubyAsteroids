class Ship
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :pos, :model, :dir, :vel, :bullets, :speed, :size, :lerp, :lerps, :lastDir, :points, :Control, :pointAdd, :isDead, :pierce, :immune

  def initialize(health, pos, controls, shipID)
    @health = health #ships health
    @pos = pos #ships position has a position object
    @shipID = shipID #ships id 0 based
    @controls = controls #an array of the ships desired controls

    @Control = {
      "forward"  => @controls[0],
      "left"     => @controls[1],
      "backward" => @controls[2],
      "right"    => @controls[3],
      "shoot"    => @controls[4],
      "use"      => @controls[5]
    }

    @vel = Pos.new(0,0) #default ship velocity
    @size = 32 #ship model size
    @points = 0 #defualt points
    @pointAdd = 1 #default ammount of points to add for hitting an asteroid
    @isDead = false #says if ship is dead or not
    @lerp = false #says if it should calculate a lerp or not
    @lerps = 0 #this holds how many frames the ship has lerped for so it knows when to stop rotating
    @lastDir = 270 #this holds the last direction the ship was moving so it knows what angle to lerp from
    @dir = 270 #this holds the ships new direction so it knows where to lerp to
    @shotCount = 1 #this is how many bullets are made when the shoot key is pressed
    @speed = 2 #this is how many pixels it moves per frame
    @powerUpTimer = 0 #how much longer the ship has on its powerup
    @tick = 0 #used for determining powerUpTimer
    @pierce = false #contols the shooting mode for the bullets
    @immune = false #controls whether the ship is immune to damage or not

    @bullets = [] #This is the ships array of bullets that holds all the bullet objects this ship creates

    #This is the ships model object so that there is something to actually display
    @model = Image.new(
      'imgs/ship.png',
      x: @pos.x, y: @pos.y,
      width: @size, height: @size,
      rotate: 270,
      z: 200
    )

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

    #this is the number that appears to show when a powerup will end
    @timerLabel = Text.new('', x: 0, y: 0, z:0, size:0)
    @timerLabel.remove
    #this displays the points for the ship in the bottom left
    @pointLabel = Text.new('', x: 0, y: 0, z:0, size:0)
    @pointLabel.remove
    #this is the text that asks if you want to revive a dead ship
    @reviveLabel = Text.new('', x:0, y:0, z:0, size:0)
    @reviveLabel.remove

    #d versions of variables hold the defualt version of the var so it can be reverted to later
    @dPointAdd  = @pointAdd
    @dSpeed     = @speed
    @dShotCount = @shotCount
  end

  #this is called when the user presses a direction key, it is used to keep track of the current and old directions for lerping
  def changeDir(newDir)
    @dir = newDir
    @lerp = true
  end

  #this is called when a new life is added to the ship it is used to create another model for the top left health display
  def addHealth(add)
    if @health < 5
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
    else
      @points += 10
    end
  end

  #this is called when a life should be removed from the ship it is used to remove health models and kill ship
  def minusHealth(minus)
    minus.times do
      @health-=1
      if @health >= 0 && @healthModels.length >= 1
        @healthModels[@health].remove
        @healthModels.delete(@healthModels[@health])
      end
      if @health <= 0
        self.kill
      end
    end
  end

  #This gets called every frame by the ships update method
  #It first checks if the ship is in a valid position to move
  #if its not if turns it around otherwise it just goes
  def move()
    if @lerps == 0
      if @model.x >= Window.width-@size
        @vel = Pos.new(-@vel.x,-@vel.y)
        self.changeDir(180)
      end
      if @model.x <= 0
        @vel = Pos.new(-@vel.x,-@vel.y)
        self.changeDir(0)
      end
      if @model.y >= Window.height-@size
        @vel = Pos.new(-@vel.x,-@vel.y)
        self.changeDir(270)
      end
      if @model.y <= 0
        @vel = Pos.new(-@vel.x,-@vel.y)
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
    @shotCount = @dShotCount
    @pointAdd = @dPointAdd
    @speed = @dSpeed
    @pierce = false
    @immune = false
    @timerLabel.remove

    if @vel.y < 0
      @vel.y = -@speed
    end

    if @vel.y > 0
      @vel.y = @speed
    end

    if @vel.x < 0
      @vel.x = -@speed
    end

    if @vel.x > 0
      @vel.x = @speed
    end

    @powerUpTimer = 0
    @model.color = [1,1,1,1]
  end

  #this is called by the bullet object when it detects it has hit an asteroid
  def powerUp(type, tint, time = nil)
    if type != 'None'
      case type

      when 'Speed'
        $speedUp.play
        self.clearPowerUps()
        @speed *= 2
        @pointAdd *=3
        @vel.x *= 2
        @vel.y *= 2
        @model.color = tint
        if time != nil
          @powerUpTimer = time
        else
          @powerUpTimer = 7
        end

      when '1Up'
        $lifeUp.play
        self.addHealth(1)

      when 'Triple'
        $triple.play
        self.clearPowerUps()
        @shotCount *=3
        @model.color = tint
        if time != nil
          @powerUpTimer = time
        else
          @powerUpTimer = 12
        end

      when 'Pierce'
        $lifeUp.play
        self.clearPowerUps()
        @pierce = true
        @model.color = tint
        if time != nil
          @powerUpTimer = time
        else
          @powerUpTimer = 6
        end

      when 'Immune'
        $lifeUp.play
        self.clearPowerUps()
        @immune = true
        @model.color = tint
        if time != nil
          @powerUpTimer = time
        else
          @powerUpTimer = 4
        end
      end
    end
  end

  #this checks if the ship has colided with anything
  #it gets called every frame by the ships update method
  def collideCheck()

    for k in GameManager.getAsteroids() #first it runs through all the asteroids and checks if itself is inside one
      if Intersect.new([@model.x,@model.y,@size],[k.pos.x,k.pos.y,k.size]).calculate()
        self.hurt() #if it detects it has hit an asteroid the ship gets hurt
      end
    end

    for k in GameManager.getShips()
      if Intersect.new([@model.x,@model.y,@size],[k.pos.x,k.pos.y,k.size]).calculate()

      end
    end

  end

  def hurt()
    if @immune == false
      self.minusHealth(1)
      self.clearPowerUps()
      $crash.play

      if @health >=1 #if it still has lives left
        @pos = Pos.new(Window.width/2,Window.height/2)
        powerUp('Immune',[0.36, 0.90, 0.71, 1], 1)
        @vel = Pos.new(0,0)
      else
        self.kill() #if it has no more lives
      end
    end
  end

  def reviveLabelCheck()
    if @health >= 2
      @reviveLabel.remove
      GameManager.getShips().each do |i|
        if i != self
          if i.isDead == true
            if (@pos.x-@size*2..@pos.x+@size*2).include?(i.pos.x) && (@pos.y-@size*2..@pos.y+@size*2).include?(i.pos.y)
              @reviveLabel.remove
              @reviveLabel = Text.new('Revive ship?', x: i.pos.x, y: i.pos.y+@size, z: 255, size: 20)
              @reviveLabel.add
            end
          end
        end
      end
    end
  end

  def use()
    if @health >= 2
      GameManager.getShips().each do |i|
        if i != self
          if i.isDead == true
            if (@pos.x-@size*2..@pos.x+@size*2).include?(i.pos.x) && (@pos.y-@size*2..@pos.y+@size*2).include?(i.pos.y)
              @reviveLabel.remove
              i.revive()
              @points += 50
              self.minusHealth(2)
              break
            end
          end
        end
      end
    end
  end

  def revive()
    powerUp('Immune',[0.36, 0.90, 0.71, 1], 1)
    self.addHealth(1)
    @isDead = false
    @pos = Pos.new(Window.width/2,Window.height/2)
    @vel = Pos.new(0,0)
  end

  #this gets called when the ship has no more lives
  def kill()
    @isDead = true

    if self.otherShipAlive() == true
      @vel = Pos.new(rand(-0.35..0.35),rand(-0.35..0.35))
    else
      gameOver = Text.new('GAME OVER', x: Window.width/2-100, y: Window.height/2, z: 255, size: 32)
      gameOver.add
      GameManager.endGame
    end
  end

  def otherShipAlive()
    GameManager.getShips().each do |i|
      if i.isDead == false
        return true
      end
    end
    return false
  end

  def powerUpCheck()
    #this checks if there is a powerup active
    if @powerUpTimer >= 1
      #this updates the text to the seconds left on the powerup
      @timerLabel.remove
      @timerLabel = Text.new(@powerUpTimer.to_s, x: @pos.x-10, y: @pos.y-10, z:202, size:12)
      @timerLabel.add

      #this checks if it has been a second (60 frames)
      @tick += 1
      if @tick % 60 == 0
        @powerUpTimer-=1
        if @powerUpTimer <= 0
          #this removes the powerup if there is no time left
          $downgrade.play
          self.clearPowerUps()
          @timerLabel.remove
        end
      end
    end
  end

  #this gets called every frame by the ships update method
  #it manages the animation of the rotation of the ship
  def rotationLerp()
    #how many frames it will take to complete the rotation
    steps = 6
    step = CircleLerp.new(@lastDir,@dir,steps).calculate() #returns how many degrees to turn per frame given steps

    if @lerp == true      #lerp gets set to true everytime an arrow key is pressed
      @lerps += 1         #counts how many steps it gone through
      @model.rotate += step

      if @lerps >= steps  #if its done lerping because it hit the said steps
        @lerps = 0        #reset
        @lerp = false     #finish lerping
        @lastDir = @dir   #finalize rotation
      end

    end
  end

  #this gets called every frame by the windows update method
  def update()

    if @isDead == false
      self.powerUpCheck()
      self.collideCheck()
      self.reviveLabelCheck()
    end

    self.rotationLerp()
    self.move()

    @pointLabel.remove
    @pointLabel = Text.new('Player ' + (@shipID + 1).to_s + ' Points:' + @points.to_s, x: 0, y: Window.height-(20 * (@shipID+1)), z:255, size:20)
    @pointLabel.add
  end
end
