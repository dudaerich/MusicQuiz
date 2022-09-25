BreakState = Class { __includes = State,
    init = function(self)
        State.init(self)
    end;

    enter = function(self)
        State.enter(self)

        self.switchToPlayState = false
        self.timers = {}

        self.board = Board()

        self.grid = Grid(self.board:getWidth() - 200, self.board:getHeight() - 70, 1, 0, 0)
        -- self.grid.bg = Color.YELLOW
        self.songsGrid = Grid(self.grid.width, self.grid.height - 130, 2)
        self.songsGrid.maxItems = 10
        -- self.songsGrid.bg = Color.RED

        self.woodFont = love.graphics.newFont('assets/fonts/wood.ttf', 30)
        self.title = Label('Prestavka', Color.BLACK, Color.TRANSPARENT, self.woodFont)
        self.title.width = self.grid.width
        self.title.height = 50

        self.grid:addComponent(self.title)
        self.grid:addComponent(self.songsGrid)

        for i, song in pairs(gameStatus:getPlayedSongsBeforeBreak()) do
            local songLabel = SongButton(song)
            songLabel.anchorX = songLabel.width / 2
            songLabel.anchorY = songLabel.height / 2

            self.songsGrid:addComponent(songLabel)
        end

        self.grid:reposition()
        self.songsGrid:reposition()

        self.grid.anchorX = self.grid.width / 2
        self.grid.anchorY = self.grid.height / 2

        self.closeButton = ImageButton(images.closeButton)
        self.closeButton.anchorX = self.closeButton.width / 2
        self.closeButton.anchorY = self.closeButton.height / 2
        self.closeButton.x = VIRTUAL_WIDTH - 60
        self.closeButton.y = VIRTUAL_HEIGHT - 60
        self.closeButton.visible = false
        self.closeButton.onLeftClick = function()
            self.closeButton.visible = false
            self.board.forceY = self.board:getCenterY()
            Chain(
                function(go)
                    Timer.tween(1, {
                        [self.board] = {
                            forceY = -self.board:getHeight()/2
                        }
                    })
                    :group(self.timers)
                    :finish(go)
                end,
                function(go)
                    self.switchToPlayState = true
                end
            )()
        end;

        self.previousPageBtn = ImageButton(images.leftArrowButton)
        self.previousPageBtn.visible = self.songsGrid:hasPreviousPage()
        self.previousPageBtn.anchorX = self.previousPageBtn.width / 2
        self.previousPageBtn.anchorY = self.previousPageBtn.height / 2
        self.previousPageBtn.x = 0
        self.previousPageBtn.y = self.grid:getHeight() / 2

        self.nextPageBtn = ImageButton(images.rightArrowButton)
        self.nextPageBtn.visible = self.songsGrid:hasNextPage()
        self.nextPageBtn.anchorX = self.nextPageBtn.width / 2
        self.nextPageBtn.anchorY = self.nextPageBtn.height / 2
        self.nextPageBtn.x = self.grid:getWidth() + 20
        self.nextPageBtn.y = self.grid:getHeight() / 2


        self.previousPageBtn.onLeftClick = function()
            self.songsGrid:previousPage()
            self.previousPageBtn.visible = self.songsGrid:hasPreviousPage()
            self.nextPageBtn.visible = self.songsGrid:hasNextPage()
        end

        self.nextPageBtn.onLeftClick = function()
            self.songsGrid:nextPage()
            self.previousPageBtn.visible = self.songsGrid:hasPreviousPage()
            self.nextPageBtn.visible = self.songsGrid:hasNextPage()
        end


        self.grid:addStaticComponent(self.previousPageBtn)
        self.grid:addStaticComponent(self.nextPageBtn)

        self.board:playFallDown()

        self.grid.x = self.board:getCenterX()
        self.grid.y = self.board:getCenterY()
        self.grid.rotation = self.board:getRotation()

        Chain(
            function(go)
                Timer.after(5, go):group(self.timers)
            end,
            function(go)
                self.closeButton.visible = true
                Timer.tween(0.5, {
                    [self.closeButton] = {
                        scaleX = 1.5,
                        scaleY = 1.5
                    }
                })
                :ease(Easing.outExpo)
                :group(self.timers)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.2, {
                    [self.closeButton] = {
                        scaleX = 1,
                        scaleY = 1
                    }
                })
                :ease(Easing.inExpo)
                :group(self.timers)
                :finish(go)
            end,
            function(go)
                self.closeButton.interactive = true
            end
        )()
    end;

    exit = function(self)
        self.board:destroy()
        if (SongButton.playingSong ~= nil) then
            SongButton.playingSong:getStream():pause()
            SongButton.playingSong = nil
        end
    end;

    inputCheck = function(self, key)
        State.inputCheck(self, key)
        self.grid:interact()
        self.closeButton:interact()
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
        self.board:update(dt)

        self.grid.x = self.board:getCenterX()
        self.grid.y = self.board:getCenterY()
        self.grid.rotation = self.board:getRotation()

        self.grid:update(dt)
        self.closeButton:update(dt)

        if self.switchToPlayState then
            stateMachine:pop()
            stateMachine:push('play')
        end
    end;

    draw = function(self)
        self.board:draw()
        self.grid:draw()
        self.closeButton:draw()
    end;
}