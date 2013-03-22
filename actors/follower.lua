
Follower = class("Follower", Actor)
Follower._type = 'Follower'

-- singleton, run only once when the target has found the diary
Follower.shouted_for_diary = false
Follower.kept_away_from_leash = false -- for a log message

-- singleton, seek out and put the target back on its leash
Follower.catch_target = false
Follower.particle_images = {
  evil = love.graphics.newImage('images/particles/evil_follower.png')
}

Follower.target = nil -- who to follow
Follower.name = name
function Follower:initialize(options)
  Actor.initialize(self, options)
  self.shouted_for_target = 5 * 0.05
  self.target_max_distance = 5
  self.dt_since_last_step = -5.0
  self.speed = 50
end

function Follower:updateActor(dt)
  self.moved = false
  if self:animation() then
    self:animation():update(dt)
  end
  if not Follower.shouted_for_diary and self.target:has('Diary') then
    Follower.shouted_for_diary = true
    Follower.catch_target = true
    love.audio.play(game.sounds.speech.shout_for_diary)
  end
  self.dt_since_last_step = self.dt_since_last_step + dt
  if self.dt_since_last_step < self.speed * dt then
    return
  end
  self.dt_since_last_step = 0

  -- stumble around when close to the target
  if self:distanceToTarget() < self.target_max_distance and not Follower.catch_target then
    local movement = self:randomStep()
    if self:distanceToTarget(self:addVectors(self.target.position, {x = - movement.x, y = - movement.y})) < self.target_max_distance/2 then
      self:move(movement)
      return
    end
  else
    -- to make lua-astar work we need to make self and the target passable
    local self_passable = self.passable
    self.passable = true
    local target_passable = self.target.passable
    self.target.passable = true

    local path = game.current_state.level.astar:findPath(self.position, self.target.position)
    if path then
      self:move(self:nodeToDirection(path:getNodes()[1]))
      -- reached target?
      if self:distanceToTarget() <= 1 then
        game:caught(self.target)
      end
      if self.shouted_for_target <= 0 then
        self.shouted_for_target = 5
        love.audio.play(game.sounds.speech.poppy_come_back)
      end
      if not Follower.kept_away_from_leash then
        Follower.kept_away_from_leash = true
        table.insert(game.current_state.log, _("Don't let them put you on a leash"))
      end
    end
    if self.shouted_for_target > 0 then
      self.shouted_for_target = self.shouted_for_target - 1
    end

    -- and now revert the temporary change for lua-astar
    self.passable = self_passable
    self.target.passable = target_passable
  end

end

function Follower:distanceToTarget(position)
  return self:distanceTo(position or self.target.position)
end

