
require 'views/intro_view'

Intro = class("Intro", State)

function Intro:initialize(callback)
  self.callback = callback
  self.view = IntroView()
end

function Intro:keypressed(key, unicode)
  self.callback()
end

