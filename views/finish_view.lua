
FinishView = class("FinishView", View)

function FinishView:initialize(player, message)
  self.display.x = 40
  self.display.align = { y = 'center' }
  self:setDisplay(self.display)
  self.player = player
  self.message = message or 'Finish'
end

function FinishView:drawContent()
  love.graphics.setFont(game.fonts.regular)

  love.graphics.scale(2,2)
  love.graphics.setColor(200, 50, 50, 255)

  love.graphics.print(self.message, 0, 0)

  love.graphics.setColor(255,255,255,255)
  love.graphics.print('Press [space] to return to the start menu', 0, 50)
end
