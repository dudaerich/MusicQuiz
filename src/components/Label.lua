Label = Class { __includes = Component,

  init = function(self, text, fg, bg, font)
    Component.init(self)
    self.text = text
    self.fg = fg
    self.bg = bg
    self.font = font
  end;

  drawComponent = function(self)
    love.graphics.setColor(self.bg.r, self.bg.g, self.bg.b, self.bg.a)
    love.graphics.rectangle('fill', 0, 0, self.width, self.height)
    love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
    love.graphics.setFont(self.font)
    love.graphics.printf(tostring(self.text), 0, self.height / 2 - 15, self.width, 'center')
  end;
}
