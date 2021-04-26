Button = Class { __includes = Label,

    init = function(self, text, fg, bg, font)
        Label.init(self, text, fg, bg, font)
        self.interactive = true
    end;

    onMouseOverEnter = function(self)
        Label.onMouseOverEnter(self)
        self.scaleX = 1.5
        self.scaleY = 1.5
        self.z = 100
      end;
    
    onMouseOverExit = function(self)
        Label.onMouseOverExit(self)
        self.scaleX = 1
        self.scaleY = 1
        self.z = 0
    end;

    reset = function(self)
        self:onMouseOverExit()
        self.mouseOver = false
    end;
}