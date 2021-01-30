InitialState = Class { __includes = State,

    update = function(self, dt)
        if love.wasAnyKeyPressed() then
            stateMachine:push('intro')
        end
    end;
    
    draw = function(self)

        love.graphics.clear(0.8, 0.8, 0.8, 1)

    end;

}