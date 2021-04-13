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
        self.title = Label('Team One', Color.BLACK, Color.TRANSPARENT, self.woodFont)
        self.title.width = self.grid.width
        self.title.height = 50

        self.grid:addComponent(self.title)
        self.grid:addComponent(self.cardGrid)

        for i=1,5 do
            local label = Label('Category', Color.BLACK, Color.TRANSPARENT, self.woodFont)
            label.width = 200
            label.height = 50
            self.cardGrid:addComponent(label)
            for j=1,10 do

            local card = Card(j)
            card.width = 70
            card.height = 50
            card.anchorX = card.width / 2
            card.anchorY = card.height / 2
            self.cardGrid:addComponent(card)

            end
        end

        self.grid:reposition()
        self.cardGrid:reposition()

        self.grid.anchorX = self.grid.width / 2
        self.grid.anchorY = self.grid.height / 2
    end;

    enter = function(self)
        State.enter(self)
        self.board:playFallDown()
    end;

    exit = function(self, params)
        self.board:destroy()
    end;

    update = function(self, dt)
        self.board:update(dt)

        self.grid.x = self.board:getCenterX()
        self.grid.y = self.board:getCenterY()
        self.grid.rotation = self.board:getRotation()

        self.grid:update(dt)
    end;

    draw = function(self)
        self.board:draw()
        self.grid:draw()
    end;
}