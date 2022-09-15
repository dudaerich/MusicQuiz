Song = Class {
    init = function(self, id, answer, source, start, duration)
        self.id = id
        self.answer = answer
        self.stream = love.audio.newSource(source, 'stream')
        self.start = self:parseStart(start)
        self.duration = duration
    end;

    parseStart = function(self, start)
        local colonStart, colonEnd = start:find(":")
        local minutes = start:sub(0, colonStart - 1)
        local seconds = start:sub(colonEnd + 1)
        return tonumber(minutes) * 60 + tonumber(seconds)
    end;

    getId = function(self)
        return self.id
    end;

    getAnswer = function(self)
        return self.answer
    end;

    getStream = function(self)
        return self.stream
    end;

    getStart = function(self)
        return self.start
    end;

    getDuration = function(self)
        return self.duration
    end;
}