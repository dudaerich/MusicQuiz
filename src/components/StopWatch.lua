StopWatch = Class { __includes = Component,

    init = function(self, time)
        Component.init(self)
        self.time = time
        self.timer = 0
        self.started = false
        self.bg = Image(images.stopWatch.bg)
        self.fg = Image(images.stopWatch.fg)
        self.needle = Image(images.stopWatch.needle)
        self.needle.anchorX = self.needle.width / 2
        self.needle.anchorY = 119
        self.needle.x = self.bg.width / 2
        self.needle.y = 119

        self.width = self.bg.width
        self.height = self.bg.height

        self.onEnd = function() end
    end;

    start = function(self)
        self.started = true
        sounds.clockTicking:seek(0)
        sounds.clockTicking:play()
    end;

    stop = function(self)
        self.started = false
        sounds.clockTicking:stop()
    end;

    reset = function(self)
        self.timer = 0
        self.started = false
        self:__setNeedleRotation(self.timer)
    end;

    update = function(self, dt)
        Component.update(self, dt)

        if self.started then
            self.timer = self.timer + dt
            self:__setNeedleRotation(self.timer)

            if self.timer >= self.time then
                self.onEnd()
                self:stop()
                self.timer = self.time
                self:__setNeedleRotation(self.timer)
            end
        end
    end;

    __setNeedleRotation = function(self, timer)
        local ratio = timer / self.time
        self.needle.rotation = math.pi * 2 * ratio
    end;

    drawComponent = function(self)
        Component.drawComponent(self)
        self.bg:draw()
        love.graphics.setColor(Color.RED.r, Color.RED.g, Color.RED.b, Color.RED.a)
        love.graphics.arc("fill", self.needle.x, self.needle.y, 55, -math.pi/2, self.needle.rotation - math.pi/2)
        self.fg:draw()
        self.needle:draw()
    end;

}