InitialState = Class { __includes = State,

    inputCheck = function(self)
        if love.wasAnyKeyPressed() then
            stateMachine:push('intro')
        end
    end;
    
    draw = function(self)

        love.graphics.clear(0.8, 0.8, 0.8, 1)

    end;

}