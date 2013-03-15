
game = {
  title = 'Poppy (working title)',
  debug = false,
  graphics = {
    mode = { height = love.graphics.getHeight(), width = love.graphics.getWidth() },
    fullscreen = true
  },
  fonts = {},
  renderer = require('renderers/default'),
  sounds = require('sounds'),
  animations = require('animations'),
  tile_size = {x = 48, y = 48}
}

function game:createFonts(offset)
  local font_file = 'fonts/Comfortaa-Regular.ttf'
  self.fonts = {
    lineHeight = (10 + offset) * 1.7,
    small = love.graphics.newFont(font_file, 16 + offset),
    regular = love.graphics.newFont(font_file, 20 + offset),
    large = love.graphics.newFont(font_file, 24 + offset),
    very_large = love.graphics.newFont(font_file, 36 + offset)
  }
end

function game:setMode(mode)
  self.graphics.mode = mode
  love.graphics.setMode(mode.width, mode.height, mode.fullscreen or self.graphics.fullscreen)
  if self.graphics.mode.height < 600 then
    self:createFonts(-2)
  else
    self:createFonts(0)
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


function game.loadImage(image)
  return love.graphics.newImage(image)
end
