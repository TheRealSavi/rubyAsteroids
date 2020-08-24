require 'ruby2d'
require 'savio'

set width: 1028, height: 600
set title: "Asteroids", fullscreen:false, background: '#020f18'

#imports classes
require_relative 'class/Asteroid.rb'
require_relative 'class/Bullet.rb'
require_relative 'class/Ship.rb'
require_relative 'class/Com.rb'
require_relative 'class/WaveManager.rb'
require_relative 'class/GameManager.rb'
require_relative 'class/Ui.rb'

#imports sounds
$downgrade = Sound.new('sounds/downgrade.mp3')
$speedUp   = Sound.new('sounds/speedUp.mp3')
$triple    = Sound.new('sounds/triple.mp3')
$crash     = Sound.new('sounds/crash.mp3')
$boom      = Sound.new('sounds/boom.mp3')
$pew       = Sound.new('sounds/pew.mp3')
$lifeUp    = Sound.new('sounds/1up.mp3')

GameManager.start()

#this is a ruby2d event that is called every time a key is pushed down. it gets passed the key that was pushed in the event var
on :key_down do |event|
  if GameManager.isRunning == true
    GameManager.getShips.each do |ship|      #this goes through all the ships so they are all controlled at once
      if ship.lerps == 0 && ship.isDead == false       #if the current ship isnt animating then check for key input
        case event.key
        when ship.Control["forward"]
          ship.vel = Pos.new(0,-i.speed)
          ship.changeDir(270)
        when ship.Control["left"]
          ship.vel = Pos.new(-i.speed,0)
          ship.changeDir(180)
        when i.Control["backward"]
          ship.vel = Pos.new(0,i.speed)
          ship.changeDir(90)
        when i.Control["right"]
          ship.vel = Pos.new(i.speed,0)
          ship.changeDir(0)
        when ship.Control["shoot"]
          ship.shoot()
        when i.Control["use"]
          ship.use()
        end
      end
    end
  end
end

#this is a ruby2d event that is called every frame
update do
  if GameManager.isRunning

    WaveManager.update()

    for asteroid in GameManager.getAsteroids
      asteroid.update()           #this calls all the asteroids update functions
    end

    for ship in GameManager.getShips
      ship.update()           #this updates all the ships
      for bullet in ship.bullets
        bullet.update()         #this updates all the ships bullets
      end
    end

  end
end

#this is the ruby2d method that shows the window
show()
