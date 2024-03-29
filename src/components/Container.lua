Container = Class { __includes = Component,

  init = function(self)
    Component.init(self)
    self.components = {}
  end;

  addComponent = function(self, component)
    component.addedPos = #self.components
    table.insert(self.components, component)
    component.container = self
  end;

  getComponents = function(self)
    return self.components
  end;

  clear = function(self)
    self.components = {}
  end;

  interact = function(self)
    Component.interact(self)

    for i, component in ipairs(self.components) do
      component:interact()
    end
  end;

  update = function(self, dt)
    Component.update(self, dt)

    for i, component in ipairs(self.components) do
      component:update(dt)
    end
  end;

  drawComponent = function(self)
    Component.drawComponent(self)
    -- useful for debugging
    if self.bg then
      love.graphics.setColor(self.bg.r, self.bg.g, self.bg.b, self.bg.a)
      love.graphics.rectangle('fill', 0, 0, self.width, self.height)
    end
    table.sort(self.components, function (a, b) return a.z < b.z end)
    for i, component in ipairs(self.components) do
      component:draw()
    end
  end;

}
