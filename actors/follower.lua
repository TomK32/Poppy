
Follower = class("Follower", Actor)


function Follower:initialize(target, name, animation)
  Actor.initialize(self)
  self.target = target -- who to follow
  self.name = name
  self.animation_data = animation
  self.state = 'standing'
end

function Follower:update(dt)
  self.moved = false
  if self:animation() then
    self:animation():update(dt)
  end
  if self:distanceToTarget() < 3 then
    return
  else
    print("Move")
  end
end

function Follower:drawContent()
  if self:animation() then
    self:animation():draw(self:image(), 0, 0)
  else
    game.renderer:translate(self.position.x, self.position.y)
    game.renderer:print('@', {0,255,0,255}, 0, 0)
  end
end

function Follower:distanceToTarget()
  return self:distanceTo(self.target.position)
end

function Follower:animation()
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].animation
end

function Follower:image()
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].image
end
