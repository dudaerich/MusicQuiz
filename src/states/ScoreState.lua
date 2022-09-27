ScoreState = Class { __includes = State,
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
        self.teamGrid = Grid(self.grid.width, self.grid.height - 130, 2)
        -- self.teamGrid.bg = Color.RED

        -- title = Label('Team 1', Color.BLACK, Color(40/255, 45/255, 52/255, 255/255))
        self.woodFont = love.graphics.newFont('assets/fonts/wood.ttf', 30)
        self.title = ImageLabel('Skore', Color.WHITE, images.title, fonts.medium, 5)
        
        self.titleGrid = Grid(self.grid.width, self.title.height, 1)
        self.titleGrid:addComponent(self.title)

        self.grid:addComponent(self.titleGrid)
        self.grid:addComponent(self.teamGrid)

        for i, team in pairs(gameStatus:getAllTeamsOrderedByScore()) do
            local teamLabel = SingleLineImageLabel(team.name, Color.WHITE, images.plate, fonts.medium, 7)
            local scoreLabel = SingleLineImageLabel(team:getScore(), Color.WHITE, images.plateShort, fonts.medium, 7)

            self.teamGrid:addComponent(teamLabel)
            self.teamGrid:addComponent(scoreLabel)
        end

        self.grid:reposition()
        self.titleGrid:reposition()
        self.teamGrid:reposition()

        self.grid.anchorX = self.grid.width / 2
        self.grid.anchorY = self.grid.height / 2 + 60

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

        self.board:playFallDown()

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