SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed)
  self.map = nil
  self.level = nil
  self.seed = seed
  self:incrementSeed(0)
  self.dt = {  } -- various timers
end

function MapGenerator:incrementSeed(dt)
  self.seed = self.seed + dt
  SimplexNoise.seedP(self.seed)
end

-- fill a whole map
function MapGenerator:randomize()
  self.level.player = self:newActor(Player, 21) -- place on the beach
end

function MapGenerator:update(dt)
  -- generate new entities
end

-- int, int, 0..1, 0..1, int, int
function MapGenerator:seedPosition(seed_x,seed_y, scale_x, scale_y, offset_x, offset_y)
  self:incrementSeed(1)
  scale_x = scale_x or 1
  scale_y = scale_y or 1
  offset_x = offset_x or 0
  offset_y = offset_y or 0
  return {
    x = math.floor((SimplexNoise.Noise2D(seed_x*0.1, seed_x*0.1)) * self.map.width),
    y = math.floor((SimplexNoise.Noise2D(seed_y*0.1, seed_y*0.1)) * self.map.height)
  }
end

-- klass: Player, Actor etc
-- x1, y1, x2, y2 to limit the area where to spawn
function MapGenerator:newActor(klass, z, x1, y1, x2, y2)
  local actor = klass()
  actor.position.x = math.floor(self.map.width / 2)
  actor.position.y = 2
  actor.position.z = z or 1
  actor.orientation = math.pi * 1.5
  self.map:addEntity(actor)
  return actor
end

function MapGenerator:fillTiles(x1, y1, x2, y2, callback)
  local tiles = {}
  for x=math.floor(x1), math.floor(x2-x1+1) do
    tiles[x] = {}
    for y=math.floor(y1), math.abs(math.floor(y2-y1+1)) do
      tiles[x][y] = callback(x,y)
    end
  end
  return tiles
end
