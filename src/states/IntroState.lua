IntroState = Class { __includes = State,

    init = function(self)
        self.background = love.graphics.newImage('assets/images/background.png')
        self.chimney = love.graphics.newImage('assets/images/chimney.png')
        self.smokeImg = love.graphics.newImage('assets/images/smoke.png')
        self.snowflameImg = love.graphics.newImage('assets/images/snowflame.png')

        local borderCollieImg = love.graphics.newImage('assets/images/ciri-animation.png')
        self.borderCollie = Animation(borderCollieImg, 6, 0.1)
        self.borderCollie.x = 740
        self.borderCollie.y = 480

        self.smokeParticles = love.graphics.newParticleSystem(self.smokeImg)
        self.smokeParticles:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
        self.smokeParticles:setEmissionRate(50)
        self.smokeParticles:setSizeVariation(1)
        self.smokeParticles:setEmissionArea('uniform', 15, 15)
        self.smokeParticles:setLinearAcceleration(-4, -10, 4, -20) -- Random movement in all directions.
        self.smokeParticles:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
        
        self.snowflameParticles = love.graphics.newParticleSystem(self.snowflameImg)
        self.snowflameParticles:setParticleLifetime(15, 45) -- Particles live at least 2s and at most 5s.
        self.snowflameParticles:setEmissionRate(30)
        self.snowflameParticles:setSizes(0.2, 1.3)
        self.snowflameParticles:setSizeVariation(1)
        self.snowflameParticles:setRotation(0, math.pi / 2)
        self.snowflameParticles:setEmissionArea('uniform', VIRTUAL_WIDTH, 0)
        self.snowflameParticles:setLinearAcceleration(0, 5, 0, 13) -- Random movement in all directions.

        self.discoFont = love.graphics.newFont('assets/fonts/disco.ttf', 70)
        self.woodFont = love.graphics.newFont('assets/fonts/wood.ttf', 50)

        self.headingHu = Label('HU', Color.BLUE, Color.TRANSPARENT, self.discoFont)
        self.headingHu.scale = 0
        self.headingHu.x = 340
        self.headingHu.y = 50
        self.headingHu.width = 200
        self.headingHu.height = 200

        self.headingDob = Label('DOB', Color.BLUE, Color.TRANSPARENT, self.discoFont)
        self.headingDob.scale = 0
        self.headingDob.x = 440
        self.headingDob.y = 50
        self.headingDob.width = 200
        self.headingDob.height = 200

        self.headingNy = Label('NY', Color.BLUE, Color.TRANSPARENT, self.discoFont)
        self.headingNy.scale = 0
        self.headingNy.x = 540
        self.headingNy.y = 50
        self.headingNy.width = 200
        self.headingNy.height = 200

        self.headingKviz = Label('KVIZ', Color.BLUE, Color.TRANSPARENT, self.discoFont)
        self.headingKviz.scale = 0
        self.headingKviz.x = 680
        self.headingKviz.y = 50
        self.headingKviz.width = 200
        self.headingKviz.height = 200

        self.headingDrabsku = Label('V DRABSKU', Color(0, 0, 1, 1), Color.TRANSPARENT, self.discoFont)
        self.headingDrabsku.x = 0
        self.headingDrabsku.y = 130
        self.headingDrabsku.width = VIRTUAL_WIDTH
        self.headingDrabsku.height = 200
        self.headingDrabsku.fg.a = 0
    end;

    enter = function(self)
        self.bgAlpha = 0
        self.timers = {}

        Chain(
            function(go)
                Timer.tween(1, {
                    [self.headingHu] = { scale = 1 }
                })
                :group(self.timers)
                :ease(Easing.outExpo)

                Timer.after(1, go):group(self.timers)
            end,
            function(go)
                Timer.tween(1, {
                    [self.headingDob] = { scale = 1 }
                })
                :group(self.timers)
                :ease(Easing.outExpo)

                Timer.after(1, go):group(self.timers)
            end,
            function(go)
                Timer.tween(1, {
                    [self.headingNy] = { scale = 1 }
                })
                :group(self.timers)
                :ease(Easing.outExpo)

                Timer.after(1, go):group(self.timers)
            end,
            function(go)
                Timer.tween(1, {
                    [self.headingKviz] = { scale = 1 }
                })
                :group(self.timers)
                :ease(Easing.outExpo)

                Timer.after(1, go):group(self.timers)
            end,
            function(go)
                Timer.tween(2, {
                    [self] = { bgAlpha = 1 },
                    [self.headingDrabsku.fg] = { a = 1 }
                })
                :group(self.timers)
            end
        )()
        --:ease(Easing.inExpo)
    end;

    exit = function(self)
        Timer.clear(self.timers)
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
        self.smokeParticles:update(dt)
        self.snowflameParticles:update(dt)
        self.borderCollie:update(dt)
    end;

    draw = function(self)
        love.graphics.setColor(1, 1, 1, self.bgAlpha)
        love.graphics.draw(self.background, 0, 0)
        love.graphics.draw(self.smokeParticles, 190, 220)
        love.graphics.draw(self.chimney, 135, 214)
        self.borderCollie:draw()
        love.graphics.draw(self.snowflameParticles, VIRTUAL_WIDTH / 2, -15)

        love.graphics.setColor(1, 1, 1, 1)
        self.headingHu:draw()
        self.headingDob:draw()
        self.headingNy:draw()
        self.headingKviz:draw()
        self.headingDrabsku:draw()
    end;
}