Board = Class { __includes = Component,

  init = function(self)
    Component.init(self)

    self.boardImg = images.board
    self.boardWidth, self.boardHeight = self.boardImg:getDimensions()
    self.studsCreated = false
  end;

  playFallDown = function(self)
    self.boardX = VIRTUAL_WIDTH / 2
    self.boardY = -VIRTUAL_HEIGHT
    self.studShift = 300
    self.studLeftX = (VIRTUAL_WIDTH/2) - self.studShift
    self.studRightX = (VIRTUAL_WIDTH / 2) + self.studShift
    self.studY = -30
    self.ropeLength = 150
    self.ropeLeft = Rope()
    self.ropeRight = Rope()

    self.world = love.physics.newWorld(0, 300)
    self.boardBody = love.physics.newBody(self.world, VIRTUAL_WIDTH / 2, -VIRTUAL_WIDTH, "dynamic")
    self.boardBody:setAngle(0.03)
    self.boardShape = love.physics.newRectangleShape(self.boardWidth, self.boardHeight)
    self.boardFixture = love.physics.newFixture(self.boardBody, self.boardShape)
    self.studsCreated = false
  end;

  destroy = function(self)
    Component.destroy(self)
    self.world:destroy()
    self.world = nil
    self.boardBody = nil
    self.studsCreated = false
    self.forceY = nil
  end;

  update = function(self, dt)
    Component.update(self, dt)

    if self.world then
        self.world:update(dt)
    end

    function createRopeJoint(body1, body2, x1, y1, x2, y2, maxLength)
        local x1w, y1w = body1:getWorldPoints(x1, y1)
        local x2w, y2w = body2:getWorldPoints(x2, y2)
        local ropeJoint = love.physics.newRopeJoint(body1, body2, x1w, y1w, x2w, y2w, maxLength)
        local frictionJoint = love.physics.newFrictionJoint(body1, body2, x1w, y1w, x2w, y2w)

        frictionJoint:setMaxForce(100)
        frictionJoint:setMaxTorque(100)

        return ropeJoint, frictionJoint
    end

    if not self.studsCreated and self.boardBody and self.boardBody:getY() > VIRTUAL_HEIGHT / 3 then
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

    if self.forceY then
        self.boardBody:setY(self.forceY)
    end
  end;

  drawComponent = function(self)
    Component.drawComponent(self)

    love.graphics.setColor(1, 1, 1, 1)

    if self.studsCreated then
        self.ropeLeft:draw()
        self.ropeRight:draw()
    end

    if self.boardBody then
        love.graphics.draw(self.boardImg, self.boardBody:getX(), self.boardBody:getY(), self.boardBody:getAngle(),  1, 1, self.boardWidth / 2, self.boardHeight / 2)
    end
  end;

  getCenterX = function(self)
    return self.boardBody:getX()
  end;

  getCenterY = function(self)
    return self.boardBody:getY()
  end;

  getRotation = function(self)
    return self.boardBody:getAngle()
  end;

  getWidth = function(self)
    return self.boardWidth
  end;

  getHeight = function(self)
    return self.boardHeight
  end;
}
