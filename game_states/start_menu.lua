require 'views/start_menu_view'

StartMenu = class("Menu", State)

function StartMenu:initialize()
  self.view = StartMenuView()
end

function StartMenu:update(dt)
  self.view:update(dt)
end

function StartMenu:keypressed(key)
  if key == 'n' then
    game:start()
  end
end
