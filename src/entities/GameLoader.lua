GameLoader = Class {
    load = function(name)
        local workingDirectory = 'games/' .. name
        local path =  workingDirectory .. '/game.json'
        local content, errMsg = love.filesystem.read(path)
        local jsonData = json.decode(content)

        return Game(workingDirectory, jsonData)
    end;
}