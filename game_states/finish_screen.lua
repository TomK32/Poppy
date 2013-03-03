
require 'views/finish_view'

FinishScreen = class("FinishScreen", State)

function FinishScreen:initialize(player)
  self.view = FinishView(player)
end

function FinishScreen:keypressed(key)
  if key == ' ' then
    game:startMenu()
  end
end
