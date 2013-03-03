
ScoreView = class("ScoreView", View)

function ScoreView:initialize()
  self:setDisplay({
    align = {
      x = 'right',
      y = 'top',
    },
    width = 200,
    height = 50
  })
end

function ScoreView:drawContent()
  love.graphics.setColor(255,255,255,50)
  love.graphics.rectangle('fill', 0, 0, self.display.width, self.display.height)
  love.graphics.setColor(255,50,0,255)
  love.graphics.print('Score: ' .. tostring(self.player.score), 10, 10)
end
