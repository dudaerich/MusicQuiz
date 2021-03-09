Component = Class {
  init = function(self)
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.anchorX = 0
    self.anchorY = 0
    self.scale = 1
    self.rotation = 0
    self.interactive = false
    self.mouseOver = false
  end;

  update = function(self, dt)
    if self.interactive then
      self:checkMouseOver()
    end
  end;

  checkMouseOver = function(self)
    local mx, my = love.mouse.getVirtualPosition()

    if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
      if not self.mouseOver then
        self:onMouseOverEnter()
        self.mouseOver = true
      end
    else
      if self.mouseOver then
        self:onMouseOverExit()
        self.mouseOver = false
      end
    end
  end;

  draw = function(self)
    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scale)
    love.graphics.rotate(self.rotation)
    love.graphics.translate(-self.anchorX, -self.anchorY)

    self:drawComponent()

    love.graphics.pop()
  end;

  onMouseOverEnter = function(self) end;
  onMouseOverExit = function(self) end;
  drawComponent = function(self) end;
}
