Category = Class {
    init = function(self, title, maxPoints, songs)
        self.title = title
        self.maxPoints = maxPoints
        self.songs = songs
    end;

    getTitle = function(self)
        return self.title
    end;

    getMaxPoints = function(self)
        return self.maxPoints
    end;

    getSongs = function(self)
        return self.songs
    end;
}