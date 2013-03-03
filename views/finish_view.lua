
FinishView = class("FinishView", View)

function FinishView:initialize(player)
  self.display.x = 40
  self.display.align = { y = 'center' }
  self:setDisplay(self.display)
  self.player = player
end

function FinishView:drawContent()
  love.graphics.setFont(game.fonts.regular)

  love.graphics.push()
  love.graphics.scale(2,2)
  love.graphics.setColor(200, 50, 50, 255)

  love.graphics.print("Finish", 0, 0)

  love.graphics.setColor(255,255,255,255)
  love.graphics.print('Press [space] to return to the start menu', 0, 50)
  love.graphics.pop()
end
