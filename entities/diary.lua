
Diary = class("Diary", Entity)

Diary.animation_data = game.animations.diary

function Diary:playerEntered(player)
  player:addToInventory(self)
  player:targetReached('Diary')
  love.audio.play(game.sounds.fx.pickup)
  self.dead = true
end

