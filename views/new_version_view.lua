gui = require 'lib/quickie'
gui.core.style.color.normal.bg = {80,180,80}

NewVersionView = class("NewVersionView", View)

NewVersionView.background_image = love.graphics.newImage('images/start_menu_background.png')
function NewVersionView:initialize(version)
  self.display.x = 0
  self:setDisplay(self.display)
  self.version = version
end

function NewVersionView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  love.graphics.draw(self.background_image)
  local x = game.graphics.mode.width / 4
  local y = game.graphics.mode.height / 4

  love.graphics.setColor(200, 50, 50, 255)

  love.graphics.print(_('There is a new version: ') .. self.version, x, y)
  love.graphics.print(_('Do you want to upgrade?'), x, y+30)
  love.graphics.print(game.url, x, y+60)

  love.graphics.setColor(255,255,255,255)
  gui.core.draw()
  gui.group.push({grow = "right", pos = {x, y+120}})
  -- start the game
  if gui.Button({text = _('Yes')}) then
    self.state:openUrl()
  end
  gui.group.push({grow = "right", pos = {20, 0}})
  if gui.Button({text = _('No')}) then
    self.state:close()
  end

end

