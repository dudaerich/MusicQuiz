Grid = Class { __includes = Container,

  init = function(self, width, height, rowLength, xGap, yGap)
    Container.init(self)
    self.width = width
    self.height = height
    self.rowLength = rowLength
    self.xGap = xGap or 'auto'
    self.yGap = yGap or 'auto'
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

    local xGap = self:computeXGap(self.width - componentsWidth, self.rowLength)
    local yGap = self:computeYGap(self.height - componentsHeight, numRows)

    local curX = xGap
    local curY = yGap
    local rowHeight = 0

    for i, component in ipairs(self.components) do

      component:setLeft(curX)
      component:setTop(curY)

      curX = curX + component.width + xGap
      rowHeight = math.max(rowHeight, component.height)

      if (i % self.rowLength == 0) then
        curX = xGap
        curY = curY + rowHeight + yGap
        rowHeight = 0
      end

    end
  end;

  computeXGap = function(self, gapSpace, numItems)
    if self.xGap == 'auto' then
      return gapSpace / (numItems + 1)
    else
      return self.xGap
    end
  end;

  computeYGap = function(self, gapSpace, numItems)
    if self.yGap == 'auto' then
      return gapSpace / (numItems + 1)
    else
      return self.yGap
    end
  end;
}
