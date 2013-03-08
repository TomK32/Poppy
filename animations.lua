anim8 = require 'lib/anim8'

function createAnimation(image_path, grid_options, animation_options)
  local image = love.graphics.newImage(image_path)
  local grid = anim8.newGrid(grid_options[1], grid_options[2], image:getWidth(), image:getHeight())
  local animation = anim8.newAnimation(animation_options[1], grid(animation_options[2]), animation_options[3])
  return { image = image, animation = animation }
end

local default_grid_size = {32, 32}
-- Create animation.
local animations = {

  tina = {
    standing = createAnimation('images/tina_standing.png', default_grid_size, {'loop', '1-2,1', 0.8})
    --    walking = createAnimation('images/tina_walking.png', {32, 32}, {'loop', '1-2,1', 0.2})
  },
  poppy = {
    standing = createAnimation('images/poppy_standing.png', default_grid_size, {'loop', '1-2,1', 0.8})
  }
}


return animations

