Container = Class { __includes = Component,

  init = function(self)
    Component.init(self)
    self.components = {}
    self.length = 0
  end;

  addComponent = function(self, component)
    table.insert(self.components, component)
    self.length = self.length + 1
  end;

  update = function(self, dt)
    for i, component in ipairs(self.components) do
      component:update(dt)
    end
  end;

  draw = function(self)
    for i, component in ipairs(self.components) do
      component:draw()
    end
  end;

}
