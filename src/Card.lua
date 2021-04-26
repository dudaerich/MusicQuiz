Card = Class { __includes = Button,

  init = function(self, text)
    Button.init(self, text, Color.BLACK, Color.YELLOW, fonts.medium)
    self.song = testSong
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
    Button.update(self, dt)
    
    if self.scaleX < 0 then
      self.text = ""
    end
  end;
}
