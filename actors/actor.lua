Actor = class("Actor")

function Actor:initialize()
  self.turns = {}
  self.direction = 0
  self.orientation = math.pi/2
  self.speed = 0
  self.max_speed = 3
  self.speed_factor = 10
  self.dt_between_step = 0.02
end

function Actor:keydown(dt)
  local dt_change = false
  if self.dt_since_input > self.dt_between_step then
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        if type(m) == 'function' then
          if self.dt_since_input > 0.5 then
            dt_change = true
            m(self, key)
          end
        end
      end
    end
  end
  if dt_change then
    self.dt_since_input = 0
  end
  self.dt_since_input = self.dt_since_input + dt
end

function Actor:tick()
  self.moved = true
end


function Actor:update(dt)
  self:keydown(dt)
  if not self.moved then
    return false
  end

  local old_position = {x = self.position.x, y = self.position.y}
  self.position.x = self.position.x - math.cos(self.orientation) * self.speed * dt * self.speed_factor
  self.position.y = self.position.y - math.sin(self.orientation) * self.speed * dt * self.speed_factor

  self.map:fitIntoMap(self.position)

end

