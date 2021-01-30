require 'src/deps'

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

function love.load()

  love.window.setTitle('Pong')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = true,
      resizable = true,
      vsync = true
  })

  math.randomseed(os.time())

  love.pressedKeys = {}

  local states = {
    initial = InitialState(),
    intro = IntroState()
  }
  stateMachine = StateMachine(states)
  stateMachine:change('initial')

  font = love.graphics.newFont('assets/fonts/font.ttf', 14)
  largeFont = love.graphics.newFont('assets/fonts/font.ttf', 30)

  grid = Grid(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 1)
  cardGrid = Grid(0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 70, 11)

  -- title = Label('Team 1', Color.BLACK, Color(40/255, 45/255, 52/255, 255/255))
  title = Label('Team 1', Color.BLACK, Color.RED)
  title.width = VIRTUAL_WIDTH
  title.height = 70

  grid:addComponent(title)
  grid:addComponent(cardGrid)

  for i=1,8 do
    local label = Label('Category ' .. tostring(i), Color.BLACK, Color.BLUE)
    label.width = 200
    label.height = 50
    cardGrid:addComponent(label)
    for j=1,10 do

      local card = Card(j)
      card.width = 70
      card.height = 50
      cardGrid:addComponent(card)

    end
  end

  grid:reposition()
  cardGrid:reposition()

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
  --grid:update(dt)
  stateMachine:update(dt)
  love.pressedKeys = {}
end

function love.draw()

  push:start()

  --love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  stateMachine:draw()

  --grid:draw()

  displayFPS()

  push:finish()

end

function displayFPS()
  love.graphics.setFont(font)
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.keypressed(key)

  if key == 'escape' then
    love.event.quit()
  end

  love.pressedKeys[key] = true

end

function love.wasKeyPressed(key)
  return love.pressedKeys[key]
end

function love.wasAnyKeyPressed()
  local numPressedKeys = table.length(love.pressedKeys)
  return numPressedKeys > 1  or numPressedKeys == 1 and not love.wasKeyPressed('escape')
end

function love.mouse.getVirtualPosition()
  local x, y = love.mouse.getPosition()
  local xRatio = VIRTUAL_WIDTH / WINDOW_WIDTH
  local yRatio = VIRTUAL_HEIGHT / WINDOW_HEIGHT

  return x * xRatio, y * yRatio
end

function table.length(t)
  local length = 0
  for _ in pairs(t) do
    length = length + 1
  end
  return length
end