GoldBarState = Class { __includes = State,
    init = function(self)
        State.init(self)
        self.card = Image(images.cardReverseLarge)
        self.card.x = (VIRTUAL_WIDTH - self.card.width) / 2
        self.card.y = (VIRTUAL_HEIGHT - self.card.height) / 2 - 20
        
        self.mainGrid = Grid(self.card.width, self.card.height, 1, "auto", "auto")
        self.mainGrid.x = self.card.x
        self.mainGrid.y = self.card.y

        self.points = Label("TBD", Color.BLACK, Color.TRANSPARENT, fonts.medium)

        self.pointsRow = Grid(self.mainGrid.width, self.points:getHeight(), 1)
        self.pointsRow:addComponent(self.points)
        self.pointsRow:reposition()
        self.mainGrid:addComponent(self.pointsRow)

        local goldBar = Image(images.goldBar)

        local goldBarRow = Grid(self.mainGrid.width, goldBar:getHeight(), 1)
        goldBarRow:addComponent(goldBar)
        goldBarRow:reposition()
        self.mainGrid:addComponent(goldBarRow)

        self.closeButton = ImageButton(images.closeButton)
        self.closeButton.anchorX = self.closeButton.width / 2
        self.closeButton.anchorY = self.closeButton.height / 2

        local closeButtonRow = Grid(self.mainGrid.width, self.closeButton:getHeight(), 1)
        closeButtonRow:addComponent(self.closeButton)
        closeButtonRow:reposition()
        self.mainGrid:addComponent(closeButtonRow)

        self.mainGrid:reposition()
    end;

    getPointsText = function(self, maxPoints)
        if maxPoints == 1 then
          return "+1 bod"
        elseif maxPoints > 1 and maxPoints < 5 then
          return "+" .. maxPoints .. " body"
        else
          return "+" .. maxPoints .. " bodov"
        end
    end;

    enter = function(self, params)
        State.enter(self, params)
        self.points:setText(self:getPointsText(params.song.maxPoints))
        self.pointsRow:reposition()

        self.closeButton.onLeftClick = function(self)
          gameStatus:addScoreRecordToCurrentTeam(ScoreRecord(params.song.maxPoints, params.song))
          stateMachine:pop()
        end

        self.closeButton:reset()
    end;

    exit = function(self)
      gameStatus:nextTeam()
  end;

    inputCheck = function(self, key)
        State.inputCheck(self, key)
        self.mainGrid:interact()
    end;

    update = function(self, dt)
        self.mainGrid:update(dt)
    end;

    draw = function(self)
        self.card:draw()
        self.mainGrid:draw()
    end
}