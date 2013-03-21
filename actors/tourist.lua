

-- they run around randomly

Tourist = class("Tourist", Actor)

function Tourist:initialize(options)
  Actor.initialize(self, options)
  self.dt_since_last_step = 0
end
-- called when the player is standing next to and tries to enter
function Tourist:playerActing(player)

end

function Tourist:collision(entity)
  if entity.class == Player and entity:has('Diary') then
    game:victory(entity)
  end
end


function Tourist:updateActor(dt)
  self.dt_since_last_step = self.dt_since_last_step + dt
  if self.dt_since_last_step > 150 * dt then
    self.dt_since_last_step = 0
    self:move(self:randomStep())
  end
end
