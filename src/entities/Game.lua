Game = Class {
    init = function(self, workingDirectory, data)
        self.categories = self:loadCategories(workingDirectory, data)
    end;

    getCategories = function(self)
        return self.categories
    end;

    loadCategories = function(self, workingDirectory, data)
        local outcome = {}
        for title, category in pairs(data.categories) do
            print('Loading category ' .. title)
            local category = Category(title, category.maxPoints, self:loadSongs(workingDirectory, category.songs))
            table.insert(outcome, category)
        end

        return outcome
    end;

    loadSongs = function(self, workingDirectory, songs)
        local outcome = {}
        for i, song in pairs(songs) do
            local source = workingDirectory .. '/' .. song.src
            local song = Song(song.answer, source, song.start, song.duration)
            table.insert(outcome, song)
        end
        return outcome
    end;
}