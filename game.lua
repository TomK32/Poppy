
game = {
  title = 'Poppy (working title)',
  graphics = {
    fullscreen = false,
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() }
  },
  fonts = {},
  renderer = require('renderers/default'),
  sounds = require('sounds'),
  realtime = true,
  animations = require('animations')
}

function game:createFonts(offset)
  self.fonts = {
    lineHeight = (10 + offset) * 1.7,
    small = love.graphics.newFont(12 + offset),
    regular = love.graphics.newImageFont('images/font.png',   " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\""),
    large = love.graphics.newFont(24 + offset),
    very_large = love.graphics.newFont(48 + offset)
  }
end

function game:setMode(mode)
  self.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height)
  if self.graphics.mode.height < 600 then
    self:createFonts(-2)
  else
    self:createFonts(0)
  end
  if self.view.updateDisplay then
    self.view.updateDisplay()
  end
end


function game:startMenu()
  game.current_state = StartMenu()
end

function game:start()
  game.current_state = MapState()
end

function game:killed(player)
  game.current_state = FinishScreen(player)
end
