
Follower = class("Follower", Actor)


function Follower:initialize(target, name)
  Actor.initialize(self)
  self.target = target -- who to follow
  self.name = name
end

function Follower:update(dt)
  self.moved = false
  if self:distanceToTarget() < 3 then
    return
  else
    print("Move")
  end
end

function Follower:draw()
  game.renderer:translate(self.position.x, self.position.y)
  game.renderer:print('@', {0,255,0,255}, 0, 0)
end

function Follower:distanceToTarget()
  return self:distanceTo(self.target.position)
end

