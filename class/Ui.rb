class Ui
  def initialize()
    @uiBackground = Square.new(x:0,y:0,size:Window.width,color:'black',z:999)
    @uiSplash = Text.new("RUBY ASTEROIDS!",x:0, z:1000, size:Window.width/9)
    @uiShipCountConfirmButton = Button.new(displayName: 'Confirm', x:(Window.width/2), y:(Window.height/2)+30,size:10,z:1000,type:'clicker')
    @uiStartWaveSlider = Slider.new(displayName: 'Start on Wave', x:(Window.width/2)-150, y:(Window.height/2)-130,size:15,length:300,z:1000, min:1,max:50)
    @uiShipCountSlider = Slider.new(displayName: 'Ship Count', x:(Window.width/2)-150, y:(Window.height/2)-30,size:15,length:300,z:1000, min:1,max:GameManager.getControlCount())

    @shipCount = 0
    @startWave = 0

    @uiShipCountConfirmButton.onClick do
      @shipCount = @uiShipCountSlider.value.to_i
      @startWave = @uiStartWaveSlider.value.to_i - 1
      if @shipCount <= 0
        @shipCount = 1
      end
      @uiSplash.remove
      @uiBackground.remove
      @uiShipCountSlider.remove
      @uiStartWaveSlider.remove
      @uiShipCountConfirmButton.remove
      GameManager.startGame()
    end
  end

  def getShipCount
    return @shipCount
  end

  def getStartWave
    return @startWave
  end

end
