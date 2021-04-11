Container = Class { __includes = Component,

  init = function(self)
    Component.init(self)
    self.components = {}
  end;

  addComponent = function(self, component)
    table.insert(self.components, component)
    component.container = self
  end;

  update = function(self, dt)
    for i, component in ipairs(self.components) do
      component:update(dt)
    end
  end;

  drawComponent = function(self)
    -- love.graphics.setColor(self.bg.r, self.bg.g, self.bg.b, self.bg.a)
    -- love.graphics.rectangle('fill', 0, 0, self.width, self.height)
    for i, component in ipairs(self.components) do
      component:draw()
    end
  end;

}
