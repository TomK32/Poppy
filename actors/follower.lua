
Follower = class("Follower", Actor)


function Follower:initialize(target, name, animation)
  Actor.initialize(self)
  self.target = target -- who to follow
  self.name = name
  self.animation_data = animation
end

function Follower:update(dt)
  self.moved = false
  if self:animation() then
    self:animation():update(dt)
  end
  if self:distanceToTarget() < 3 then
    return
  else
    local path = game.current_state.level.astar:findPath(self.position, self.target.position)
    if path then
      self:move(self:nodeToDirection(path:getNodes()[1]))
      
    end 
  end
end

function Follower:distanceToTarget()
  return self:distanceTo(self.target.position)
end

