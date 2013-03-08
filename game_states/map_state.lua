
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'lib/astar'

require 'actors/actor'
require 'actors/player'
require 'actors/follower'

MapState = class("MapState", State)
function MapState:initialize()
self.level = Level(1, math.floor(math.random() * 100))
  self.view = MapView(self.level.map)
  game.renderer.map_view = self.view
  self.score_view = ScoreView()
  self.score_view.player = self.level.player
  self.view:update()
  love.graphics.setFont(game.fonts.small)
end

function MapState:draw()
  self.view:draw()

  self.score_view:draw()

  love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
  love.graphics.print("x: " .. self.level.player.position.x .. ', y: ' .. self.level.player.position.y, 10, 35)
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
