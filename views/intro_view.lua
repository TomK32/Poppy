

IntroView = class("IntroView", View)

IntroView.intro = love.graphics.newImage('images/intro.png')
IntroView.position = {x = love.graphics.getWidth() / 2,
  y = love.graphics.getHeight() / 2 - IntroView.intro:getHeight() / 2,
}

function IntroView:drawContent()
  love.graphics.setFont(game.fonts.regular)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.intro, self.position.x, self.position.y)
end


