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