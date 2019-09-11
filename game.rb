require 'ruby2d'
set width: 480, height:480
set title: "Asteroids", fullscreen:false

class Ship
  attr_accessor :health, :pos, :meShape, :color, :vel, :bullets

  def initialize(health, pos, color)
    @health = health
    @pos = pos
    @color = color
    @vel = Pos.new(0,0)
    @bullets = []
    @meShape = Square.new(
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
    @meShape.x = @pos.x
    @meShape.y = @pos.y
  end

end

class Bullet
  attr_accessor :pos, :model, :vel

  def initialize(pos,vel)
    @pos = pos
    @vel = Pos.new(vel.x * 3, vel.y * 3)
    @model = Square.new(
      x: @pos.x, y: @pos.y,
      size: 8,
      color: 'red',
      z: 100
    )
  end

  def hit()
    #if self.pos contains Asteroid.pos
      #Asteroid.split()
      #self.kill
    #end
  end

  def kill()
    #Remove self from bullets array
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
  end

  def split()
    if @size <= 1
      #self.kill
    else
    @size = @size/2
    #make new Asteroid(@size, @pos)
    end
  end

  def kill()
    #Remove self from asteroids array
  end

end

class Pos
  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y
  end

end

Vels = [
  Pos.new(0,-1),
  Pos.new(0,1),
  Pos.new(-1,0),
  Pos.new(1,0),
  Pos.new(0,0)
]

me = Ship.new(3, Pos.new(0,0),'green')

on :key_down do |event|
  case event.key
  when "w"
    me.vel = Vels[0]
  when "a"
    me.vel = Vels[2]
  when "s"
    me.vel = Vels[1]
  when "d"
    me.vel = Vels[3]
  when "x"
    me.vel = Vels[4]
  when "e"
    me.shoot()
  end
end

update do

 me.update()

  for i in me.bullets
    i.update()
  end

end

show
