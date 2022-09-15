GameStatus = Class {

    load = function(name)
        local workingDirectory = 'games/' .. name
        local path =  workingDirectory .. '/save.json'
        local content, errMsg = love.filesystem.read(path)
        local jsonData = json.decode(content)

        local teamManager = TeamManager()
        local playedSongs = {}

        for i, teamName in ipairs(jsonData.teams) do
            local team = Team(teamName)
            local allScores = jsonData.scores or {}
            local teamScores = allScores[teamName] or {}

            for i, scoreData in ipairs(teamScores) do
                local score = scoreData.score
                local song = game:getSong(scoreData.song)
                team:addScoreRecord(ScoreRecord(score, song))
                playedSongs[scoreData.song] = true
            end

            teamManager:addTeam(team)
        end

        teamManager.currentTeam = jsonData.currentTeam or 0

        local playedSongsBeforeBreak = {}

        for i, song in ipairs(jsonData.playedSongsBeforeBreak or {}) do
            table.insert(playedSongsBeforeBreak, game:getSong(song))
        end

        return GameStatus(path, teamManager, playedSongs, playedSongsBeforeBreak)
    end;

    init = function(self, path, teamManager, playedSongs, playedSongsBeforeBreak)
        self.path = path
        self.teamManager = teamManager
        self.playedSongs = playedSongs
        self.playedSongsBeforeBreak = playedSongsBeforeBreak
    end;

    persist = function(self)
        local jsonData = {}
        jsonData.teams = self.teamManager:getTeamNames()
        jsonData.currentTeam = self.teamManager.currentTeam

        local scores = {}
        for i, team in ipairs(self.teamManager:getTeams()) do
            local scoresData = {}
            for j, score in ipairs(team:getScoreRecords()) do
                local scoreData = {}
                scoreData.song = score:getSong():getId()
                scoreData.score = score:getScore()
                table.insert(scoresData, scoreData)
            end
            scores[team:getName()] = scoresData
        end

        jsonData.scores = scores

        local playedSongsBeforeBreak = {}
        for i, song in ipairs(self.playedSongsBeforeBreak) do
            table.insert(playedSongsBeforeBreak, song:getId())
        end

        jsonData.playedSongsBeforeBreak = playedSongsBeforeBreak

        local content = json.encode(jsonData)
        love.filesystem.write(self.path, content)
    end;

    addScoreRecordToCurrentTeam = function(self, scoreRecord)
        self.teamManager:getCurrentTeam():addScoreRecord(scoreRecord)
        table.insert(self.playedSongsBeforeBreak, scoreRecord:getSong())
        self.playedSongs[scoreRecord:getSong():getId()] = true
        self:persist()
    end;

    nextTeam = function(self)
        self.teamManager:nextTeam()
        self:persist()
    end;

    getCurrentTeam = function(self)
        return self.teamManager:getCurrentTeam()
    end;

    getAllTeamsOrderedByScore = function(self)
        return self.teamManager:getAllTeamsOrderedByScore()
    end;

    registerTeamChangeListener = function(self, listener)
        self.teamManager:registerTeamChangeListener(listener)
    end;

    wasSongPlayed = function(self, song)
        return self.playedSongs[song.id] == true
    end;

    getPlayedSongsBeforeBreak = function(self)
        return self.playedSongsBeforeBreak
    end;
}