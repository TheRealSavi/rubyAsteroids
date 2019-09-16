require 'ruby2d'
set width: 1280, height:720
set title: "Asteroids", fullscreen:true, background: '#061c2b'

require_relative 'class/Asteroid.rb'
require_relative 'class/Bullet.rb'
require_relative 'class/Ship.rb'
require_relative 'class/Com.rb'

#this initializes the arrays
$asteroids = []
ships = []

#this addes a new ship to the ships array so the game can be played lol
ships.push(Ship.new(3, Pos.new(Window.width/2-20,Window.height-40),'lime'))
#this adds the first asteroid to the asteroids array so something can be shot
4.times do
  $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
end
#this is a ruby2d event that is called every time a key is pushed down. it gets passed the key that was pushed in the event var
on :key_down do |event|
  #this goes through all the ships so they are all controlled at once
  for i in ships
    #if the current ship isnt animating then check for keys
    if i.lerps == 0
      case event.key
        when "w"
          #this is change the current ships velocity to a new vector that has a value of 0 in the x
          #and a negative version of the ships speed in the y
          #then it changes the ships direction identifier to the new direction
          #it is the same idea for all the other velocity changes
          i.vel = Pos.new(0,-i.speed)
          i.changeDir("w")
        when "a"
          i.vel = Pos.new(-i.speed,0)
          i.changeDir("a")
        when "s"
          i.vel = Pos.new(0,i.speed)
          i.changeDir("s")
        when "d"
          i.vel = Pos.new(i.speed,0)
          i.changeDir("d")
        when "e"
          #this calls that ships shoot function which creates a bullet object and adds it to that ships bullets array
          i.shoot()
        when "x"
          #this creates a new asteroid and adds it to the asteroids array
          $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
      end
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
