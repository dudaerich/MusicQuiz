SongButton = Class { __includes = Component,

    init = function(self, song)
        Component.init(self)
        self.song = song
        self.font = fonts.medium
        self.bg = images.plate
        self.fg = Color.WHITE
        self.width, self.height = self.bg:getDimensions()
        self.width = self.width - 10
        self.height = self.height - 10
    end;

    drawComponent = function(self)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.bg, 0, 0)
        love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
        love.graphics.setFont(self.font)
        love.graphics.printf(tostring(self:getText()), 5, self.height / 2 - 20, self.width, 'center')
    end;

    getText = function(self)
        if (self.font:getWidth(self.song:getAnswer()) < self.width) then
            return self.song:getAnswer()
        else
            local outcome = self.song:getAnswer() .. ".."
            while (self.font:getWidth(outcome) >= self.width) do
                outcome = outcome:sub(1, -4) .. ".."
            end
            return outcome
        end
    end;

}