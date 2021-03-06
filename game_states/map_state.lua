
require 'level'
require 'map'
require 'generators/map_generator'
require 'views/map_view'

require 'lib/astar'

require 'entities/entity'
require 'entities/diary'

require 'actors/actor'
require 'actors/player'
require 'actors/follower'
require 'actors/tourist'

MapState = class("MapState", State)
function MapState:initialize(level)
  self.level = Level(level, math.floor(math.random() * 100))
  self.log = {_('Fetch the diary that Chris has lost')}
  self.log_view = LogView(self.log)
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

  self.log_view:draw()

  love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
  love.graphics.print("x: " .. self.level.player.position.x .. ', y: ' .. self.level.player.position.y, 10, 35)
end

function MapState:update(dt)
  dt = 0.05
  self.level:update(dt)
  self.view:update()
end
