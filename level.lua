Level = class("Level")

function Level:initialize(level, seed)

  -- merge the level's values into this
  assert(game.levels[level], 'Level ' .. level .. ' is missing')
  for k,v in pairs(game.levels[level]) do
    self[k] = v
  end

  self.level = level
  self.seed = seed + level
  self.dt = 0

  self.generator = MapGenerator(self.seed)
  self.map = Map(28, 15, self.generator, self)

  self.astar = AStar(self.map)

end

function Level:update(dt)
  self.dt = self.dt + dt
  for layer, entities in pairs(self.map.layers) do
    for i, entity in pairs(entities) do
      entity:update(dt)
      if entity.dead == true then
        table.remove(self.map.layers[layer], i)
      end
    end
  end
  for i, entity in ipairs(self.map:belowPosition(self.player.position)) do
    if entity.playerEntered then
      entity:playerEntered(self.player)
    end
  end
  self.generator:update(dt)
end


