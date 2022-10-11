GoldBar = Class {
    init = function(self, id)
        self.id = id
        self.type = "gold bar"
        self.maxPoints = 2
    end;

    getId = function(self)
        return self.id
    end;
}