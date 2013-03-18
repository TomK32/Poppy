Actor = class("Actor", Entity)

function Actor:initialize()
  Entity.initialize(self, {})
  self.dt_between_step = 1
  self.position = { x = 0, y = 0}
  self.passable = false
  self.state = 'standing'
end

function Actor:move(offset)
  self.moving_position = { x = self.moving_position.x + offset.x, y = self.moving_position.y + offset.y }
  if offset.x < 0 then
    self.state = 'walking_left'
  else
    self.state = 'walking_right'
  end
  local new_position = self:addVectors(self.position, offset)
  if self.map:getNode(new_position) then
    self.position = new_position
  end
end

function Actor:tick()
  self.moved = true
end

function Actor:drawHealthBar()

end

function Actor:drawContent()
  if self.particles then
    love.graphics.draw(self.particles, 0, 0)
  end
  if self:animation() then
    Entity.drawContent(self)
  else
    game.renderer:print('@', {0,255,0,255}, 0, 0)
  end
end

function Actor:update(dt)
  -- slowly change the moving_position towards 0 for a walk animation
  local m_x = self.moving_position.x
  local m_y = self.moving_position.y
  if m_x < 0 then m_x = math.min(m_x + dt, 0) end
  if m_x > 0 then m_x = math.max(m_x - dt, 0) end
  if m_y < 0 then m_y = math.min(m_y + dt, 0) end
  if m_y > 0 then m_y = math.max(m_y - dt, 0) end
  self.moving_position = {x = m_x, y = m_y}
  if m_x == 0 and m_y == 0 then
    self.state = 'standing'
  end
  self:updateActor(dt)
  local old_position = { x = self.position.x, y = self.position.y }
  self.map:fitIntoMap(self.position)
  if old_position.x ~= self.position.x or old_position.y ~= self.position.y then
    self.moving_position = {x = 0, y = 0}
  end
end

function Actor:distanceTo(position)
  return math.sqrt(math.abs(self.position.x - position.x) ^ 2 + math.abs(self.position.y - position.y) ^ 2)
end

function Actor:nodeToDirection(node)
  return {
    x = node.location.x - self.position.x,
    y = node.location.y - self.position.y }
end

function Actor:includesPoint(other_position)
  return self.position.x == other_position.x and self.position.y == other_position.y
end

function Actor:addVectors(a, b)
  return {x = a.x + b.x, y = a.y + b.y}
end
