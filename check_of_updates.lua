
local http = require 'socket.http'
local latest_version_url = 'http://pastebin.com/raw.php?i=v0jPMYRX'
local game_url = 'http://ananasblau.com/poppy/'

local response = {}
a,b,c = http.request({url = latest_version_url, sink = ltn12.sink.table(response)})
local latest_version = response[1]

-- see if it a valid string like 1.2.345 and if the version is newer
if (string.find(latest_version, '%d%.%d%.%d+') == 1 and game.version < latest_version) then
  return {version = latest_version, url = game_url}
end
return false
