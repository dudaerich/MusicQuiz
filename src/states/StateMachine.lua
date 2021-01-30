StateMachine = Class {
    init = function(self, states)
        self.states = states or {}
        self.stack = {}
    end;

    push = function(self, state, params)
        local stateObj = self.states[state]
        stateObj:enter(params)
        table.insert(self.stack, stateObj)
    end;

    pop = function(self)
        local stateObj = self.stack[#self.stack]
        stateObj:exit()
        table.remove(self.stack, #self.stack)
    end;

    change = function(self, state, params)
        for i = 1, #self.stack do
            self:pop()
        end

        self:push(state, params)
    end;

    update = function(self, dt)
        local state = self.stack[#self.stack]
        state:update(dt)
    end;

    draw = function(self)
        for i, state in ipairs(self.stack) do
            state:draw()
        end
    end;
}