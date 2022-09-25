ImageLabel = Class { __includes = Component,

    init = function(self, text, fg, bg, font, margin)
        Component.init(self)
        self.font = font
        self.bg = bg
        self.fg = fg
        self.text = text
        self.margin = margin
        self.width, self.height = self.bg:getDimensions()
        self.width = self.width - 2 * margin
        self.height = self.height - 2 * margin
        self.fontHeight = self.font:getHeight()
        self.lines = self:splitTextToLines(self.text)
    end;

    splitTextToLines = function(self, text)
        local lines = {}
        local words = self:splitTextToWords(text)
        local lineStart = 1
        local lineEnd = 1
        local lastFitLineStart = 1
        local lastFitLineEnd = 1
        local lastFitLine = nil

        while (lineStart <= #words) do
            local line = self:concateWords(words, lineStart, lineEnd)

            if (lastFitLine == nil) then
                lastFitLine = line
            end

            if (self.font:getWidth(line) < self.width and lineEnd < #words) then
                lastFitLineStart = lineStart
                lastFitLineEnd = lineEnd
                lastFitLine = line
                lineEnd = lineEnd + 1
            else
                if (self.font:getWidth(line) < self.width and lineEnd == #words) then
                    lastFitLine = line
                    lineStart = lineEnd + 1
                else
                    lineStart = lastFitLineEnd + 1
                end

                lineEnd = lineStart
                if (self.font:getWidth(lastFitLine) > self.width) then
                    table.insert(lines, love.cropText(self.font, lastFitLine, self.width))
                else
                    table.insert(lines, lastFitLine)
                end
                lastFitLine = nil
            end
        end

        return self:cropLines(lines)
    end;

    splitTextToWords = function(self, text)
        local words = {}

        for w in text:gmatch("%S+") do
            table.insert(words, w)
        end

        return words
    end;

    concateWords = function(self, words, startPos, endPos)
        local outcome = ""
        for i = startPos, endPos, 1 do
            outcome = outcome .. " " .. words[i]
        end

        return outcome
    end;

    cropLines = function(self, lines)
        local maxNumberOfLines = math.floor(self.height / self.fontHeight)
        local outcome = {}

        for i = 1, maxNumberOfLines, 1 do
            if (i == maxNumberOfLines and #lines > maxNumberOfLines) then
                table.insert(outcome, self:cropLine(lines[i]))
            else
                table.insert(outcome, lines[i])
            end
        end

        return outcome
    end;

    cropLine = function(self, line)
        if (self.font:getWidth(line .. "..") < self.width) then
            return line .. ".."
        else
            return line:sub(1, -3) .. ".."
        end
    end;

    drawComponent = function(self)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.bg, 0, 0)
        love.graphics.setColor(self.fg.r, self.fg.g, self.fg.b, self.fg.a)
        love.graphics.setFont(self.font)

        local yGap = (self.height - self.fontHeight * #self.lines) / 2
        for i, line in ipairs(self.lines) do
            local xGap = (self.width - self.font:getWidth(line)) / 2
            love.graphics.print(line, self.margin + xGap, self:getYGap(i, yGap))
        end
    end;

    getYGap = function(self, line, gap)
        if (line == 1) then
            return self.margin + gap
        else
            return gap + (line - 1) * self.fontHeight
        end
    end;
}