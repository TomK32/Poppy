
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'actors/actor'
require 'actors/player'

MapState = class("MapState", State)
function MapState:initialize()
end

function MapState:draw()
  self.view:draw()

  self.score_view:draw()

  love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
end

function MapState:update(dt)
  dt = 0.05
  self.level.player:update(dt)
  if game.realtime or game.ticked then
    self.level:update(dt)
    self.view:update()
    game.ticked = false
  end
end
