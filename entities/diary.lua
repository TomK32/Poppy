
Diary = class("Diary", Entity)

Diary.animation_data = game.animations.diary

function Diary:playerEntered(player)
  player:addToInventory(self)
  self.dead = true
end
