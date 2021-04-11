CardState = Class { __includes = State,

    enter = function(self, params)
        State.enter(self, params)
        local song = params.song
        local duration = song:getDuration("seconds")
        local startPosition = math.random(30, duration - 30)
        print(song)
        print(startPosition)
        song:seek(startPosition, "seconds")
        song:play()
        Timer.after(10, function() song:stop() end)
    end;

    update = function(self, dt)
        State.update(self, dt)
    end;

}