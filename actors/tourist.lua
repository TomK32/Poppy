

-- they run around randomly

Tourist = class("Tourist", Actor)

-- called when the player is standing next to and tries to enter
function Tourist:playerActing(player)

end

function Tourist:collision(entity)
  if entity.class == Player and entity:has('Diary') then
    game:victory(entity)
  end
end
