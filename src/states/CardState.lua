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
        self.playBtn.visible = false

        self.passBtn = Button("Pass", Color.GREEN, Color.TRANSPARENT, fonts.medium)
        self.passBtn.width = 200
        self.passBtn.height = 100
        self.passBtn.anchorX = self.passBtn.width / 2
        self.passBtn.anchorY = self.passBtn.height / 2
        self.passBtn.onLeftClick = function(self)
            stateMachine:pop()
        end

        self.failBtn = Button("Fail", Color.RED, Color.TRANSPARENT, fonts.medium)
        self.failBtn.width = 200
        self.failBtn.height = 100
        self.failBtn.anchorX = self.failBtn.width / 2
        self.failBtn.anchorY = self.failBtn.height / 2
        self.failBtn.onLeftClick = function(self)
            stateMachine:pop()
        end

        self.mainGrid:addComponent(self.playBtn)
        self.mainGrid:addComponent(self.answers)
        self.answers:addComponent(self.passBtn)
        self.answers:addComponent(self.failBtn)

        self.mainGrid:reposition()
        self.answers:reposition()

        self.timers = {}
    end;

    enter = function(self, params)
        State.enter(self, params)

        self.passBtn:reset()
        self.failBtn:reset()

        function playSong()
            self.song = params.song
            local duration = self.song:getDuration("seconds")
            local startPosition = math.random(30, duration - 30)

            self.song:seek(startPosition, "seconds")
            self.song:play()

            function stopSongLocal()
                self:stopSong()
            end

            Timer.after(10, stopSongLocal):group(self.timers)
        end

        stateMachine:push('countDownState', {onFinish = playSong})
    end;

    stopSong = function(self)
        if self.song then
            self.song:stop()
            self.song = nil
        end
    end;

    exit = function(self)
        self:stopSong()
        Timer.clear(self.timers)
        self.timers = {}
    end;

    inputCheck = function(self, key)
        State.inputCheck(self, key)
        self.mainGrid:interact()
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
    end;

    draw = function(self)
        State.draw(self)

        love.graphics.setColor(self.panelColor.r, self.panelColor.g, self.panelColor.b, self.panelColor.a)
        love.graphics.rectangle("fill", self.panelX, self.panelY, self.panelWidth, self.panelHeight)
        self.mainGrid:draw()
    end

}