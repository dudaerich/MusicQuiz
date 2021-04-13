CardState = Class { __includes = State,

    init = function(self)
        self.panelWidth = 700
        self.panelHeight = 500
        self.panelX = (VIRTUAL_WIDTH - self.panelWidth) / 2
        self.panelY = (VIRTUAL_HEIGHT - self.panelHeight) / 2 - 20
        self.panelColor = Color.YELLOW

        self.mainGrid = Grid(self.panelWidth, self.panelHeight, 1)
        self.mainGrid.x = self.panelX
        self.mainGrid.y = self.panelY

        self.answers = Grid(self.panelWidth, 100, 2)

        self.playBtn = Label("Play", Color.BLACK, Color.TRANSPARENT, fonts.large)
        self.playBtn.width = self.panelWidth
        self.playBtn.height = 300

        self.passBtn = Label("Pass", Color.BLACK, Color.TRANSPARENT, fonts.medium)
        self.passBtn.width = 200
        self.passBtn.height = 100

        self.failBtn = Label("Fail", Color.BLACK, Color.TRANSPARENT, fonts.medium)
        self.failBtn.width = 200
        self.failBtn.height = 100

        self.mainGrid:addComponent(self.playBtn)
        self.mainGrid:addComponent(self.answers)
        self.answers:addComponent(self.passBtn)
        self.answers:addComponent(self.failBtn)

        self.mainGrid:reposition()
        self.answers:reposition()
    end;

    enter = function(self, params)
        State.enter(self, params)
        local song = params.song
        local duration = song:getDuration("seconds")
        local startPosition = math.random(30, duration - 30)

        song:seek(startPosition, "seconds")
        song:play()
        Timer.after(10, function() song:stop() end)
    end;

    update = function(self, dt)
        State.update(self, dt)
        self.mainGrid:update(dt)
    end;

    draw = function(self)
        State.update(self)

        love.graphics.setColor(self.panelColor.r, self.panelColor.g, self.panelColor.b, self.panelColor.a)
        love.graphics.rectangle("fill", self.panelX, self.panelY, self.panelWidth, self.panelHeight)
        self.mainGrid:draw()
    end

}