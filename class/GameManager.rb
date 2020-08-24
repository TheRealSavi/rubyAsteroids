class GameManager
  @@asteroids = []
  @@ships = []
  @@running = false

  @@controls = [
    ["w","a","s","d","e","r"],
    ["i","j","k","l","o","p"],
  ]
  @@startScreenUI = nil

  def self.start
    @@startScreenUI = Ui.new()
  end

  def self.startGame
    if @@running == false
      WaveManager.setWave(@@startScreenUI.getStartWave())
      @@startScreenUI.getShipCount().times do |i|
        @@ships.push(Ship.new(3, Pos.new(Window.width/2,Window.height/2),@@controls[i],i))
      end
      @@running = true
    end
  end

  def self.endGame
    @@running = false
  end

  def self.isRunning
    return @@running
  end

  def self.getShips
    return @@ships
  end

  def self.getAsteroids
    return @@asteroids
  end

  def self.getControlCount
    return @@controls.count
  end

end
