class SoundManager
  @@downgrade = Music.new('sounds/downgrade.mp3')
  @@speedUp   = Music.new('sounds/speedUp.mp3')
  @@triple    = Music.new('sounds/triple.mp3')
  @@crash     = Music.new('sounds/crash.mp3')
  @@boom      = Music.new('sounds/boom.mp3')
  @@pew       = Music.new('sounds/pew.mp3')
  @@lifeUp    = Music.new('sounds/1up.mp3')

  @@currentSound = @@lifeUp;
  @@volume = 1

  def self.play(sound)
    @@currentSound.stop

    case sound
    when "downgrade"
      @@currentSound = @@downgrade
    when "speedUp"
      @@currentSound = @@speedUp
    when "triple"
      @@currentSound = @@triple
    when "crash"
      @@currentSound = @@crash
    when "boom"
      @@currentSound = @@boom
    when "pew"
      @@currentSound = @@pew
    when "lifeUp"
      @@currentSound = @@lifeUp
    end
    @@currentSound.volume = @@volume
    @@currentSound.play()
  end

  def self.setVolume(v)
    @@volume = v
  end
end
