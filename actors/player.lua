
Player = class("Player", Actor)
Player.input_alternatives = {
  arrows = {
    keyboard = {
      up = 'up',
      down = 'down',
      left = 'left',
      right = 'right',
      action = ' '
    }
  },
  wasd = {
    keyboard = {
      up = 'w',
      down = 's',
      left = 'a',
      right = 'd',
      action = ' '
    }
  }
}
Player.movements = {
  up    = { x = 0, y =   1 },
  down  = { x = 0, y = - 1 },
  left  = { x = - 1, y = 0 },
  right = { x =   1, y = 0 },
}

function Player:initialize(position, animation)
  Actor.initialize(self)
  self.position = position or {x = 1, y = 1}
  self.dt_since_input = 0
  self.entity_type = 'Actor'
  self.inputs = {}
  self:setInputs(Player.input_alternatives['wasd'])
  self:setInputs(Player.input_alternatives['arrows'])
  self.animation_data = animation
  self.passable = true
  self.has_diary = false
end

function Player:setInputs(inputs)
  for direction, key in pairs(inputs.keyboard) do
    if Player.movements[direction] then
      self.inputs[key] = Player.movements[direction]
    elseif type(self[direction]) == 'function' then
      self.inputs[key] = self[direction]
    end
  end
end

function Player:move(offset)
  if self.level.map:getNode(self:addVectors(self.position, offset)) then
    Actor.move(self, offset)
  end
end

function Player:updateActor(dt)
  self.moved = false
  self:keydown(dt)
  if self:animation() then
    self:animation():update(dt)
  end
  if not self.moved then
    return false
  end
end

function Player:keydown(dt)
  local movement = {x = 0, y = 0}
  local dt_change = false
  if self.dt_since_input > self.dt_between_step then
    for key, m in pairs(self.inputs) do
      if love.keyboard.isDown(key) then
        if type(m) == 'function' then
          if self.dt_since_input > 0.5 then
            dt_change = true
            return m(self, key)
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

function Player:action(key)
  love.audio.play(game.sounds.player.woof)
end
