PlayState = Class { __includes = State,
    init = function(self)
        self.boardX = VIRTUAL_WIDTH / 2
        self.boardY = -VIRTUAL_HEIGHT
        self.boardImg = love.graphics.newImage('assets/images/board.png')
        self.boardWidth, self.boardHeight = self.boardImg:getDimensions()
        self.studShift = 300
        self.studLeftX = (VIRTUAL_WIDTH/2) - self.studShift
        self.studRightX = (VIRTUAL_WIDTH / 2) + self.studShift
        self.studY = -30
        self.studsCreated = false
        self.ropeLength = 150
        self.ropeLeft = Rope()
        self.ropeRight = Rope()
    end;

    enter = function(self)

        self.world = love.physics.newWorld(0, 300)
        self.boardBody = love.physics.newBody(self.world, VIRTUAL_WIDTH / 2, -VIRTUAL_WIDTH, "dynamic")
        self.boardBody:setAngle(0.03)
        self.boardShape = love.physics.newRectangleShape(self.boardWidth, self.boardHeight)
        self.boardFixture = love.physics.newFixture(self.boardBody, self.boardShape)
        self.studsCreated = false
    end;

    exit = function(self, params)
        -- self.boardBody:destroy()
        -- self.boardShape:destroy()
        -- self.boardFixture:destroy()
        -- self.studLeft:destroy()
        -- self.studRight:destroy()
        -- self.boardRopeJointLeft:destroy()
        -- self.boardRopeJointRight:destroy()
        -- self.boardFrictionJointLeft:destroy()
        -- self.boardFrictionJointRight:destroy()
        self.world:destroy()
    end;

    update = function(self, dt)
        self.world:update(dt)

        function createRopeJoint(body1, body2, x1, y1, x2, y2, maxLength)
            local x1w, y1w = body1:getWorldPoints(x1, y1)
            local x2w, y2w = body2:getWorldPoints(x2, y2)
            local ropeJoint = love.physics.newRopeJoint(body1, body2, x1w, y1w, x2w, y2w, maxLength)
            local frictionJoint = love.physics.newFrictionJoint(body1, body2, x1w, y1w, x2w, y2w)

            frictionJoint:setMaxForce(1500)
            frictionJoint:setMaxTorque(1500)

            return ropeJoint, frictionJoint
        end

        if not self.studsCreated and self.boardBody:getY() > VIRTUAL_HEIGHT / 3 then
            self.studLeft = love.physics.newBody(self.world, self.studLeftX, self.studY, "kinematic")
            self.studRight = love.physics.newBody(self.world, self.studRightX, self.studY, "kinematic")
            self.boardRopeJointLeft, self.boardFrictionJointLeft = createRopeJoint(self.boardBody, self.studLeft, -self.studShift, -(self.boardHeight/2) + 50, 0, 0, self.ropeLength)
            self.boardRopeJointRight, self.boardFrictionJointRight = createRopeJoint(self.boardBody, self.studRight, self.studShift, -(self.boardHeight/2) + 50, 0, 0, self.ropeLength)
            self.studsCreated = true
        end

        if self.studsCreated then
            self.ropeLeft.x1, self.ropeLeft.y1, self.ropeLeft.x2, self.ropeLeft.y2 = self.boardRopeJointLeft:getAnchors()
            self.ropeLeft:update(dt)

            self.ropeRight.x1, self.ropeRight.y1, self.ropeRight.x2, self.ropeRight.y2 = self.boardRopeJointRight:getAnchors()
            self.ropeRight:update(dt)
        end
    end;

    draw = function(self)
        love.graphics.setColor(1, 1, 1, 1)

        if self.studsCreated then
            self.ropeLeft:draw()
            self.ropeRight:draw()
        end
        love.graphics.draw(self.boardImg, self.boardBody:getX(), self.boardBody:getY(), self.boardBody:getAngle(),  1, 1, self.boardWidth / 2, self.boardHeight / 2)
    end;
}