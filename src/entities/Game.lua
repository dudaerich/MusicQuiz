Game = Class {

    load = function(name)
        local workingDirectory = 'games/' .. name
        local path =  workingDirectory .. '/game.json'
        local content, errMsg = love.filesystem.read(path)
        local jsonData = json.decode(content)

        return Game(workingDirectory, jsonData)
    end;

    init = function(self, workingDirectory, data)
        self.songs = {}
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

    loadSongs = function(self, workingDirectory, songsData)
        local outcome = {}
        for i, song in pairs(songsData) do
            local source = workingDirectory .. '/' .. song.src
            local songId = song.src
            local song = Song(songId, song.answer, source, song.start, song.duration)
            table.insert(outcome, song)
            self.songs[songId] = song
        end
        return outcome
    end;

    getSong = function(self, songId)
        return self.songs[songId]
    end;
}