
require 'views/new_version_view'

NewVersion = class("NewVersion", State)

function NewVersion:initialize(version, url)
  self.version = version
  self.url = url
  self.view = NewVersionView(version, url)
  self.view.state = self
end

function NewVersion:openUrl()
  if love._os == 'OS X' then
    os.execute('open ' .. self.url)
  elseif love._os == 'Windows' then
    os.execute('start ' .. self.url)
  elseif love._os == 'Linux' then
    os.execute('xdg-open ' .. self.url)
  end
end
function NewVersion:close()
  game:startMenu()
end
