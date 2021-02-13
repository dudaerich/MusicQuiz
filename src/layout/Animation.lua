Animation = Class { __includes = Component,

    init = function(self, sprite, frames, speed)
        Component.init(self)
        self.sprite = sprite
        self.frames = frames
        self.speed = speed
        self.timer = 0
        self.currentFrame = 0
        self.quads = {}
    
        local spriteWidth, spriteHeight = sprite:getDimensions()
        local frameWidth = spriteWidth / frames

        for i = 0, frames - 1 do
            self.quads[i] = love.graphics.newQuad(i * frameWidth, 0, frameWidth, spriteHeight, spriteWidth, spriteHeight)
        end
    end;

    update = function(self, dt)
        self.timer = self.timer + dt

        while self.timer > self.speed do
            self.timer = self.timer - self.speed
            self.currentFrame = (self.currentFrame + 1) % self.frames
        end

    end;

    drawComponent = function(self)
        love.graphics.draw(self.sprite, self.quads[self.currentFrame], 0, 0)
    end;
}