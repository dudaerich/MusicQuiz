ScoreRecord = Class {
    init = function(self, score, song)
        self.score = score
        self.song = song
    end;

    getScore = function(self)
        return self.score
    end;

    getSong = function(self)
        return self.song
    end
}