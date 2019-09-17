require 'ruby2d'

set width: 1280, height:720
set title: "Asteroids", fullscreen:false, background: '#061c2b'

#imports classes
require_relative 'class/Asteroid.rb'
require_relative 'class/Bullet.rb'
require_relative 'class/Ship.rb'
require_relative 'class/Com.rb'

#imports sounds
$pew       = Sound.new('sounds/pew.mp3')
$crash     = Sound.new('sounds/crash.mp3')
$boom      = Sound.new('sounds/boom.mp3')
$triple    = Sound.new('sounds/triple.mp3')
$lifeUp    = Sound.new('sounds/1up.mp3')
$speedUp   = Sound.new('sounds/speedUp.mp3')
$downgrade = Sound.new('sounds/downgrade.mp3')

#initializes global variables
$asteroids = []
$ships = []
$stop = false

#this addes a new ship to the ships array so the game can be played lol
$ships.push(Ship.new(3, Pos.new(Window.width/2,Window.height/2)))

#adds a couple asteroids
4.times do
  $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
end

#this is a ruby2d event that is called every time a key is pushed down. it gets passed the key that was pushed in the event var
on :key_down do |event|
  #this goes through all the ships so they are all controlled at once
  for i in $ships
    #if the current ship isnt animating then check for key input
    if i.lerps == 0
      case event.key
        when "w"
          i.vel = Pos.new(0,-i.speed)
          i.changeDir(270)
        when "a"
          i.vel = Pos.new(-i.speed,0)
          i.changeDir(180)
        when "s"
          i.vel = Pos.new(0,i.speed)
          i.changeDir(90)
        when "d"
          i.vel = Pos.new(i.speed,0)
          i.changeDir(0)
        when "e"
          i.shoot()
        when "x"
          #this creates a new asteroid and adds it to the asteroids array
          $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
        when "l"
          #this adds a life to the ship
          i.addHealth(1)
      end
    end
  end
end

#this is a ruby2d event that is called every frame
update do
  if !$stop
    for i in $asteroids
      i.update()           #this calls all the asteroids update functions
    end
    for i in $ships
      i.update()           #this updates all the ships
      for j in i.bullets
        j.update()         #this updates all the ships bullets
      end
    end
  end
end

#this is the ruby2d method that shows the window
show
