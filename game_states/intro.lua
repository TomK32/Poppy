
require 'views/intro_view'

Intro = class("Intro", State)

function Intro:initialize(callback)
  self.callback = callback
  self.view = IntroView()
  self.timer = 3.0
end

function Intro:update(dt)
  self.timer = self.timer - dt
  if self.timer < 0 then
    self.callback()
  end
  self.view:update(dt)
end

function Intro:keypressed(key, unicode)
  self.callback()
end

function Intro:mousepressed(x, y, button)
  self.callback()
end
