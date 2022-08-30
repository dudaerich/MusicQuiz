Answer = Class { __includes = Component,

    init = function(self)
        Component.init(self)

        self.bg = images.answerCover.bg
        self.fg = images.answerCover.fg
        self.fgColor = Color(1/255, 119/255, 255/255, 1)

        self.width, self.height = self.bg:getDimensions()

        self.timers = {}
        self.uncoverProgress = 0
    end;

    setText = function(self, text)
        self.text = Label(text, Color.BLACK, Color.TRANSPARENT, fonts.medium)
        self.text.width = self.width
        self.text.height = self.height
    end;

    uncover = function(self)
        Timer.tween(0.7, {
            [self] = {
                uncoverProgress = 1
            }
        })
        :group(self.timers)
    end;

    reset = function(self)
        self.uncoverProgress = 0
        Timer.clear(self.timers)
        self.timers = {}
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
    end;

    drawComponent = function(self)

        self.text:drawComponent()

        if self.uncoverProgress < 1 then
        
            if self.uncoverProgress > 0 then
                local function stencilFunction()
                    love.graphics.rectangle("fill", 15 + self.width * self.uncoverProgress, 0, self.width * (1 - self.uncoverProgress), self.height)
                end
        
                love.graphics.stencil(stencilFunction, "replace", 1)
                love.graphics.setStencilTest("greater", 0)
            end

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(self.bg, 0, 0)

            if self.uncoverProgress > 0 then
                love.graphics.setStencilTest()

                local uncoverLeft = 10 + self.width * self.uncoverProgress * 2

                love.graphics.draw(self.fg, uncoverLeft, -5)

                local fgFillLeft = 15 + self.width * self.uncoverProgress
                local fgFillTop = 1
                local fgFillWidth = self.width * self.uncoverProgress + 2
                local fgFillHeight = self.height - 3

                if fgFillLeft < uncoverLeft + 2 then
                    love.graphics.setColor(self.fgColor.r, self.fgColor.g, self.fgColor.b, self.fgColor.a)
                    love.graphics.rectangle("fill", fgFillLeft, fgFillTop, fgFillWidth, fgFillHeight)

                    love.graphics.setLineWidth(2)
                    love.graphics.setColor(0, 0, 0, 1)
                    love.graphics.line(
                        fgFillLeft + fgFillWidth, fgFillTop + fgFillHeight,
                        fgFillLeft, fgFillTop + fgFillHeight,
                        fgFillLeft, fgFillTop,
                        fgFillLeft + fgFillWidth, fgFillTop)
                end
            end

        end
    end;
}