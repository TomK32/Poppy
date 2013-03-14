
require 'views/view'
gui = require 'lib/quickie'

StartMenuView = class("MenuView", View)

gui.core.style.color.normal.bg = {80,180,80}
StartMenuView.background_image = love.graphics.newImage('images/start_menu_background.png')

function StartMenuView:drawContent()
  love.graphics.setFont(game.fonts.regular)

  love.graphics.setColor(255 ,255 , 235 , 255)
  love.graphics.draw(self.background_image)

  gui.core.draw()
  x = math.min(400, game.graphics.mode.width / 3)
  y = 80

  love.graphics.setFont(game.fonts.very_large)
  love.graphics.setColor(255,205,55,200)
  love.graphics.print(game.title, x, y)
  love.graphics.setColor(255,250, 210, 255)
  love.graphics.print(game.title, x-1, y-1)

  love.graphics.setFont(game.fonts.large)
  love.graphics.translate(x, math.min(500, game.graphics.mode.height * 0.8))
  love.graphics.print(_("Some nerds killed your Father."), 0, 0)
  love.graphics.translate(0, game.fonts.lineHeight * 2)
  love.graphics.print(_("Now it's time for you to get them hanged."), 0, 0)
end

function StartMenuView:update(dt)
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
  local locales = {English = '', Deutsch = 'de-DE'}
  for language, locale in pairs(locales) do
    if gui.Button({text = language}) then
      babel.switchLocale(locale)
    end
  end


end
