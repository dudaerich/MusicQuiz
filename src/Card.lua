Card = Class { __includes = Label,

  init = function(self, text)
    Label.init(self, text, Color.BLACK, Color.YELLOW, fonts.medium)
    self.interactive = true
    self.text = text
    self.song = testSong
  end;

  onMouseOverEnter = function(self)
    self.scaleX = 1.5
    self.scaleY = 1.5
    self.z = 100
  end;

  onMouseOverExit = function(self)
    self.scaleX = 1
    self.scaleY = 1
    self.z = 0
  end;

  onLeftClick = function(self)
    self.interactive = false
    self.z = 1000
    Chain(
      function(go)
        Timer.tween(0.5, {
          [self] = {
            scaleX = 5,
            scaleY = 5
          }
        }):finish(go)
      end,
      function(go)
        Timer.tween(0.5, {
          [self] = {
            scaleX = -10,
            scaleY = 10
          }
        })
      end
    )()

    Chain(
      function(go)
        Timer.tween(1, {
          [self] = {
            x = self.container:getWidth() / 2,
            y = self.container:getHeight() / 2
          }
        }):finish(go)
      end,
      function(go)
        self.visible = false
        stateMachine:push('cardState', {song = self.song})
      end
    )()
  end;

  update = function(self, dt)
    Label.update(self, dt)
    
    if self.scaleX < 0 then
      self.text = ""
    end
  end;
}
