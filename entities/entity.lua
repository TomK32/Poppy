
Entity = class("Entity")
Entity.map = nil
Entity._type = nil

function Entity:initialize(options)
  self.creation_timer = 2 + 2 * math.random()
  self.creation_timer_start = self.creation_timer

  self.name = self.class.name
  self.moving_position = { x = 0, y = 0} -- for the walking animation
  if options then
    for k, v in pairs(options) do
      self[k] = v
    end
  end
  if self._type == nil then
    self._type = self.class.name
  end

  if not self.position then
    self.position = {x = 1, y = 1, z = 1}
  end
  if not self.position.width then
    self.position.width = 1
  end
  if not self.position.height then
    self.position.height = 1
  end
end

function Entity:draw()
  love.graphics.push()
  local options = 255
  if self.creation_timer > 0 then
    opacity = math.floor(math.max(0, 255 - 255 * self.creation_timer / self.creation_timer_start))
    self.moving_position = { x = 0, y = (self.creation_timer / self.creation_timer_start) / 2}
  end
  love.graphics.setColor(255,255,255,opacity)
  game.renderer:translate(self.position.x, self.position.y)
  if self.moving_position then
    game.renderer:translate(-self.moving_position.x, -self.moving_position.y)
  end
  self:drawContent()
  love.graphics.pop()
end

function Entity:drawContent()
  if self:animation() then
    self:animation():draw(self:image(), 0, 0)
  end
end

function Entity:update(dt)
  if self.creation_timer > 0 then
    self.creation_timer = self.creation_timer - dt
  end
  if self:animation() then
    self:animation():update(dt)
  end
end

function Entity:animation()
  if not self.state then
    return self.animation_data.animation
  end

  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].animation
end

function Entity:image()
  if not self.state then
    return self.animation_data.image
  end
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].image
end
function Entity:includesPoint(point)
  if self.position.x <= point.x and self.position.y <= point.y and
      self.position.x + self.position.width >= point.x and
      self.position.y + self.position.height >= point.y then
    return true
  end
  return false
end

function Entity:createParticles(image)
  local particles = love.graphics.newParticleSystem(image, 3)
  particles:setEmissionRate          (20)
  particles:setLifetime              (-1)
  particles:setParticleLife          (1.5)
  particles:setPosition              (game.tile_size.x / 2, game.tile_size.y / 2)
  particles:setDirection             (math.pi * 1.5)
  particles:setSpread                (1)
  particles:setSpeed                 (0, 30)
  particles:setGravity               (0)
  particles:setRadialAcceleration    (10)
  return particles
end
