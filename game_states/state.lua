
State = class("State")

function State:initialize(game, name)
  self.name = name
  self.game = game
end

function State:update(dt)
end

function State:draw()
  if self.view then
    self.view:draw()
  end
end

function State:keypressed(key)
end
