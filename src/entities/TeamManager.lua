TeamManager = Class {
    init = function(self)
        self.teams = {}
        self.currentTeam = 0
        self.teamChangeListeners = {}
    end;

    addTeam = function(self, team)
        table.insert(self.teams, team)
    end;

    getCurrentTeam = function(self)
        return self.teams[self.currentTeam + 1]
    end;

    getAllTeamsOrderedByScore = function(self)
        local teamsSorted = table.clone(self.teams)
        table.sort(teamsSorted, function (a, b) return a:getScore() > b:getScore() end)
        return teamsSorted
    end;

    getTeams = function(self)
        return self.teams
    end;

    getTeamNames = function(self)
        local outcome = {}

        for i, team in ipairs(self.teams) do
            table.insert(outcome, team:getName())
        end

        return outcome
    end;

    nextTeam = function(self)
        self.currentTeam = (self.currentTeam + 1) % #self.teams

        for i, listener in ipairs(self.teamChangeListeners) do
            listener()
        end
    end;

    registerTeamChangeListener = function(self, listener)
        table.insert(self.teamChangeListeners, listener)
    end;
}