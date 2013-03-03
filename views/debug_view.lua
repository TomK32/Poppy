
DebugView = class('DebugView', View)

function DebugView:setDisplay()
  self.display = {
    x = 10,
    y = game.graphics.mode.heigth - 100,
    height = 80,
    width = 250
  }
end

function DebugView:drawContent()
  game.renderer.print('Pos: ' .. game.player.x
end
