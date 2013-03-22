
require 'views/finish_view'

FinishScreen = class("FinishScreen", State)

function FinishScreen:initialize(player, message)
  self.view = FinishView(player, message)
  self.view.state = self
end

function FinishScreen:keypressed(key, unicode)
  if key == ' ' then
    game:startMenu()
  end
  self.view.gui.keyboard.pressed(key, code)
end
