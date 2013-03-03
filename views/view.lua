
View = class("View")
View:include({
  display = {x = 0, y = 0, width = 200, height = 100},
  focus = nil,

  draw = function(self)
    love.graphics.push()
    love.graphics.translate(self.display.x, self.display.y)
    self:drawContent()
    love.graphics.pop()
  end
})

function View:setDisplay(display)
  self.display = display
  if display.align then
    if display.align.x == 'center' then
      display.x = game.graphics.mode.width / 2 - display.width / 2
    elseif display.align.x == 'right' then
      display.x = game.graphics.mode.width - display.width
    end
    if display.align.y == 'center' then
      display.y = game.graphics.mode.height / 2 - display.height / 2
    elseif display.align.y == 'top' then
      display.y = 0
    end
  end
end

