PlayState = Class { __includes = State,
    init = function(self)
        State.init(self)

        self.board = Board()
        self.grid = Grid(self.board:getWidth() - 200, self.board:getHeight() - 70, 1, 0, 0)
        -- self.grid.bg = Color.YELLOW
        self.cardGrid = Grid(self.grid.width, self.grid.height - 130, 11)
        -- self.cardGrid.bg = Color.RED

        -- title = Label('Team 1', Color.BLACK, Color(40/255, 45/255, 52/255, 255/255))
        self.woodFont = love.graphics.newFont('assets/fonts/wood.ttf', 30)
        self.title = Label(gameStatus:getCurrentTeam():getName(), Color.BLACK, Color.TRANSPARENT, self.woodFont)
        self.title.width = self.grid.width
        self.title.height = 50

        gameStatus:registerTeamChangeListener(function() self.title.text = gameStatus:getCurrentTeam():getName() end)

        self.grid:addComponent(self.title)
        self.grid:addComponent(self.cardGrid)

        local cards = {}

        for i, category in ipairs(game:getCategories()) do
            local label = Label(category:getTitle(), Color.BLACK, Color.TRANSPARENT, self.woodFont)
            label.width = 200
            label.height = 50
            self.cardGrid:addComponent(label)

            for j, song in ipairs(category:getSongs()) do
                local card = Card(j, song)
                card.width = 70
                card.height = 60
                card.anchorX = card.width / 2
                card.anchorY = card.height / 2
                card.visible = not gameStatus:wasSongPlayed(song)

                self.cardGrid:addComponent(card)
                table.insert(cards, card)
            end
        end

        self.grid:reposition()
        self.cardGrid:reposition()

        self.grid.anchorX = self.grid.width / 2
        self.grid.anchorY = self.grid.height / 2

        for _, card in ipairs(cards) do
            local pin = Image(images.pin)
            pin.anchorX = pin.width * 0.4
            pin.anchorY = pin.height
            pin.x = card.x
            pin.y = card.y - card.anchorY + 15
            pin.z = 500
            self.cardGrid:addComponent(pin)
        end

        self.scoreButton = ImageButton(images.scoreButton)
        self.scoreButton.anchorX = self.scoreButton.width / 2
        self.scoreButton.anchorY = self.scoreButton.height / 2
        self.scoreButton.x = VIRTUAL_WIDTH - 60
        self.scoreButton.y = VIRTUAL_HEIGHT - 60
        self.scoreButton.visible = false
        self.scoreButton.onLeftClick = function()
            self.scoreButton.visible = false
            self.breakButton.visible = false
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
                    self.switchToScoreState = true
                end
            )()
        end;

        self.breakButton = ImageButton(images.breakButton)
        self.breakButton.anchorX = self.breakButton.width / 2
        self.breakButton.anchorY = self.breakButton.height / 2
        self.breakButton.x = VIRTUAL_WIDTH - 140
        self.breakButton.y = VIRTUAL_HEIGHT - 60
        self.breakButton.visible = false
        self.breakButton.onLeftClick = function()
            self.scoreButton.visible = false
            self.breakButton.visible = false
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
                    self.switchToBreakState = true
                end
            )()
        end;

    end;

    enter = function(self)
        State.enter(self)

        self.switchToScoreState = false
        self.switchToBreakState = false
        self.timers = {}

        self.board:playFallDown()

        Chain(
            function(go)
                Timer.after(5, go):group(self.timers)
            end,
            function(go)
                self.scoreButton.visible = true
                self.breakButton.visible = true
                Timer.tween(0.5, {
                    [self.scoreButton] = {
                        scaleX = 1.5,
                        scaleY = 1.5
                    },
                    [self.breakButton] = {
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
                    [self.scoreButton] = {
                        scaleX = 1,
                        scaleY = 1
                    },
                    [self.breakButton] = {
                        scaleX = 1,
                        scaleY = 1
                    }
                })
                :ease(Easing.inExpo)
                :group(self.timers)
                :finish(go)
            end,
            function(go)
                self.scoreButton.interactive = true
                self.breakButton.interactive = true
            end
        )()
    end;

    exit = function(self, params)
        self.board:destroy()
        self.scoreButton:reset()
        self.breakButton:reset()
        Timer.clear(self.timers)
        self.timers = {}
    end;

    inputCheck = function(self, key)
        State.inputCheck(self, key)
        self.grid:interact()
        self.scoreButton:interact()
        self.breakButton:interact()
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
        self.board:update(dt)

        self.grid.x = self.board:getCenterX()
        self.grid.y = self.board:getCenterY()
        self.grid.rotation = self.board:getRotation()

        self.grid:update(dt)
        self.scoreButton:update(dt)
        self.breakButton:update(dt)

        if self.switchToScoreState then
            stateMachine:pop()
            stateMachine:push('scoreState')
        end

        if self.switchToBreakState then
            stateMachine:pop()
            stateMachine:push('breakState')
        end
    end;

    draw = function(self)
        self.board:draw()
        self.grid:draw()
        self.scoreButton:draw()
        self.breakButton:draw()
    end;
}