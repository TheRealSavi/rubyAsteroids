require 'ruby2d'
set width: 480, height:480
set title: "Asteroids", fullscreen:false

class Ship
  attr_accessor :health, :pos, :model, :color, :vel, :bullets, :speed

  def initialize(health, pos, color)
    @health = health
    @pos = pos
    @color = color
    @speed = 2
    @vel = Pos.new(0,0)
    @bullets = []
    @model = Square.new(
      x: pos.x, y: pos.y,
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
    for i in $asteroids do
      if (
          @model.x >= i.pos.x &&
          @model.x <= i.pos.x + i.size &&
          @model.y >= i.pos.y &&
          @model.y <= i.pos.y + i.size ||
          @model.x + @model.size >= i.pos.x &&
          @model.x + @model.size <= i.pos.x + i.size &&
          @model.y + @model.size >= i.pos.y &&
          @model.y + @model.size <= i.pos.y + i.size)
        i.split()
        return true
      else
        return false
      end
    end
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
    if @size <= 32
      self.kill()
    else
      @size = @size/2
      @model.size = @size
      $asteroids.push(Asteroid.new(@size, Pos.new(rand(1..Window.width),rand(1..Window.height))))
    end
  end

  def kill()
    $asteroids.delete(self)
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

$asteroids = []
ships = []
ships.push(Ship.new(3, Pos.new(Window.width/2-20,Window.height-40),'lime'))
$asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width),rand(1..Window.height))))


on :key_down do |event|
  for i in ships
    case event.key
      when "w"
        i.vel = Pos.new(0,-i.speed)
      when "a"
        i.vel = Pos.new(-i.speed,0)
      when "s"
        i.vel = Pos.new(0,i.speed)
      when "d"
        i.vel = Pos.new(i.speed,0)
      when "e"
        i.shoot()
      when "x"
        $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width),rand(1..Window.height))))
    end
  end
end

update do
  for i in ships
    i.update()
    for j in i.bullets
      if j.hit()
        j.kill(i.bullets)
      end
      j.update()
    end
  end
end

show
