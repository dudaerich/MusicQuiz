Team = Class {
    init = function(self, name)
        self.name = name
        self.scores = {}
    end;

    addScoreRecord = function(self, scoreRecord)
        table.insert(self.scores, scoreRecord)
    end;

    getScoreRecords = function(self)
        return self.scores
    end;

    getScore = function(self)
        local sum = 0
        
        for i, score in ipairs(self.scores) do
            sum = sum + score.score
        end
        
        return sum
    end;

    getName = function(self)
        return self.name
    end;
}