SimplexNoise = require("lib/SimplexNoise")
LuaBit = require("lib/LuaBit")

MapGenerator = class("MapGenerator")

function MapGenerator:initialize(seed)
  self.map = nil
  self.level = nil
  self.seed = seed
  print('Seed: ' .. seed)
  self:incrementSeed(0)
  self.dt = {  } -- various timers
end

function MapGenerator:incrementSeed(dt)
  self.seed = self.seed + dt
  SimplexNoise.seedP(self.seed)
end

-- fill a whole map
function MapGenerator:randomize()
  self.level.player = self:newActor(Player({animation_data = game.animations.poppy}), 21,
        0.8, nil, 1.0, nil)
  self.level.player.level = self.level
  self:newActor(Follower({target = self.level.player, 'Tina', animation_data = game.animations.tina}), 21,
        0.4, nil, 0.6, nil)
  self:newActor(Follower({target = self.level.player, 'Chris', animation_data = game.animations.chris}), 21,
        0.4, nil, 0.6, nil)
  self:newActor(Tourist({name = 'Tourist', animation_data = game.animations.tourist[1]}), 21,
        0.8, nil, 1, nil)
  self:newActor(Tourist({name = 'Tourist', animation_data = game.animations.tourist[1]}), 21,
        0.8, nil, 1, nil)
  self:newActor(Tourist({name = 'Tourist', animation_data = game.animations.tourist[1]}), 21,
        0.8, nil, 1, nil)
  self:newDiary()
end

function MapGenerator:update(dt)
  -- generate new entities
end

-- int, int, 0..1, 0..1, 0..1, 0...1
function MapGenerator:seedPosition(seed_x, seed_y, x1, y1, x2, y2)
  self:incrementSeed(1)
  local pos = {
    x = math.abs(math.floor((SimplexNoise.Noise2D(seed_x*0.1, seed_y+1*0.1) * self.map.width))),
    y = math.abs(math.floor((SimplexNoise.Noise2D(seed_y+1*0.1, seed_y*0.1) * self.map.height)))
  }
  if x2 and x2 < 1 then
    pos.x = pos.x * x2
  end
  if y2 and y2 < 1 then
    pos.y = pos.y * y2
  end
  if x1 and x1 > 0 then
    pos.x = pos.x * (1 - x1)  + (x1 * self.map.width)
  end
  if y1 and y1 > 0 then
    pos.y = pos.y * (1 - y1) + (y1 * self.map.height)
  end
  pos.x = math.floor(pos.x)
  pos.y = math.floor(pos.y)
  return pos
end

-- klass: Player, Actor etc
-- x1, y1, x2, y2 to limit the area where to spawn
function MapGenerator:newActor(actor, z, x1, y1, x2, y2)
  self:incrementSeed(2)
  local tries = 0

  repeat
    actor.position = self:seedPosition(self.seed, self.seed+1, x1, y1, x2, y2)
    tries = tries + 1
  until self.map:getNode(actor.position) or tries > 10

  actor.map = self.level.map

  actor.position.z = z or 1
  self.map:addEntity(actor)
  return actor
end

function MapGenerator:newDiary()
  local diary = Diary({position = self:seedPosition(self.seed, self.seed+1, 0, nil, 0.2, nil)})
  diary.position.z = 20
  self.map:addEntity(diary)
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
