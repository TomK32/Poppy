
Follower = class("Follower", Actor)


function Follower:initialize(target, name, animation)
  Actor.initialize(self)
  self.target = target -- who to follow
  self.name = name
  self.animation_data = animation
  self.looked_for_path = false
  self.shouted_for_target = 5 * 0.05
end

function Follower:updateActor(dt)
  self.moved = false
  if self:animation() then
    self:animation():update(dt)
  end
  if self.target.has_diary and not Follower.shouted_for_diary then
    Follower.shouted_for_diary = true
    love.audio.play(game.sounds.speech.shout_for_diary)
  end
  if self.shouted_for_target > 0 then
    self.shouted_for_target = self.shouted_for_target - dt
  end
  if self:distanceToTarget() < 3 then
    return
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
        self.shouted_for_target = 10*dt
        love.audio.play(game.sounds.speech.poppy_come_back)
      end
    end 

    -- and now revert the temporary change for lua-astar
    self.passable = self_passable
    self.target.passable = target_passable
  end
end

function Follower:distanceToTarget()
  return self:distanceTo(self.target.position)
end

