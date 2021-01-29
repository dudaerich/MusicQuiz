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

  font = love.graphics.newFont('assets/font.ttf', 14)
  largeFont = love.graphics.newFont('assets/font.ttf', 30)
  background = love.graphics.newImage('assets/background.png')
  chimney = love.graphics.newImage('assets/chimney.png')
  smokeImg = love.graphics.newImage('assets/smoke.png')
  snowflameImg = love.graphics.newImage('assets/snowflame.png')

  smokeParticles = love.graphics.newParticleSystem(smokeImg)
  smokeParticles:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	smokeParticles:setEmissionRate(50)
  smokeParticles:setSizeVariation(1)
  smokeParticles:setEmissionArea('uniform', 15, 15)
	smokeParticles:setLinearAcceleration(-4, -10, 4, -20) -- Random movement in all directions.
  smokeParticles:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
  
  snowflameParticles = love.graphics.newParticleSystem(snowflameImg)
  snowflameParticles:setParticleLifetime(15, 45) -- Particles live at least 2s and at most 5s.
	snowflameParticles:setEmissionRate(30)
  snowflameParticles:setSizes(0.2, 1.3)
  snowflameParticles:setSizeVariation(1)
  snowflameParticles:setRotation(0, math.pi / 2)
  snowflameParticles:setEmissionArea('uniform', VIRTUAL_WIDTH, 0)
	snowflameParticles:setLinearAcceleration(0, 5, 0, 13) -- Random movement in all directions.

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
  smokeParticles:update(dt)
  snowflameParticles:update(dt)
  grid:update(dt)
end

function love.draw()

  push:start()

  --love.graphics.clear(40/255, 45/255, 52/255, 255/255)
  love.graphics.draw(background, 0, 0)
  love.graphics.draw(smokeParticles, 190, 220)
  love.graphics.draw(chimney, 135, 214)
  love.graphics.draw(snowflameParticles, VIRTUAL_WIDTH / 2, -15)

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

end

function love.mouse.getVirtualPosition()
  local x, y = love.mouse.getPosition()
  local xRatio = VIRTUAL_WIDTH / WINDOW_WIDTH
  local yRatio = VIRTUAL_HEIGHT / WINDOW_HEIGHT

  return x * xRatio, y * yRatio
end
