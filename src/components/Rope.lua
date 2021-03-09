Rope = Class { __includes = Component,

  init = function(self)
    Component.init(self)
    self.img = love.graphics.newImage('assets/images/rope.png')
    self.imgWidth, self.imgHeight = self.img:getDimensions()
    self.step = self.imgWidth / 3
    self.x1 = 0
    self.y1 = 0
    self.x2 = 0
    self.y2 = 0
    self.length = 0
  end;

  update = function(self, dt)
    Component.update(self, dt)
    self.length = math.sqrt(math.pow(self.x1 - self.x2, 2) + math.pow(self.y1 - self.y2, 2))
    self.width = self.length
    self.height = self.imgHeight
    self.anchorX = self.width / 2
    self.anchorY = self.height / 2
    self.x = (self.x1 + self.x2) / 2
    self.y = (self.y1 + self.y2) / 2
    self.rotation = math.atan2(self.y1 - self.y2, self.x1 - self.x2)
  end;

  drawComponent = function(self)
    local cx = 0
    while cx + self.imgWidth < self.length do
        love.graphics.draw(self.img, cx, 0)
        cx = cx + self.step
    end
  end;
}
