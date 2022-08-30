CardState = Class { __includes = State,

    init = function(self)
        self.card = Image(images.cardReverseLarge)
        self.card.x = (VIRTUAL_WIDTH - self.card.width) / 2
        self.card.y = (VIRTUAL_HEIGHT - self.card.height) / 2 - 20

        self.mainGrid = Grid(self.card.width, self.card.height, 1)
        self.mainGrid.x = self.card.x
        self.mainGrid.y = self.card.y

        self.answer = Answer()
        self.answerRow = Grid(self.card.width, self.answer.height, 1)
        self.answerRow:addComponent(self.answer)

        self.stopWatch = StopWatch(5)
        self.stopWatch.anchorX = self.stopWatch.width / 2
        self.stopWatch.anchorY = self.stopWatch.height / 2
        self.stopWatch.visible = false

        self.stopWatchRow = Grid(self.card.width, self.stopWatch.height, 1)
        self.stopWatchRow:addComponent(self.stopWatch)

        self.answers = Grid(self.card.width, 100, 1)

        self.passBtn = ImageButton(images.thumbsUp)
        self.passBtn.anchorX = self.passBtn.width / 2
        self.passBtn.anchorY = self.passBtn.height / 2

        self.failBtn = ImageButton(images.thumbsDown)
        self.failBtn.anchorX = self.failBtn.width / 2
        self.failBtn.anchorY = self.failBtn.height / 2

        self.mainGrid:addComponent(self.answerRow)
        self.mainGrid:addComponent(self.stopWatchRow)
        self.mainGrid:addComponent(self.answers)

        self.mainGrid:reposition()
        self.answerRow:reposition()
        self.answers:reposition()
        self.stopWatchRow:reposition()

        self.timers = {}
    end;

    enter = function(self, params)
        State.enter(self, params)

        self.passBtn.onLeftClick = function(self)
            teamManager:getCurrentTeam():addScoreRecord(ScoreRecord(1))
            stateMachine:pop()
        end

        self.failBtn.onLeftClick = function(self)
            teamManager:getCurrentTeam():addScoreRecord(ScoreRecord(0))
            stateMachine:pop()
        end

        self.passBtn:reset()
        self.failBtn:reset()

        self.song = params.song
        self.answer:setText(self.song:getAnswer())

        local chain = Chain(
            function(go)
                self.song:getStream():seek(self.song:getStart(), "seconds")
                self.song:getStream():play()
                
                Timer.after(2, go):group(self.timer)
            end,
            function(go)
                self.answers.rowLength = 1
                self.answers:addComponent(self.passBtn)
                self.answers:reposition()

                self.passBtn.interactive = false
                self.passBtn.scaleX = 0.1
                self.passBtn.scaleY = 0.1

                Chain(
                    function(innerGo)
                        Timer.tween(0.5, {
                            [self.passBtn] = {
                                scaleX = 1.5,
                                scaleY = 1.5
                            }
                        })
                        :ease(Easing.outExpo)
                        :group(self.timers)
                        :finish(innerGo)
                    end,
                    function(innerGo)
                        Timer.tween(0.2, {
                            [self.passBtn] = {
                                scaleX = 1,
                                scaleY = 1
                            }
                        })
                        :ease(Easing.inExpo)
                        :group(self.timers)
                        :finish(innerGo)
                    end,
                    function(innerGo)
                        self.passBtn.interactive = true
                    end
                )()

                Timer.after(self.song:getDuration() - 2, go):group(self.timers)
            end,
            function(go)
                self:stopSong()
                Timer.after(1.5, go):group(self.timers)
            end,
            function(go)
                self.stopWatch.visible = true

                Timer.tween(0.5, {
                    [self.stopWatch] = {
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
                    [self.stopWatch] = {
                        scaleX = 1,
                        scaleY = 1
                    }
                })
                :ease(Easing.inExpo)
                :group(self.timers)
                :finish(go)
            end,
            function(go)
                self.stopWatch.onEnd = go
                self.stopWatch:start()
            end,
            function(go)
                local startX = self.passBtn.x
                local startY = self.passBtn.y

                self.answers.rowLength = 2
                self.answers:addComponent(self.failBtn)

                self.mainGrid:reposition()
                self.answers:reposition()

                local passBtnTargetX = self.passBtn.x
                local passBtnTargetY = self.passBtn.y
                local failBtnTargetX = self.failBtn.x
                local failBtnTargetY = self.failBtn.y

                self.passBtn.x = startX
                self.passBtn.y = startY
                self.failBtn.x = startX
                self.failBtn.y = startY

                self.passBtn.interactive = false
                self.failBtn.interactive = false

                Timer.tween(0.5, {
                    [self.passBtn] = {
                        x = passBtnTargetX,
                        y = passBtnTargetY
                    },
                    [self.failBtn] = {
                        x = failBtnTargetX,
                        y = failBtnTargetY
                    }
                })
                :ease(Easing.outExpo)
                :group(self.timers)
                :finish(go)
            end,
            function(go)
                self.passBtn.interactive = true
                self.failBtn.interactive = true
                self.answer:uncover()
            end
        )

        stateMachine:push('countDownState', {onFinish = chain})
    end;

    stopSong = function(self)
        if self.song then
            self.song:getStream():stop()
            self.song = nil
        end
    end;

    exit = function(self)
        self:stopSong()
        self.answer:reset()
        self.stopWatch:reset()
        self.stopWatch.visible = false
        self.stopWatch.scaleX = 1
        self.stopWatch.scaleY = 1
        Timer.clear(self.timers)
        self.timers = {}
        self.answers:clear()
        teamManager:nextTeam()
    end;

    inputCheck = function(self, key)
        State.inputCheck(self, key)
        self.mainGrid:interact()
    end;

    update = function(self, dt)
        Timer.update(dt, self.timers)
        self.mainGrid:update(dt)
    end;

    draw = function(self)
        State.draw(self)

        self.card:draw()
        self.mainGrid:draw()
    end

}