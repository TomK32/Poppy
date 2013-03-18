anim8 = require 'lib/anim8'

function createAnimation(image_path, grid_options, animation_options)
  local image = love.graphics.newImage(image_path)
  local grid = anim8.newGrid(grid_options[1], grid_options[2], image:getWidth(), image:getHeight())
  local animation = anim8.newAnimation(animation_options[1], grid(animation_options[2]), animation_options[3])
  return { image = image, animation = animation }
end

local default_grid_size = {48, 48}
-- Create animation.
local animations = {

  tina = {
    standing = createAnimation('images/tina_standing_48.png', default_grid_size, {'loop', '1-2,1', 1.4}),
    walking_right = createAnimation('images/tina_walking_48.png', default_grid_size, {'loop', '1-3,1', 1.4}),
    walking_left = createAnimation('images/tina_walking_48.png', default_grid_size, {'loop', '4-6,1', 1.4})
  },
  chris = {
    standing = createAnimation('images/chris_standing_48.png', default_grid_size, {'loop', '1-2,1', 0.8}),
    walking_right = createAnimation('images/chris_walking_48.png', default_grid_size, {'loop', '1-2,1', 0.8}),
    walking_left = createAnimation('images/chris_walking_48.png', default_grid_size, {'loop', '1-2,1', 0.8})
  },
  poppy = {
    standing = createAnimation('images/poppy_standing_48.png', default_grid_size, {'loop', '1-2,1', 0.8}),
    walking_right = createAnimation('images/poppy_walking_48.png', default_grid_size, {'loop', '1-2,1', 0.8}),
    walking_left = createAnimation('images/poppy_walking_48.png', default_grid_size, {'loop', '3-4,1', 0.8})
  },
  tourist = {
    {
      standing = createAnimation('images/tourist_1_walking_48.png', default_grid_size, {'loop', '1-2,1', 0.8}),
      walking_right = createAnimation('images/tourist_1_walking_48.png', default_grid_size, {'loop', '1-4,1', 0.8}),
      walking_left = createAnimation('images/tourist_1_walking_48.png', default_grid_size, {'loop', '5-8,1', 0.8}),
    }
  },
  diary = createAnimation('images/diary_48.png', default_grid_size, {'loop', '1-2,1', 0.8})
}


return animations

