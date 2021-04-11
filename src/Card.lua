Card = Class { __includes = Label,

  init = function(self, text)
    local font = love.graphics.newFont('assets/fonts/font.ttf', 30)
    Label.init(self, text, Color.BLACK, Color.YELLOW, font)
    self.interactive = true
    self.text = text
    self.song = testSong
  end;

  onMouseOverEnter = function(self)
    self.scale = 1.5
    self.z = 100
  end;

  onMouseOverExit = function(self)
    self.scale = 1
    self.z = 0
  end;

  onLeftClick = function(self)
    self.interactive = false
    self.z = 1000
    Timer.tween(1, {
      [self] = {
        scale = 10,
        x = self.container:getWidth() / 2,
        y = self.container:getHeight() / 2
      }
    })
    :ease(Easing.outExpo)
    :finish(function() stateMachine:push('cardState', {song = self.song}) end)
  end;

  update = function(self, dt)
    Label.update(self, dt)
  end;
}
