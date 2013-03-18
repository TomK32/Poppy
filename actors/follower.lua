
Follower = class("Follower", Actor)

-- singleton, run only once when the target has found the diary
Follower.shouted_for_diary = false

-- singleton, seek out and put the target back on its leash
Follower.catch_target = false
Follower.particle_images = {
  evil = love.graphics.newImage('images/particles/evil_follower.png')
}

function Follower:initialize(target, name, animation)
  Actor.initialize(self)
  self.target = target -- who to follow
  self.name = name
  self.animation_data = animation
  self.looked_for_path = false
  self.shouted_for_target = 5 * 0.05
  self.target_max_distance = 5
  self.dt_since_last_step = 0.0
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
  if self.particles then
    self.particles:update(dt)
  elseif Follower.catch_target then
    -- they hunt the player, let's give them evil particles
    self:startEvilParticles()
  end
  self.dt_since_last_step = self.dt_since_last_step + dt
  if self.dt_since_last_step < 50 * dt then
    return
  end
  self.dt_since_last_step = 0

  if self:distanceToTarget() < self.target_max_distance then --and not Follower.catch_target then
    local movement = {x = math.floor(math.random() * 3)-1, y = math.floor(math.random() * 3)-1}
    if self:distanceToTarget(self:addVectors(self.target.position, {x = - movement.x, y = - movement.y})) < self.target_max_distance/2 then
      self:move(movement)
      return
    end
  elseif self.looked_for_path == false then
    -- to make lua-astar work we need to make self and the target passable
    local self_passable = self.passable
    self.passable = true
    local target_passable = self.target.passable
    self.target.passable = true


    self.looked_for_path = true
    local path = game.current_state.level.astar:findPath(self.position, self.target.position)
    if path then
      self:move(self:nodeToDirection(path:getNodes()[1]))
      self.looked_for_path = false
      if self.shouted_for_target <= 0 then
        self.shouted_for_target = 5
        love.audio.play(game.sounds.speech.poppy_come_back)
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

function Follower:startEvilParticles()
  self.particles = love.graphics.newParticleSystem(Follower.particle_images.evil, 3)
  self.particles:setEmissionRate          (20)
  self.particles:setLifetime              (-1)
  self.particles:setParticleLife          (1.5)
  self.particles:setPosition              (game.tile_size.x / 2, game.tile_size.y / 2)
  self.particles:setDirection             (math.pi * 1.5)
  self.particles:setSpread                (1)
  self.particles:setSpeed                 (0, 30)
  self.particles:setGravity               (0)
  self.particles:setRadialAcceleration    (10)
end
