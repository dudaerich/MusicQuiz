Component = Class {
  init = function(self)
    self.x = 0
    self.y = 0
    self.z = 0
    self.width = 0
    self.height = 0
    self.anchorX = 0
    self.anchorY = 0
    self.scaleX = 1
    self.scaleY = 1
    self.rotation = 0
    self.visible = true
    self.interactive = false
    self.mouseOver = false
    self.container = {
      getAbsoluteLeft = function()
        return 0
      end;

      getAbsoluteTop = function()
        return 0
      end;

      getWidth = function()
        return VIRTUAL_WIDTH
      end;

      getHeight = function()
        return VIRTUAL_HEIGHT
      end;
    }
  end;

  update = function(self, dt)
    if self.visible and self.interactive then
      self:checkMouseOver()
      self:checkClicks()
    end
  end;

  checkMouseOver = function(self)
    local mx, my = love.mouse.getVirtualPosition()

    if self:isCollision(mx, my) then
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

  checkClicks = function(self)
    for _, click in ipairs(love.mouse.getLeftClicks()) do
      if self:isCollision(click.x, click.y) then
        self:onLeftClick()
      end
    end
  end;

  isCollision = function(self, x, y)
    return x > self:getAbsoluteLeft() and x < self:getAbsoluteLeft() + self.width and y > self:getAbsoluteTop() and y < self:getAbsoluteTop() + self.height
  end;

  draw = function(self)
    if self.visible then
      love.graphics.push()

      love.graphics.translate(self.x, self.y)
      love.graphics.scale(self.scaleX, self.scaleY)
      love.graphics.rotate(self.rotation)
      love.graphics.translate(-self.anchorX, -self.anchorY)

      self:drawComponent()

      love.graphics.pop()
    end
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

  getWidth = function(self)
    return self.width
  end;

  getHeight = function(self)
    return self.height
  end;

  onMouseOverEnter = function(self) end;
  onMouseOverExit = function(self) end;
  onLeftClick = function(self) end;
  drawComponent = function(self) end;
  destroy = function(self) end;
}
