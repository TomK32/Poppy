NewVersionView = class("NewVersionView", View)

NewVersionView.gui = require 'lib/quickie'

NewVersionView.background_image = love.graphics.newImage('images/start_menu_background.png')
function NewVersionView:initialize(version)
  View.initialize(self)
  self.version = version
end

function NewVersionView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  love.graphics.draw(self.background_image)
  local x = game.graphics.mode.width / 5
  local y = game.graphics.mode.height / 4

  love.graphics.setColor(255,255,255,100)
  love.graphics.rectangle('fill', x-10, y-10, 350, 150)

  love.graphics.setColor(50, 50, 50, 255)

  love.graphics.print(_('There is a new version: ') .. self.version, x, y)
  love.graphics.print(_('Do you want to upgrade?'), x, y+30)
  love.graphics.print(game.url, x, y+60)

  love.graphics.setColor(55,55,55,255)
  self.gui.core.draw()
  self.gui.group.push({grow = "right", pos = {x, y+100}})
  -- start the game
  if self.gui.Button({text = _('Yes')}) then
    self.state:openUrl()
  end
  self.gui.group.push({grow = "right", pos = {20, 0}})
  if self.gui.Button({text = _('No')}) then
    self.state:close()
  end

end

