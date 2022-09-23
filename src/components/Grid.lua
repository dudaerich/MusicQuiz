Grid = Class { __includes = Container,

  init = function(self, width, height, rowLength, xGap, yGap)
    Container.init(self)
    self.width = width
    self.height = height
    self.rowLength = rowLength
    self.xGap = xGap or 'auto'
    self.yGap = yGap or 'auto'
    self.maxItems = -1
    self.currentPage = 0
  end;

  computeComponentsStats = function(self)
    local componentsWidth = 0
    local componentsHeight = 0
    local numRows = 0
    local rowWidth = 0
    local rowHeight = 0

    local components = self:getComponentsOnCurrentPage()

    for i, component in ipairs(components) do

      rowWidth = rowWidth + component.width
      rowHeight = math.max(rowHeight, component.height)

      if (i % self.rowLength == 0) then
        componentsWidth = math.max(componentsWidth, rowWidth)
        componentsHeight = componentsHeight + rowHeight
        rowWidth = 0
        rowHeight = 0
        numRows = numRows + 1
      end
    end

    if (#components % self.rowLength ~= 0) then
      numRows = numRows + 1
    end

    componentsWidth = math.max(componentsWidth, rowWidth)
    componentsHeight = componentsHeight + rowHeight

    return componentsWidth, componentsHeight, numRows
  end;

  getComponentsOnCurrentPage = function(self)
    if (self.maxItems <= 0) then
      return self.components
    else
      local startPos = self.currentPage * self.maxItems + 1
      local endPos = startPos + self.maxItems - 1
      return table.unpack(self.components, startPos, math.min(endPos, #self.components))
    end
  end;

  hasNextPage = function(self)
    return self.maxItems > 0 and self.maxItems * (self.currentPage + 1) < #self.components
  end;

  hasPreviousPage = function(self)
    return self.currentPage > 0
  end;

  nextPage = function(self)
    self.currentPage = self.currentPage + 1
    self:reposition()
  end;

  previousPage = function(self)
    self.currentPage = self.currentPage - 1
    self:reposition()
  end;

  reposition = function(self)
    local componentsWidth, componentsHeight, numRows = self:computeComponentsStats()

    local xGap = self:computeXGap(self.width - componentsWidth, self.rowLength)
    local yGap = self:computeYGap(self.height - componentsHeight, numRows)

    local curX = xGap
    local curY = yGap
    local rowHeight = 0

    for i, component in ipairs(self.components) do
      component:setLeft(-500)
      component:setTop(-500)
    end

    for i, component in ipairs(self:getComponentsOnCurrentPage()) do

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
