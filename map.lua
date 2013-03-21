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
  elseif position.x + 1 >= self.width then
    position.x = self.width - 1
  end
  -- for the up/down make it hard borders
  if position.y < 0 then
    position.y = 0
  elseif position.y + 1 > self.height then
    position.y = self.height - 1
  end
  return position
end

function Map:belowPosition(position)
  -- only search layers under the position.z
  local result = {}
  local layer = position.z
  if #self.layer_indexes == 0 then return {} end
  if not layer then layer = self.layer_indexes[#self.layer_indexes] end
  for i=1, layer do
    if self.layers[layer - i + 1] then
      for e, entity in ipairs(self.layers[layer - i + 1]) do
        if entity.includesPoint and entity:includesPoint(position) then
          table.insert(result, entity)
        end
      end
    end
  end
  return result
end

function Map:entitiesOfType(_type)
  local result = {}
  local top_layer = self.layer_indexes[#self.layer_indexes]
  for i=0, top_layer do
    if self.layers[top_layer - i] then
      for e, entity in ipairs(self.layers[top_layer - i]) do
        if entity._type == _type then
          table.insert(result, entity)
        end
      end
    end
  end
  return result
end

-- compability for AStar
function Map:getNode(position)
  local passable = true
  local entities = self:belowPosition(position)
  if #entities > 0 then
    if self.level.map_passable and self.level.map_passable[position.x] and self.level.map_passable[position.x][position.y] == 0 then
      return nil
    end
    for i, entity in ipairs(entities) do
      if entity.passable == false then
        return nil
      end
    end
  end
  return Node(position, 1, position.x * self.width + position.y)
end

function Map:locationsAreEqual(a,b)
  return a.x == b.x and a.y == b.y
end

function Map:getAdjacentNodes(curnode, dest)
  local result = {}
  local cl = curnode.location
  local dl = dest

  local n = false

  n = self:_handleNode(cl.x + 1, cl.y, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x - 1, cl.y, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x, cl.y + 1, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  n = self:_handleNode(cl.x, cl.y - 1, curnode, dl.x, dl.y)
  if n then
    table.insert(result, n)
  end

  return result
end

function Map:_handleNode(x, y, fromnode, destx, desty)
  -- Fetch a Node for the given location and set its parameters
  local n = self:getNode({x = x, y = y})

  if n ~= nil then
    local dx = math.max(x, destx) - math.min(x, destx)
    local dy = math.max(y, desty) - math.min(y, desty)
    local emCost = dx + dy

    n.mCost = n.mCost + fromnode.mCost
    n.score = n.mCost + emCost
    n.parent = fromnode

    return n
  end

  return nil
end
