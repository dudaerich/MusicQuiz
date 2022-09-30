GoldBar = Class {
    init = function(self, id, maxPoints)
        self.id = id
        self.type = "gold bar"
        self.maxPoints = maxPoints
    end;

    getId = function(self)
        return self.id
    end;
}