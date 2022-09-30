Card = Class { __includes = Button,

  init = function(self, text, song)
    Button.init(self, text, Color.BLACK, Color.YELLOW, fonts.medium)
    self.imgDefault = images.card
    self.imgFocus = images.cardFocus
    self.img = self.imgDefault
    self.width, self.height = self.img:getDimensions()
    self.song = song


    self.mainGrid = Grid(self.width, self.height, 1, "auto", "auto")

    local points = Label(self:getPointsText(), Color.BLACK, Color.TRANSPARENT, fonts.medium)
    points.scaleX = -0.1
    points.scaleY = 0.1
    points.anchorX = points.width / 2
    points.anchorY = points.height / 2

    local pointsRow = Grid(self.mainGrid.width, points:getHeight(), 1)
    pointsRow:addComponent(points)
    pointsRow:reposition()
    self.mainGrid:addComponent(pointsRow)

    local goldBar = Image(images.goldBar)
    goldBar.scaleX = -0.1
    goldBar.scaleY = 0.1
    goldBar.anchorX = goldBar.width / 2
    goldBar.anchorY = goldBar.height / 2

    local goldBarRow = Grid(self.mainGrid.width, goldBar:getHeight(), 1)
    goldBarRow:addComponent(goldBar)
    goldBarRow:reposition()
    self.mainGrid:addComponent(goldBarRow)

    local closeButton = ImageButton(images.closeButton)
    closeButton.scaleX = -0.1
    closeButton.scaleY = 0.1
    closeButton.anchorX = closeButton.width / 2
    closeButton.anchorY = closeButton.height / 2

    local closeButtonRow = Grid(self.mainGrid.width, closeButton:getHeight(), 1)
    closeButtonRow:addComponent(closeButton)
    closeButtonRow:reposition()
    self.mainGrid:addComponent(closeButtonRow)

    self.mainGrid:reposition()

  end;

  getPointsText = function(self)
    local maxPoints = self.song.maxPoints

    if maxPoints == 1 then
      return "+1 bod"
    elseif maxPoints > 1 and maxPoints < 5 then
      return "+" .. maxPoints .. " body"
    else
      return "+" .. maxPoints .. " bodov"
    end
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
        if (self.song.type == "gold bar") then
          stateMachine:push('goldBarState', {song = self.song})
        else
          stateMachine:push('cardState', {song = self.song})
        end
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

    if self.scaleX < 0 and self.song.type == "gold bar" then
      self.mainGrid:draw()
    end
  end;
}
