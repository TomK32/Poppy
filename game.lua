
game = {
  title = 'Poppy',
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
  url = 'http://ananasblau.com/poppy',
  levels = {
    require('levels/stone_circle'),
    require('levels/tram_town')
  },
  current_level = 1
}

function game:createFonts(offset)
  local font_file = 'fonts/Comfortaa-Regular.ttf'
  self.fonts = {
    lineHeight = (20 + offset) * 1.7,
    small = love.graphics.newFont(font_file, 14 + offset),
    regular = love.graphics.newFont(font_file, 20 + offset),
    large = love.graphics.newFont(font_file, 24 + offset),
    very_large = love.graphics.newFont(font_file, 48 + offset)
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
  game.current_state = MapState(game.current_level)
end

function game:hasNextLevel()
  return self.current_level < #self.levels
end

function game:nextLevel()
  if self:hasNextLevel() then
    self.current_level = self.current_level + 1
  end
  game:start()
end

function game:killed(player)
  game.current_state = FinishScreen(player, _('You have lost :('))
end

function game:caught(player)
  game.current_state = FinishScreen(player, _('You have been caught :('))
end

function game:victory(player)
  game.current_state = FinishScreen(player, _('You have won!'))
end

function game.loadImage(image)
  return love.graphics.newImage(image)
end

function game:newVersionOrStart()
  if version and version.version and version.url then
    game:newVersion(version.version, version.url)
  else
    game:startMenu()
  end
end

function game:newVersion(version, url)
  game.current_state = NewVersion(version, url)
end

function game:showCredits()
  game.current_state = State(self, 'Credits', CreditsView())
end
