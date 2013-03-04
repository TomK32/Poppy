Actor = class("Actor")

function Actor:initialize()
  self.dt_between_step = 1
end

function Actor:keydown(dt)
  local movement = {x = 0, y = 0}
  local dt_change = false
  if self.dt_since_input > self.dt_between_step then
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        if type(m) == 'function' then
          if self.dt_since_input > 0.5 then
            dt_change = true
            m(self, key)
          end
        else
          self.dt_since_input = 0
          self.moved = true
          movement.x = movement.x + m.x
          movement.y = movement.y + m.y
        end
      end
    end
    if self.moved then
      self:move(movement)
    end
  end
  if dt_change then
    self.dt_since_input = 0
  end
  self.dt_since_input = self.dt_since_input + dt
end

function Actor:move(offset)
  self.position.x = self.position.x + offset.x
  self.position.y = self.position.y + offset.y
end

function Actor:tick()
  self.moved = true
end


function Actor:update(dt)
  self:keydown(dt)
  if not self.moved then
    return false
  end

  self.map:fitIntoMap(self.position)

end

