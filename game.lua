
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
  tile_size = {x = 48, y = 48},
  version = require('version'),
  url = 'http://ananasblau.com/poppy'
}

function game:createFonts(offset)
  local font_file = 'fonts/Comfortaa-Regular.ttf'
  self.fonts = {
    lineHeight = (20 + offset) * 1.7,
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
  love.mouse.setVisible(true)
  game.current_state = StartMenu()
end

function game:start()
  love.mouse.setVisible(false)
  game.current_state = MapState()
end

function game:killed(player)
  game.current_state = FinishScreen(player, _('You have lost :('))
end

function game:victory(player)
  game.current_state = FinishScreen(player, _('You have won!'))
end

function game.loadImage(image)
  return love.graphics.newImage(image)
end


function game:newVersion(version, url)
  game.current_state = NewVersion(version, url)
end

function game:showCredits()
  game.current_state = State(self, 'Credits', CreditsView())
end
