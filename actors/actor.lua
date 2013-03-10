Actor = class("Actor")

function Actor:initialize()
  self.dt_between_step = 1
  self.position = { x = 0, y = 0}
  self.moving_position = { x = 0, y = 0} -- for the walking animation
  self.passable = false
  self.state = 'standing'
end

function Actor:move(offset)
  self.moving_position = { x = self.moving_position.x + offset.x, y = self.moving_position.y + offset.y }
  self.state = 'walking'
  self.position.x = self.position.x + offset.x
  self.position.y = self.position.y + offset.y
end

function Actor:tick()
  self.moved = true
end

function Actor:draw()
  love.graphics.push()
  love.graphics.setColor(255,255,255,255)
  game.renderer:translate(
      self.position.x - self.moving_position.x,
      self.position.y - self.moving_position.y)
  self:drawContent()
  self:drawHealthBar()
  love.graphics.pop()
end

function Actor:drawHealthBar()

end

function Actor:drawContent()
  if self:animation() then
    self:animation():draw(self:image(), 0, 0)
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
  self.map:fitIntoMap(self.position)
end

function Actor:distanceTo(position)
  return math.sqrt(math.abs(self.position.x - position.x) ^ 2 + math.abs(self.position.y - position.y) ^ 2)
end

function Actor:nodeToDirection(node)
  return {
    x = node.location.x - self.position.x,
    y = node.location.y - self.position.y }
end

function Actor:animation()
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].animation
end

function Actor:image()
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].image
end

function Actor:includesPoint(other_position)
  return self.position.x == other_position.x and self.position.y == other_position.y
end
