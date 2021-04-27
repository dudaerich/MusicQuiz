Card = Class { __includes = Button,

  init = function(self, text)
    Button.init(self, text, Color.BLACK, Color.YELLOW, fonts.medium)
    self.imgDefault = love.graphics.newImage('assets/images/card.png')
    self.imgFocus = love.graphics.newImage('assets/images/card-focus.png')
    self.img = self.imgDefault
    self.song = testSong
  end;

  onMouseOverEnter = function(self)
    self.img = self.imgFocus
    self.z = 100
  end;

  onMouseOverExit = function(self)
      self.img = self.imgDefault
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
    Button.update(self, dt)
    
    if self.scaleX < 0 then
      self.text = ""
    end
  end;

  drawComponent = function(self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.img, 0, 0)
    love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
    love.graphics.setFont(self.font)
    love.graphics.printf(tostring(self.text), 0, self.height / 2 - 25, self.width, 'center')
  end;
}
