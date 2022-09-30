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
            local category = Category(title, category.maxPoints, self:loadSongs(workingDirectory, category.songs, category.maxPoints))
            table.insert(outcome, category)
        end

        return outcome
    end;

    loadSongs = function(self, workingDirectory, songsData, maxPoints)
        local outcome = {}
        for i, song in ipairs(songsData) do
            if (song.type == "gold bar") then
                local id = "gold-bar-" .. i
                local goldBar = GoldBar(id, maxPoints)
                table.insert(outcome, goldBar)
                self.songs[id] = goldBar
            else
                local source = workingDirectory .. '/' .. song.src
                local songId = song.src
                local song = Song(songId, song.answer, source, song.start, song.duration, maxPoints)
                table.insert(outcome, song)
                self.songs[songId] = song
            end
        end
        return outcome
    end;

    getSong = function(self, songId)
        return self.songs[songId]
    end;
}