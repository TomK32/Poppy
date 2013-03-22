
Diary = class("Diary", Entity)

Diary.animation_data = game.animations.diary

function Diary:initialize(...)
  Entity.initialize(self, ...)
  self.dt_timer = 0
end

function Diary:playerEntered(player)
  player:addToInventory(self)
  player:targetReached('Diary')
  love.audio.play(game.sounds.fx.pickup)
  self.dead = true
end

function Diary:update(dt)
  self.dt_timer = (self.dt_timer + dt) % math.pi
  self.moving_position = { x = math.sin(self.dt_timer)/20, y = math.sin(2* self.dt_timer)/20 }
end
