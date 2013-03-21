
FinishView = class("FinishView", View)
FinishView.gui = require 'lib/quickie'
FinishView.backgrounds = {
  love.graphics.newImage('images/it is coming together.jpg')
}

function FinishView:initialize(player, message)
  View:initialize(self)
  self.player = player
  self.message = message or 'Finish'
  self.background = self.backgrounds[math.random(#self.backgrounds)]
  self.x = self.display.width - #self.message * 20 - 220
  self.y = math.max(0, self.display.height - 130)
end

function FinishView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  love.graphics.draw(self.background)
  love.graphics.setColor(50, 0, 0, 200)
  love.graphics.rectangle('fill', self.x - 10, self.y - 50, #self.message * 20 + 160, 100)

  love.graphics.setColor(200, 255, 255, 255)
  love.graphics.print(self.message, self.x, self.y - 40)
  self.gui.core.draw()
end

function FinishView:update()
  self.gui.group.push({grow = "down", pos = {self.x + 40, self.y}})

  love.graphics.setColor(255,255,255,255)
  if self.gui.Button({text = _('Return to menu')}) then
    game:startMenu()
  end
end
