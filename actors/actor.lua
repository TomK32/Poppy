Actor = class("Actor")

function Actor:initialize()
  self.dt_between_step = 1
  self.position = { x = 0, y = 0}
end
function Actor:move(offset)
  self.position.x = self.position.x + offset.x
  self.position.y = self.position.y + offset.y
end

function Actor:tick()
  self.moved = true
end


function Actor:update(dt)
  if not self.moved then
    return false
  end

  self.map:fitIntoMap(self.position)

end

function Actor:distanceTo(position)
  return math.sqrt(math.abs(self.position.x - position.x) ^ 2 + math.abs(self.position.y - position.y) ^ 2)
end
