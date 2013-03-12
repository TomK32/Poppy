
Diary = class("Diary", Entity)

Diary.animation_data = game.animations.diary

function Diary:playerEntered(player)
  player.has_diary = true
  self.dead = true
end
