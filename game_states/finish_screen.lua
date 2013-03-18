
require 'views/finish_view'

FinishScreen = class("FinishScreen", State)

function FinishScreen:initialize(player, message)
  self.view = FinishView(player, message)
end

function FinishScreen:keypressed(key)
  if key == ' ' then
    game:startMenu()
  end
end
