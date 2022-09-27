SingleLineImageLabel = Class { __includes = Component,

    init = function(self, text, fg, bg, font, margin)
        Component.init(self)
        self.text = text
        self.fg = fg
        self.bg = bg
        self.font = font
        self.margin = margin
        self.width, self.height = self.bg:getDimensions()
        self.width = self.width - 2 * margin
        self.height = self.height - 2 * margin
        self.interactive = true
        self.textPosition = 0
        self.textMoveSpeed = 40
        self.fontHeight = self.font:getHeight()
        self.textWidth = self.font:getWidth(self.text)
        self.gapBetweenTexts = 50
    end;

    onMouseOverExit = function(self)
        self.textPosition = 0
    end;

    update = function(self, dt)
        if (self.mouseOver) then
            self.textPosition = self.textPosition - dt * self.textMoveSpeed

            if (self.textPosition < -self.textWidth) then
                self.textPosition = self.textPosition + self.textWidth + self.gapBetweenTexts
            end
        end
    end;

    drawComponent = function(self)

        local textStencilFunction = function()
            love.graphics.rectangle("fill", self.margin, self.margin, self.width, self.height)
        end;

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.bg, 0, 0)

        if (self.mouseOver and self.textWidth >= self.width) then
            love.graphics.stencil(textStencilFunction, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
            love.graphics.setFont(self.font)
            love.graphics.print(tostring(self.text), self.margin + self.textPosition, self.margin + (self.height - self.fontHeight) / 2)
            love.graphics.print(tostring(self.text), self.margin + self.textWidth + self.gapBetweenTexts + self.textPosition, self.margin + (self.height - self.fontHeight) / 2)
            love.graphics.setStencilTest()
        else
            love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
            love.graphics.setFont(self.font)
            love.graphics.printf(tostring(self:getText()), self.margin, self.margin + (self.height - self.fontHeight) / 2, self.width, 'center')
        end
    end;

    getText = function(self)
        if (self.textWidth < self.width) then
            return self.text
        else
            return love.cropText(self.font, self.text, self.width)
        end
    end;

}