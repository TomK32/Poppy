Level = class("Level")

function Level:initialize(level, seed)
  self.level = level
  self.seed = seed
  self.dt = 0

  self.seed = self.seed + self.level

  self.generator = MapGenerator(self.seed)
  self.map = Map(
    math.floor((game.graphics.mode.width - 150) / MapView.scale.x),
    math.floor((game.graphics.mode.height - 40) / MapView.scale.y),
    self.generator, self)

end

function Level:update(dt)
  self.dt = self.dt + dt
  for layer, entities in pairs(self.map.layers) do
    for i, entity in pairs(entities) do
      if not entity.moved then
        entity:update(dt)
      end
      if entity.dead == true then
        table.remove(self.map.layers[layer], i)
      end
    end
  end
  self.generator:update(dt)
end


