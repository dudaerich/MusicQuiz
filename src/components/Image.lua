Image = Class { __includes = Component,

  init = function(self, img)
    Component.init(self)
    self.img = img
    self.width, self.height = self.img:getDimensions()
  end;

  drawComponent = function(self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.img, 0, 0)
  end;
}
