
local sounds = {}

sounds.animals = {
  -- love.audio.newSource("sounds/123123.mp3", "static")
}

sounds.player = {
  woof = love.audio.newSource("sounds/woof.mp3", "static")
}

sounds.speech = {
  poppy_come_back = love.audio.newSource("sounds/poppy_come_back.mp3", "static")
}

sounds.music = {
}

return sounds
