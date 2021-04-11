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
    self.container = {
      getAbsoluteLeft = function()
        return 0
      end;

      getAbsoluteTop = function()
        return 0
      end;
    }
  end;

  update = function(self, dt)
    if self.interactive then
      self:checkMouseOver()
    end
  end;

  checkMouseOver = function(self)
    local mx, my = love.mouse.getVirtualPosition()

    if mx > self:getAbsoluteLeft() and mx < self:getAbsoluteLeft() + self.width and my > self:getAbsoluteTop() and my < self:getAbsoluteTop() + self.height then
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

  getLeft = function(self)
    return self.x - self.anchorX
  end;

  getTop = function(self)
    return self.y - self.anchorY
  end;

  setLeft = function(self, left)
    self.x = left + self.anchorX
  end;

  setTop = function(self, top)
    self.y = top + self.anchorY
  end;

  getAbsoluteLeft = function(self)
    return self.container:getAbsoluteLeft() + self:getLeft()
  end;

  getAbsoluteTop = function(self)
    return self.container:getAbsoluteTop() + self:getTop()
  end;

  onMouseOverEnter = function(self) end;
  onMouseOverExit = function(self) end;
  drawComponent = function(self) end;
  destroy = function(self) end;
}
