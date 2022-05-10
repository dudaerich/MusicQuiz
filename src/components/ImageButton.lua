ImageButton = Class { __includes = Image,

    init = function(self, img)
        Image.init(self, img)
        self.interactive = true
    end;

    onMouseOverEnter = function(self)
        Image.onMouseOverEnter(self)
        self.scaleX = 1.2
        self.scaleY = 1.2
        self.z = 100
      end;
    
    onMouseOverExit = function(self)
        Image.onMouseOverExit(self)
        self.scaleX = 1
        self.scaleY = 1
        self.z = 0
    end;

    reset = function(self)
        self:onMouseOverExit()
        self.mouseOver = false
    end;
}