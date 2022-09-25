SongButton = Class { __includes = Component,

    playingSong = nil;

    init = function(self, song)
        Component.init(self)
        self.song = song
        self.font = fonts.medium
        self.bg = images.plate
        self.fg = Color.WHITE
        self.playedColor = Color(209/255, 212/255, 23/255, 100/255)
        self.width, self.height = self.bg:getDimensions()
        self.width = self.width - 10
        self.height = self.height - 10
        self.interactive = true
        self.wasPlayed = false
        self.textPosition = 0
        self.textMoveSpeed = 40
        self.textWidth = self.font:getWidth(self.song:getAnswer())
        self.gapBetweenTexts = 50
        
        self.mask_effect = love.graphics.newShader[[
            vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            if (Texel(texture, texture_coords).a < 0.5) {
                // a discarded pixel wont be applied as the stencil.
                discard;
            }
            return vec4(1.0);
            }
        ]]
    end;

    onLeftClick = function(self)

        if (SongButton.playingSong == self.song) then
            self.song:getStream():pause()
            SongButton.playingSong = nil
        else
            if (SongButton.playingSong ~= nil) then
                SongButton.playingSong:getStream():pause()
            end
    
            local stream = self.song:getStream()
            stream:play()
            SongButton.playingSong = self.song
        end
    end;

    onMouseOverEnter = function(self)
        self.scaleX = 1.05
        self.scaleY = 1.05
    end;

    onMouseOverExit = function(self)
        self.scaleX = 1
        self.scaleY = 1
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

        local playedProgressStencilFunction = function()
            love.graphics.setShader(self.mask_effect)
            love.graphics.draw(self.bg, 0, 0)
            love.graphics.setShader()
        end;

        local textStencilFunction = function()
            love.graphics.rectangle("fill", 7, 0, self.width - 5, self.height)
        end;

        local played = function()
            local position = self.song:getStream():tell("seconds") / self.song:getStream():getDuration("seconds")
            if (position > 0.5) then
                self.wasPlayed = true
            end

            if (position == 0 and self.wasPlayed) then
                return 1
            else
                return position
            end
        end;

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.bg, 0, 0)

        love.graphics.stencil(playedProgressStencilFunction, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        love.graphics.setColor(self.playedColor.r, self.playedColor.g, self.playedColor.b, self.playedColor.a)
        love.graphics.rectangle("fill", 0, -10, (self.width + 10) * played(), self.height + 20)
        love.graphics.setStencilTest()

        if (self.mouseOver and self.textWidth >= self.width) then
            love.graphics.stencil(textStencilFunction, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
            love.graphics.setFont(self.font)
            love.graphics.print(tostring(self.song:getAnswer()), 5 + self.textPosition, self.height / 2 - 20)
            love.graphics.print(tostring(self.song:getAnswer()), 5 + self.textWidth + self.gapBetweenTexts + self.textPosition, self.height / 2 - 20)
            love.graphics.setStencilTest()
        else
            love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
            love.graphics.setFont(self.font)
            love.graphics.printf(tostring(self:getText()), 5, self.height / 2 - 20, self.width, 'center')
        end
    end;

    getText = function(self)
        if (self.textWidth < self.width) then
            return self.song:getAnswer()
        else
            return love.cropText(self.font, self.song:getAnswer(), self.width)
        end
    end;

}