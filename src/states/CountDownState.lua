CountDownState = Class { __includes = State,

    init = function(self)
        State.init(self)

        function createLabel(text)
            local label = Label(text, Color.BLACK, Color.TRANSPARENT, fonts.large)
            label.width = VIRTUAL_WIDTH
            label.height = 200
            label.x = VIRTUAL_WIDTH / 2
            label.anchorX = label.width / 2
            label.anchorY = label.height / 2
            return label
        end;

        self.three = createLabel('3')
        self.two = createLabel('2')
        self.one = createLabel('1')
        self.go = createLabel('GO')
    end;

    enter = function(self, params)
        State.enter(self, params)
        self.three.y = VIRTUAL_HEIGHT * 2
        self.two.y = VIRTUAL_HEIGHT * 2
        self.one.y = VIRTUAL_HEIGHT * 2
        self.go.y = VIRTUAL_HEIGHT * 2

        Chain(
            function(go)
                Timer.tween(0.5, {
                    [self.three] = {
                        y = (VIRTUAL_HEIGHT / 2) - 20
                    }
                })
                :ease(Easing.outExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.three] = {
                        y = -VIRTUAL_HEIGHT
                    }
                })
                :ease(Easing.inExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.two] = {
                        y = (VIRTUAL_HEIGHT / 2) - 20
                    }
                })
                :ease(Easing.outExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.two] = {
                        y = -VIRTUAL_HEIGHT
                    }
                })
                :ease(Easing.inExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.one] = {
                        y = (VIRTUAL_HEIGHT / 2) - 20
                    }
                })
                :ease(Easing.outExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.one] = {
                        y = -VIRTUAL_HEIGHT
                    }
                })
                :ease(Easing.inExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.go] = {
                        y = (VIRTUAL_HEIGHT / 2) - 20
                    }
                })
                :ease(Easing.outExpo)
                :finish(go)
            end,
            function(go)
                Timer.tween(0.5, {
                    [self.go] = {
                        y = -VIRTUAL_HEIGHT
                    }
                })
                :ease(Easing.inExpo)
                :finish(go)
            end,
            function(go)
                stateMachine:pop()
                params.onFinish()
            end
        )()
    end;

    draw = function(self)
        State.draw(self)
        self.three:draw()
        self.two:draw()
        self.one:draw()
        self.go:draw()
    end;
}