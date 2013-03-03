require('views/score_view')

MapView = class("MapView", View)
MapView:include({
  map = nil,
  top_left = { x = 0, y = 0 }, -- offset
  scale = { x = 16, y = 16 },
  canvas = nil,
})

function MapView:initialize(map)
  self.map = map
  self:updateDisplay()
  self.draw_cursor = false
  self.canvas = love.graphics.newCanvas(self.display.width, self.display.height)
end

function MapView:updateDisplay()
  self.display = {
    x = 10,
    y = 10,
    width = math.min(self.map.width * self.scale.x, game.graphics.mode.width) - 20,
    height = math.min(self.map.height * self.scale.y, game.graphics.mode.height) - 20
  }
  self.display.tiles = {
    x = math.floor(self.display.width / self.scale.x),
    y = math.floor(self.display.height / self.scale.y)
  }
end

function MapView:drawContent()
  if self.canvas then
    love.graphics.setColor(255,255,255,155)
    love.graphics.draw(self.canvas, 0, 0)
  end
end

function MapView:update()
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor(55,55,55,255)
  love.graphics.rectangle('fill', 0,0,game.graphics.mode.width, game.graphics.mode.height)
  love.graphics.translate(0, self.display.height)
  for i, layer in ipairs(self.map.layer_indexes) do
    entities = self.map.layers[layer]
    for i,entity in ipairs(entities) do
      love.graphics.push()
      entity:draw()
      love.graphics.pop()
    end
  end
  love.graphics.setCanvas()
  return self.canvas
end

function MapView:centerAt(position)
  x = position.x - math.floor(self:tiles_x() / 2)
  y = position.y - math.floor(self:tiles_y() / 2)
  if math.abs(self.top_left.x - x) >= 1 or math.abs(self.top_left.y - y) >= 1 then
    self.top_left = {x = x, y = y}
    self:fixTopLeft()
  end
  self:update()
end

function MapView:moveTopLeft(offset, dontMoveCursor)
  self.top_left.x = self.top_left.x + 3 * offset.x
  self.top_left.y = self.top_left.y + 3 * offset.y
  fixTopLeft()
  if not dontMoveCursor then
    self:moveCursor({x = offset.x * 3, y = offset.y * 3}, true)
  end
end

function MapView:fixTopLeft()
  max_x = math.floor(self.map.height - self:tiles_x())
  if self.top_left.x < 0 then
    self.top_left.x = 0
  elseif self.top_left.x > max_x then
    self.top_left.x = max_x + 1
  end
  max_y = math.floor(self.map.height - self:tiles_y())
  if self.top_left.y < 0 then
    self.top_left.y = 0
  elseif self.top_left.y > max_y then
    self.top_left.y = max_y + 1
  end
end
