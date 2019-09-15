require 'ruby2d'
set width: 480, height:480
set title: "Asteroids", fullscreen:false


class Ship
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :health, :pos, :model, :color, :vel, :bullets, :speed, :size

  def initialize(health, pos, color)
    @health = health
    @pos = pos
    @color = color
    @speed = 2
    @size = 20
    @vel = Pos.new(0,0)
    #This is the ships array of bullets that hold holds all the bullet objects this ship creates
    @bullets = []
    #This is the ships model object so that there is something to actually display
    @model = Square.new(
      x: pos.x, y: pos.y,
      size: @size,
      color: color,
      z: 100
    )
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
    @bullets.push(Bullet.new(Pos.new(@pos.x,@pos.y),Pos.new(@vel.x,@vel.y),@bullets))
  end

  #this gets called every frame by the windows update method
  #it calls the ships move method and then updates the models position to match the new decided position
  def update()
    self.move()
    @model.x = @pos.x
    @model.y = @pos.y
  end
end

class Bullet
  #This allows read and write access to these variables when called outside of the class
  attr_accessor :pos, :model, :vel, :color, :size

  def initialize(pos, vel, bullets)
    #i add 5 to the position to center it
    #i multiply the velocity by 3 so the bullet moves faster than the ship that shot it
    @pos = Pos.new(pos.x + 5, pos.y + 5)
    @vel = Pos.new(vel.x * 3, vel.y * 3)
    @color = 'red'
    @size = 8
    @bullets = bullets
    #here is the bullets model object
    @model = Square.new(
      x: @pos.x, y: @pos.y,
      size: @size,
      color: color,
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
      @model.x + @model.size >= k.pos.x &&
      @model.x + @model.size <= k.pos.x + k.size &&
      @model.y + @model.size >= k.pos.y &&
      @model.y + @model.size <= k.pos.y + k.size
      )
        #if it detects it is in an asteroid it calls that asteroids split function and then kills itself
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

class Asteroid
  #read and writes outside of class
  attr_accessor :size, :pos

  def initialize(size, pos)
    @size = size
    @pos = pos
    #asteroids model
    @model = Square.new(
      x: @pos.x, y: @pos.y,
      size: @size,
      color: 'brown',
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
      $asteroids.push(Asteroid.new(@size, Pos.new(rand(1..Window.width-@size),rand(1..Window.height-@size))))
      $asteroids.push(Asteroid.new(@size, Pos.new(rand(1..Window.width-@size),rand(1..Window.height-@size))))
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

  #this gets called every fram by the windows update method
  def update()
    #this gets rid of the text on the asteroid that shows its postion in the array
    @id.remove
    #this updates the text to whatever positon it might be in now
    @id = Text.new($asteroids.index(self).to_s, x: @pos.x, y: @pos.y, z:102)
    #this redisplays the text
    @id.add
  end
end

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

#this initializes the asteroids array
$asteroids = []
#this initializes the ships array
ships = []
#this addes a new ship to the ships array so the game can be played lol
ships.push(Ship.new(3, Pos.new(Window.width/2-20,Window.height-40),'lime'))
#this adds the first asteroid to the asteroids array so something can be shot
$asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
#this is a ruby2d event that is called every time a key is pushed down. it gets passed the key that was pushed in the event var
on :key_down do |event|
  #this goes through all the ships so they are all controlled at once
  for i in ships
    case event.key
      when "w"
        #this is change the current ships velocity to a new vector that has a value of 0 in the x
        #                                      and a negative version of the ships speed in the y
        #it is the same idea for all the other velocity changes
        i.vel = Pos.new(0,-i.speed)
      when "a"
        i.vel = Pos.new(-i.speed,0)
      when "s"
        i.vel = Pos.new(0,i.speed)
      when "d"
        i.vel = Pos.new(i.speed,0)
      when "e"
        #this calls that ships shoot function which creates a bullet object and adds it to that ships bullets array
        i.shoot()
      when "x"
        #this creates a new asteroid and adds it to the asteroids array
        $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
    end
  end
end

#this is a ruby2d event that is called every frame
update do
  #this calls all the asteroids update functions
  for i in $asteroids
    i.update()
  end

  #this loops through all ships
  for i in ships
    #this calls all the ships update functions
    i.update()
    #this loops through the current ships bullets
    for j in i.bullets
      #this updates all the bullets belonging to the current ship
      j.update()
    end
  end
end

#this is the ruby2d method that shows the window
show
