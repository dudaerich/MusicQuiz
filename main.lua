require 'src/deps'

WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

function love.load()

  print("Program name", arg[0])
  print("Number of arguments: ", #arg)
  print("Arguments:")
  for l = 1, #arg do
    print(l," ",arg[l])
  end

  love.window.setTitle('Music Quiz')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = true,
      resizable = true,
      vsync = true
  })

  math.randomseed(os.time())

  fonts = {
    small = love.graphics.newFont('assets/fonts/komika.ttf', 14),
    medium = love.graphics.newFont('assets/fonts/komika.ttf', 30),
    large = love.graphics.newFont('assets/fonts/komika.ttf', 50),
  }

  images = {
    pin = love.graphics.newImage('assets/images/pin.png'),
    card = love.graphics.newImage('assets/images/card.png'),
    cardFocus = love.graphics.newImage('assets/images/card-focus.png'),
    cardReverseLarge = love.graphics.newImage('assets/images/card-reverse-large.png'),
    thumbsUp = love.graphics.newImage('assets/images/thumbs-up.png'),
    thumbsDown = love.graphics.newImage('assets/images/thumbs-down.png'),
    scoreButton = love.graphics.newImage('assets/images/score-button.png'),
    stopWatch = {
      bg = love.graphics.newImage('assets/images/stopwatch-bg.png'),
      fg = love.graphics.newImage('assets/images/stopwatch-fg.png'),
      needle = love.graphics.newImage('assets/images/stopwatch-needle.png')
    },
    answerCover = {
      bg = love.graphics.newImage('assets/images/answer-cover.png'),
      fg = love.graphics.newImage('assets/images/answer-uncover.png')
    },
    closeButton = love.graphics.newImage('assets/images/close-button.png'),
    board = love.graphics.newImage('assets/images/board.png')
  }

  teamManager = TeamManager()
  teamManager:addTeam(Team('Team One'))
  teamManager:addTeam(Team('Team Two'))
  teamManager:addTeam(Team('Team Three'))

  game = GameLoader.load('2022')

  love.pressedKeys = {}
  love.leftClicks = {}

  testSong = love.audio.newSource('games/test.mp3', 'stream')

  local states = {
    initial = InitialState(),
    intro = IntroState(),
    play = PlayState(),
    cardState = CardState(),
    countDownState = CountDownState(),
    scoreState = ScoreState()
  }
  stateMachine = StateMachine(states)
  stateMachine:change('initial')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
  Timer.update(dt)
  stateMachine:update(dt)
  love.pressedKeys = {}
  love.leftClicks = {}
end

function love.draw()

  push:start()

  stateMachine:draw()

  displayFPS()

  push:finish()

end

function displayFPS()
  love.graphics.setFont(fonts.small)
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
  return computeVirtualPosition(x, y)
end

function computeVirtualPosition(x, y)
  local xRatio = VIRTUAL_WIDTH / WINDOW_WIDTH
  local yRatio = VIRTUAL_HEIGHT / WINDOW_HEIGHT

  return x * xRatio, y * yRatio
end

function love.mousereleased(x, y, button, istouch, presses)
  if button == 1 then
    local vx, vy = computeVirtualPosition(x, y)
    print('Click ' .. vx .. '; ' .. vy)
    table.insert(love.leftClicks, {x=vx, y=vy})
  end
end

function love.mouse.getLeftClicks()
  return love.leftClicks
end

function table.length(t)
  local length = 0
  for _ in pairs(t) do
    length = length + 1
  end
  return length
end

function table.clone(orig)
  local copy = {}
  for orig_key, orig_value in pairs(orig) do
    copy[orig_key] = orig_value
  end
  return copy
end