
require 'views/view'
gui = require 'lib/quickie'

StartMenuView = class("MenuView", View)
gui.core.style.color.normal.bg = {80,180,80}

StartMenuView.title = love.graphics.newImage('images/title.png')
StartMenuView.background_image = love.graphics.newImage('images/start_menu_background.png')

StartMenuView.volume = { value = love.audio.getVolume(), min = 0.01, max = 1.0 }

function StartMenuView:drawContent()
  love.graphics.setFont(game.fonts.large)

  love.graphics.setColor(255 ,255 , 235 , 255)
  love.graphics.draw(self.background_image)

  gui.core.draw()
  x = math.min(400, game.graphics.mode.width / 3)
  y = 80

  love.graphics.setFont(game.fonts.very_large)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.title, x, y)

  love.graphics.setFont(game.fonts.large)
  love.graphics.translate(x, math.min(500, game.graphics.mode.height * 0.8))
  love.graphics.print(_("Some nerds killed your Father."), 0, 0)
  love.graphics.translate(0, game.fonts.lineHeight)
  love.graphics.print(_("Now it's time for you to get them hanged."), 0, 0)

  love.graphics.translate(0, 3* game.fonts.lineHeight)
  love.graphics.setFont(game.fonts.small)
  love.graphics.print(_("PS: Want to make a level? Send a mail to info@ananasblau.com"), 0, 0)

end

function StartMenuView:update(dt)
  love.graphics.setFont(game.fonts.large)
  local x = 100
  local y = 250

  gui.group.push({grow = "down", pos = {x, y}})
  -- start the game
  if gui.Button({text = _('[N]ew game')}) then
    game:start()
  end
  gui.group.push({grow = "down", pos = {0, 20}})

  -- fullscreen toggle
  if self.fullscreen then
    text = _('Windowed')
  else
    text = _('Fullscreen')
  end
  if gui.Button({text = text}) then
    self.fullscreen = not self.fullscreen
    love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), self.fullscreen)
  end

  gui.group.push({grow = "down", pos = {0, 40}})
  local locales = {English = '', Deutsch = 'de-DE', ['Русский'] = 'ru-RU'}
  for language, locale in pairs(locales) do
    if gui.Button({text = language}) then
      babel.switchLocale(locale)
    end
  end

  gui.group.push({grow = "down", pos = {0, 20}})
  gui.Label({text = _("Volume")})
  if gui.Slider({info = self.volume}) then
    love.audio.setVolume(self.volume.value)
  end

  if gui.Button({text = _("Credits")}) then
    game:showCredits()
  end

end
