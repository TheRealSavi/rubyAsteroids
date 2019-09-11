require 'ruby2d'
set width: 480, height:480
set title: "Asteroids", fullscreen:false

class Ship
  attr_accessor :health, :pos, :model, :color, :vel, :bullets

  def initialize(health, pos, color)
    @health = health
    @pos = pos
    @color = color
    @vel = Pos.new(0,0)
    @bullets = []
    @model = Square.new(
      x: 0, y: 0,
      size: 20,
      color: color,
      z: 100
    )
  end

  def move()
    @pos.x += @vel.x
    @pos.y += @vel.y
  end

  def shoot()
    @bullets.push(Bullet.new(Pos.new(@pos.x,@pos.y),Pos.new(@vel.x,@vel.y)))
  end

  def update()
    self.move()
    @model.x = @pos.x
    @model.y = @pos.y
  end
end

class Bullet
  attr_accessor :pos, :model, :vel, :color

  def initialize(pos, vel)
    @pos = Pos.new(pos.x + 5, pos.y + 5)
    @vel = Pos.new(vel.x * 3, vel.y * 3)
    @color = 'red'
    @model = Square.new(
      x: @pos.x, y: @pos.y,
      size: 8,
      color: color,
      z: 99
    )
  end

  def hit()
    #if self.pos contains Asteroid.pos
      #Asteroid.split()
      #self.kill
    #end
  end

  def kill(bullets)
    bullets.delete(self)
    @model.remove
  end

  def move()
    @pos.x += @vel.x
    @pos.y += @vel.y
  end

  def update()
    self.move()
    @model.x = @pos.x
    @model.y = @pos.y
  end
end

class Asteroid
  attr_accessor :size, :pos

  def initialize(size, pos)
    @size = size
    @pos = pos
    @model = Square.new(
      x: @pos.x, y: @pos.y,
      size: @size,
      color: 'brown',
      z: 101
    )
  end

  def split()
    if @size <= 1

    else
    @size = @size/2
    #make new Asteroid(@size, @pos)
    end
  end

  def kill(asteroids)
    asteroids.delete(self)
    @model.remove
  end

  def update()
  end
end

class Pos
  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

end

asteroids = []
ships = []
ships.push(Ship.new(3, Pos.new(0,0),'random'))
asteroids.push(Asteroid.new(60, Pos.new(120,120)))


on :key_down do |event|
  for i in ships
    case event.key
      when "w"
        i.vel = Pos.new(0,-1)
      when "a"
        i.vel = Pos.new(-1,0)
      when "s"
        i.vel = Pos.new(0,1)
      when "d"
        i.vel = Pos.new(1,0)
      when "e"
        i.shoot()
      when "x"
        for j in i.bullets
          j.kill(i.bullets)
        end
    end
  end
end

update do
  for i in ships
    i.update()
    for j in i.bullets
      j.update()
    end
  end
end

show
