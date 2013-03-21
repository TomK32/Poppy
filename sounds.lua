
local sounds = {}

sounds.fx = {
  hurt1 = love.audio.newSource("sounds/hurt1.mp3", "static"),
  pickup = love.audio.newSource("sounds/pickup.mp3", "static")
}

sounds.player = {
  woof = love.audio.newSource("sounds/woof.mp3", "static")
}

sounds.speech = {
  shout_for_diary = love.audio.newSource("sounds/poppy_bring_it_to_me.mp3", "static"),
  poppy_come_back = love.audio.newSource("sounds/poppy_come_back.mp3", "static")
}

sounds.music = {
  track01 = love.audio.newSource("sounds/md gramm - place du marche.mp3")
}

for i, sound in pairs(sounds.music) do
  sound:setLooping(true)
end

return sounds
