Grid = Class { __includes = Container,

  init = function(self, x, y, width, height, rowLength)
    Container.init(self)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.rowLength = rowLength
  end;

  computeComponentsStats = function(self)
    local componentsWidth = 0
    local componentsHeight = 0
    local numRows = 0
    local rowWidth = 0
    local rowHeight = 0

    for i, component in ipairs(self.components) do

      rowWidth = rowWidth + component.width
      rowHeight = math.max(rowHeight, component.height)

      if (i % self.rowLength == 0) then
        componentsWidth = math.max(componentsWidth, rowWidth)
        componentsHeight = componentsHeight + rowHeight
        rowWidth = 0
        rowHeight = 0
      end

      if (i % self.rowLength == 1) then
        numRows = numRows + 1
      end
    end

    componentsWidth = math.max(componentsWidth, rowWidth)
    componentsHeight = componentsHeight + rowHeight

    return componentsWidth, componentsHeight, numRows
  end;

  reposition = function(self)
    local componentsWidth, componentsHeight, numRows = self:computeComponentsStats()

    local xGap = self:computeGap(self.width - componentsWidth, self.rowLength)
    local yGap = self:computeGap(self.height - componentsHeight, numRows)

    local curX = self.x + xGap
    local curY = self.y + yGap
    local rowHeight = 0

    for i, component in ipairs(self.components) do

      component.x = curX
      component.y = curY

      curX = curX + component.width + xGap
      rowHeight = math.max(rowHeight, component.height)

      if (i % self.rowLength == 0) then
        curX = self.x + xGap
        curY = curY + rowHeight + yGap
        rowHeight = 0
      end

    end
  end;

  computeGap = function(self, gapSpace, numItems)
    return gapSpace / (numItems + 1)
  end;
}
