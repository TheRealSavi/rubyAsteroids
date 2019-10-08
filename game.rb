require 'ruby2d'

set width: 1680, height:1050
set title: "Asteroids", fullscreen:true, background: '#061c2b'

#imports classes
require_relative 'class/Asteroid.rb'
require_relative 'class/Bullet.rb'
require_relative 'class/Ship.rb'
require_relative 'class/Com.rb'

#imports sounds
$downgrade = Sound.new('sounds/downgrade.mp3')
$speedUp   = Sound.new('sounds/speedUp.mp3')
$triple    = Sound.new('sounds/triple.mp3')
$crash     = Sound.new('sounds/crash.mp3')
$boom      = Sound.new('sounds/boom.mp3')
$pew       = Sound.new('sounds/pew.mp3')
$lifeUp    = Sound.new('sounds/1up.mp3')

#initializes global variables
$asteroids = []
$ships = []
$stop = false
$wave = 0
$waveUI = Text.new("")

$setup = [
  ["w","a","s","d","e"]#,
 #["i","j","k","l","p"]
]

#adds the ships
$setup.count.times do |i|
  $ships.push(Ship.new(3, Pos.new(Window.width/2,Window.height/2),$setup[i],i))
end

#this is a ruby2d event that is called every time a key is pushed down. it gets passed the key that was pushed in the event var
on :key_down do |event|
  $ships.each do |i|       #this goes through all the ships so they are all controlled at once
    if i.lerps == 0        #if the current ship isnt animating then check for key input
      case event.key
      when i.Control["forward"]
        i.vel = Pos.new(0,-i.speed)
        i.changeDir(270)
      when i.Control["left"]
        i.vel = Pos.new(-i.speed,0)
        i.changeDir(180)
      when i.Control["backward"]
        i.vel = Pos.new(0,i.speed)
        i.changeDir(90)
      when i.Control["right"]
        i.vel = Pos.new(i.speed,0)
        i.changeDir(0)
      when i.Control["shoot"]
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
  if !$stop

    if $asteroids.length <= 0
      $wave += 1

      $waveUI.remove
      $waveUI = Text.new($wave.to_s, x: Window.width-($wave.to_s.length * 80), y: Window.height-80, z:255, size:80, color: '#fc5656')
      $waveUI.add

      Thread.new {
        ($wave*2).times do |i|
          $waveUI.color = '#a4fc56'
          $asteroids.push(Asteroid.new([128,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
          sleep(0.2)
          $waveUI.color = '#fc5656'
        end
      }
    end

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
