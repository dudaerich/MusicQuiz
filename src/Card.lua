Card = Class { __includes = Label,

  init = function(self, text)
    Label.init(self, text, Color.BLACK, Color.YELLOW)
    self.interactive = true
    self.text = text
  end;

  onMouseOverEnter = function(self)
    self.scale = 1.5
  end;

  onMouseOverExit = function(self)
    self.scale = 1
  end;
}

-- function Card:init(text)
--
--   -- self.rotationSpeed = 1
--   -- self.moveSpeed = 1
--   -- self.maxRotation = math.rad(6)
--   -- self.maxMove = 20
--   -- self.move = 0
--   -- self.rotationTime = 0
--   -- self.moveTime = 0
-- end

--function Card:update(dt)
  -- self.rotationTime = self.rotationTime + dt * self.rotationSpeed
  -- self.moveTime = self.moveTime + dt * self.moveSpeed
  --
  -- if (self.rotationTime > math.pi * 2) then
  --   self.rotationTime = self.rotationTime - math.pi * 2
  -- end
  --
  -- if (self.moveTime > math.pi * 2) then
  --   self.moveTime = self.moveTime - math.pi * 2
  -- end
  --
  --
  -- --self.rotation = self.maxRotation * math.sin(self.rotationTime)
  -- self.move = self.maxMove * math.sin(self.moveTime)
  --
  -- local mx, my = love.mouse.getVirtualPosition()
  --
  -- if mx > self.x and mx < self.x + self.width and my > self.y + self.move and my < self.y + self.move + self.height then
  --   self.scale = 1.5
  -- else
  --   self.scale = 1
  -- end
--end
