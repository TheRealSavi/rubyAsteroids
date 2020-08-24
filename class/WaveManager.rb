class WaveManager
  @@wave = 0
  @@waveLabel = Text.new(@@wave.to_s, x: Window.width - 60, y: 0, z: 998,size:50,color: "#da2929")
  @@shipsInWave = 0
  @@timer = 0
  @@shipsAdded = 0
  @@makingWave = false

  def self.getWave
    return @@wave
  end

  def self.setWave(startWave)
    @@wave = startWave
  end

  def self.isMakingWave
    return @@makingWave
  end

  def self.nextWave()
    @@wave = @@wave + 1
    @@waveLabel.text = @@wave.to_s
    @@shipsInWave = @@wave * 2 + 5
    @@makingWave = true
    @@timer = 0
    @@shipsAdded = 0
    GameManager.getShips.each do |ship|
      ship.powerUp('Immune',[0.36, 0.90, 0.71, 1], 2 + (2 * (0.2 * @@wave).to_i))
    end
  end

  def self.addShipToWave()
    @@shipsAdded = @@shipsAdded + 1
    GameManager.getAsteroids().push(Asteroid.new([96,64,32].sample, Pos.new(rand(1..Window.width-128),rand(1..Window.height-128))))
    if @@shipsAdded >= @@shipsInWave
      @@makingWave = false
    end
  end

  def self.update()
    if GameManager.getAsteroids.length <= 0 && @@makingWave == false
      self.nextWave()
    end

    if @@makingWave == true
      self.makeWave()
    end
  end

  def self.makeWave()
    if @@makingWave == true
      @@timer += 1
      if @@timer >= 15
        @@timer = 0
        self.addShipToWave()
      end
    end
  end

end
