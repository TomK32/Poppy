-- Entities are arranged in layers, each of which the map view has to draw
-- Entities are expected to have a position with x, y and z (layer)
-- and update and draw functions

Map = class("Map")
function Map:initialize(width, height, generator, level)
  self.width = width
  self.height = height
  self.layers = {} -- here the entities are stuffed into
  self.layer_indexes = {}
  self.level = level
  self.generator = generator
  self.generator.map = self
  self.generator.level = level
  self.generator:randomize()
end

function Map:addEntity(entity)
  entity.map = self
  if not self.layers[entity.position.z] then
    self.layers[entity.position.z] = {}
    table.insert(self.layer_indexes, entity.position.z)
    table.sort(self.layer_indexes, function(a,b) return a < b end)
  end
  table.insert(self.layers[entity.position.z], entity)
end

function Map:fitIntoMap(position)
  -- The map is wrapped on the x-axis, meaning if something leaves on one side it
  -- reappears on the opposing side
  if position.x < 0 then
    position.x = self.width
  elseif position.x > self.width then
    position.x = 0
  end
  -- for the up/down make it hard borders
  if position.y < 0 then
    position.y = 0
  elseif position.y > self.height then
    position.y = self.height
  end
  return position
end

function Map:belowPosition(position)
  -- only search layers under the position.z
  local result = {}
  for i=1, position.z do
    if self.layers[position.z - i + 1] then
      for e, entity in ipairs(self.layers[position.z - i + 1]) do
        if entity.includesPoint and entity:includesPoint(position) then
          table.insert(result, entity)
        end
      end
    end
  end
  return result
end

function Map:entitiesOfType(position, _type)
  local result = {}
  for i, entity in ipairs(self:belowPosition(position)) do
    if entity._type == _type then
      table.insert(result, entity)
    end
  end
  return result
end

