--
-- Poppy (Working title)
--   Sightseeing is not a crime!
--
-- (C) 2013 Anna Lazareva, Thomas R. Koll

require 'lib/middleclass'
require 'game'
require 'views/view'
require 'game_states/state'
require 'game_states/start_menu'
require 'game_states/map_state'
require 'game_states/finish_screen'

function love.load()
  local modes = love.graphics.getModes()
  table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end)
  game:setMode(modes[1])

  game:startMenu()
  --love.audio.play(game.sounds.music[1])
  --love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), game.graphics.fullscreen)
  --game:start()
end

function love.draw()
  if not game.current_state then return end
  game.current_state:draw()

  if not madeScreenshot and game.debug then
    madeScreenshot = true
    makeScreenshot()
  end
end

function love.keypressed(key)
  if key == 'f2' then
    makeScreenshot()
  end
  if not game.current_state then return end
  game.current_state:keypressed(key)
end

function love.update(dt)
  if not game.current_state then return end
  game.current_state:update(dt)
end

function love.quit()
  if game.debug then
    makeScreenshot()
  end
end

function makeScreenshot()
  love.graphics.newScreenshot():encode(os.time() .. '.png', 'png')
end

