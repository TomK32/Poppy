-- Project: GGScoreoid
--
-- Date: December 1, 2012
--
-- Version: 0.1
--
-- File name: GGScoreoid.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Update History:
--
-- 0.1 - Initial release
--
-- Comments: 
--			
--		Scoreoid is a 'non-restrictive, reliable and easy to use server platform for game developers' 
--		and GGScoreoid makes it easy to use in the Corona SDK.
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGScoreoid = {}
local GGScoreoid_mt = { __index = GGScoreoid }

local json = require( "lib/json" )

GGScoreoid.Method = {}

-- Players
GGScoreoid.Method.CreatePlayer = "createPlayer"
GGScoreoid.Method.DeletePlayer = "deletePlayer"
GGScoreoid.Method.EditPlayer = "editPlayer"
GGScoreoid.Method.UpdatePlayerField = "updatePlayerField"
GGScoreoid.Method.GetPlayerField = "getPlayerField"
GGScoreoid.Method.CountPlayers = "countPlayers"
GGScoreoid.Method.GetPlayers = "getPlayers"
GGScoreoid.Method.GetPlayerScores = "getPlayerScores"

-- Scores
GGScoreoid.Method.CreateScore = "createScore"
GGScoreoid.Method.GetScores = "getScores"
GGScoreoid.Method.CountScores = "countScores"
GGScoreoid.Method.GetBestScores = "getBestScores"
GGScoreoid.Method.GetAverageScore = "getAverageScore"
GGScoreoid.Method.CountBestScores = "countBestScores"

-- Game
GGScoreoid.Method.GetGame = "getGame"
GGScoreoid.Method.GetGameField = "getGameField"
GGScoreoid.Method.GetGameAverage = "getGameAverage"
GGScoreoid.Method.GetGameTop = "getGameTop"
GGScoreoid.Method.GetGameLowest = "getGameLowest"
GGScoreoid.Method.GetGameTotal = "getGameTotal"
GGScoreoid.Method.GetNotification = "getNotification"

--- Creates a new GGScoreoid object.
-- @return The new object.
function GGScoreoid:new( apiKey, gameID )
    
    local self = {}
    
    setmetatable( self, GGScoreoid_mt )
  
  	self.apiURL = "https://www.scoreoid.com/api/"
  	self.apiKey = apiKey
  	self.gameID = gameID

    return self
    
end

function GGScoreoid:makeRequest( method, requestParams, onComplete )

	if not method then
		return
	end

	local function networkListener( event )
        if event.isError then
        	if onComplete then
        		onComplete( false, "Network error!" )
        	end
        else
        	
        	if onComplete then
        		
        		local response = nil

        		if event.response then
        			response = json.decode( event.response )
        		end
        		
        		if response then
        			
        			--[[
        			for k, v in pairs( response ) do
        				print( k, v )
        			end
        			--]]
        			
        			if response.error then
        				onComplete( false, response.error )
        			elseif response.success then
        				onComplete( true, response.success[ 1 ] )
        			elseif response.players then -- Player Count
        				onComplete( response.players )
        			elseif method == GGScoreoid.Method.CountScores or
							method == GGScoreoid.Method.GetAverageScore or
							method == GGScoreoid.Method.CountBestScores then -- Score Count
        				onComplete( response.scores )
        			elseif response.average_score then -- Average Score
        				onComplete( response.average_score )
        			elseif response.notifications then -- Notifications
        		
        				local notifications = {}
        					
        				for k, v in pairs( response.notifications ) do
        					notifications[ #notifications + 1 ] = v[ 1 ][ "GameNotification" ] 
        				end
						
						onComplete( notifications )
						
        			else
        			
        				if method == GGScoreoid.Method.GetGame then
        					onComplete( response[ 1 ].Game )
        				elseif method == GGScoreoid.Method.GetPlayers then
        					onComplete( response )
        				elseif method == GGScoreoid.Method.GetPlayerField 
        				or method == GGScoreoid.Method.GetGameField
        				or method == GGScoreoid.Method.GetGameAverage 
        				or method == GGScoreoid.Method.GetGameTop
        				or method == GGScoreoid.Method.GetGameLowest
        				or method == GGScoreoid.Method.GetGameTotal then
        				
        					local field = nil
							local content = nil
							
							for k, v in pairs( response ) do
								field = k
								content = v
							end
							
        					onComplete( content, field )
        					
        				elseif method == GGScoreoid.Method.GetPlayerScores 
        				or method == GGScoreoid.Method.GetScores 
        				or method == GGScoreoid.Method.GetBestScores then
        			
        					local scores = {}
        					
        					for i = 1, #response, 1 do
        						scores[ i ] = response[ i ].Score
        					end
        					
        					onComplete( scores )
        					
        				end
        											
        			end
        			
        		end
        		
        	end
              
        end
        
	end
	
	requestParams = requestParams or {}
	requestParams.api_key = self.apiKey
	requestParams.game_id = self.gameID
	requestParams.response = "json"
	
  print(requestParams)
	local url = self.apiURL .. method
	
	local postData = ""
	
	for k, v in pairs( requestParams ) do
		postData = postData .. k .. "=" .. v .. "&"
	end
	
  print(postData)
	local params = {}
	params.body = postData

	network.request( url, "POST", networkListener, params )

end

--- Creates a new Player.
-- @param username The username for the player.
-- @param options Optional parameters for the new player. See this page for options - http://wiki.scoreoid.net/api/player/createplayer/
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'success' and 'message'.
function GGScoreoid:createPlayer( username, options, onComplete )
	options = options or {}
	options.username = username
	self:makeRequest( GGScoreoid.Method.CreatePlayer, options, onComplete )
end

--- Deletes an existing Player.
-- @param username The username of the player.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'success' and 'message'.
function GGScoreoid:deletePlayer( username, onComplete )
	options = options or {}
	options.username = username
	self:makeRequest( GGScoreoid.Method.DeletePlayer, options, onComplete )
end

--- Edits an existing Player.
-- @param username The username of the player.
-- @param options Optional parameters for the player. See this page for options - http://wiki.scoreoid.net/api/player/editplayer/
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'success' and 'message'.
function GGScoreoid:editPlayer( username, options, onComplete )
	options = options or {}
	options.username = username
	self:makeRequest( GGScoreoid.Method.EditPlayer, options, onComplete )
end

--- Gets a count of all existing players.
-- @param startDate Optional start date for the count in YYYY-MM-DD format.
-- @param endDate Optional end date for the count in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. One argument are passed; 'count'.
function GGScoreoid:countPlayers( startDate, endDate, platform, onComplete )
	local options = {}
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.CountPlayers, options, onComplete )
end

--- Gets all existing players.
-- @param orderBy Order the players by 'date' or 'score'
-- @param order Sort in 'asc' or 'desc' order.
-- @param limit Limit '20' retrieves rows 1 - 20 and '10,20' retrieves 20 players starting from the 10th row.
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'players'.
function GGScoreoid:getPlayers( orderBy, order, limit, startDate, endDate, platform, onComplete )
	local options = {}
	options.order_by = orderBy
	options.order = order
	options.limit = limit
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.GetPlayers, options, onComplete )
end

--- Gets a field on an existing Player.
-- @param username The username of the player.
-- @param field The name of the field, see this page for possibles - http://wiki.scoreoid.net/api/player/getplayerfield/
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'content' and 'field'.
function GGScoreoid:getPlayerField( username, field, onComplete )
	local options = {}
	options.username = username
	options.field = field
	self:makeRequest( GGScoreoid.Method.GetPlayerField, options, onComplete )
end

--- Updates a field on an existing Player.
-- @param username The username of the player.
-- @param field The name of the field, see this page for possibles - http://wiki.scoreoid.net/api/player/updatePlayerField/
-- @param value The new value of the field.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'success' and 'message'.
function GGScoreoid:updatePlayerField( username, field, value, onComplete )
	local options = {}
	options.username = username
	options.field = field
	options.value = value
	self:makeRequest( GGScoreoid.Method.UpdatePlayerField, options, onComplete )
end

--- Gets scores of an existing Player.
-- @param username The username of the player.
-- @param startDate Optional start date for the count in YYYY-MM-DD format.
-- @param endDate Optional end date for the count in YYYY-MM-DD format.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument are passed; 'scores'. A table of scores with the paramaters as specified here - http://wiki.scoreoid.net/api/player/getplayerscores/
function GGScoreoid:getPlayerScores( username, startDate, endDate, difficulty, onComplete )
	local options = {}
	options.username = username
	options.start_date = startDate
	options.end_date = endDate
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.GetPlayerScores, options, onComplete )
end

--- Create a new score.
-- @param score The value of the score to create.
-- @param username The username of the player.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param uniqueID Optional id for the score.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument are passed; 'scores'. A table of scores with the paramaters as specified here - http://wiki.scoreoid.net/api/player/getplayerscores/
function GGScoreoid:createScore( score, username, platform, uniqueID, difficulty, onComplete )
	local options = {}
	options.score = score
	options.username = username
	options.platform = platform
	options.unique_id = unique_id
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.CreateScore, options, onComplete )
end

--- Gets all existing scores.
-- @param orderBy Order the players by 'date' or 'score'
-- @param order Sort in 'asc' or 'desc' order.
-- @param limit Limit '20' retrieves rows 1 - 20 and '10,20' retrieves 20 scores starting from the 10th row.
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'scores'. A table of scores with the paramaters as specified here - http://wiki.scoreoid.net/api/player/getscores/
function GGScoreoid:getScores( orderBy, order, limit, startDate, endDate, platform, difficulty, onComplete )
	local options = {}
	options.order_by = orderBy
	options.order = order
	options.limit = limit
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.GetScores, options, onComplete )
end

--- Counts all existing scores.
-- @param startDate Optional start date for the count in YYYY-MM-DD format.
-- @param endDate Optional end date for the count in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'scores'.
function GGScoreoid:countScores( startDate, endDate, platform, difficulty, onComplete )
	local options = {}
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.CountScores, options, onComplete )
end

--- Gets the best scores.
-- @param orderBy Order the players by 'date' or 'score'
-- @param order Sort in 'asc' or 'desc' order.
-- @param limit Limit '20' retrieves rows 1 - 20 and '10,20' retrieves 20 scores starting from the 10th row.
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'scores'. A table of scores with the paramaters as specified here - http://wiki.scoreoid.net/api/player/getscores/
function GGScoreoid:getBestScores( orderBy, order, limit, startDate, endDate, platform, difficulty, onComplete )
	local options = {}
	options.order_by = orderBy
	options.order = order
	options.limit = limit
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.GetBestScores, options, onComplete )
end

--- Gets the average score.
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'score'.
function GGScoreoid:getAverageScore( startDate, endDate, platform, difficulty, onComplete )
	local options = {}
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.GetAverageScore, options, onComplete )
end

--- Counts the best scores.
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to count. Matching the value set when creating/editing the player.
-- @param difficulty Optional difficulty level between 1 and 10. Don't use 0.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'score'.
function GGScoreoid:countBestScores( startDate, endDate, platform, difficulty, onComplete )
	local options = {}
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	options.difficulty = difficulty
	self:makeRequest( GGScoreoid.Method.CountBestScores, options, onComplete )
end

--- Gets the game information.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'game'.
function GGScoreoid:getGame( onComplete )
	self:makeRequest( GGScoreoid.Method.GetGame, nil, onComplete )
end

--- Gets the game information.
-- @param field The name of the field to retrieve. See this page for options - http://wiki.scoreoid.net/api/game/getgamefield/
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'content' and 'field'.
function GGScoreoid:getGameField( field, onComplete )
	local options = {}
	options.field = field
	self:makeRequest( GGScoreoid.Method.GetGameField, options, onComplete )
end

--- Gets the average value of a game field.
-- @param field The name of the field to retrieve. See this page for options - http://wiki.scoreoid.net/api/game/getgamefield/
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to check. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'average' and 'field'.
function GGScoreoid:getGameAverage( field, startDate, endDate, platform, onComplete )
	local options = {}
	options.field = field
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.GetGameAverage, options, onComplete )
end

--- Gets the top value of a game field.
-- @param field The name of the field to retrieve. See this page for options - http://wiki.scoreoid.net/api/game/getgametop/
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to check. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'top' and 'field'.
function GGScoreoid:getGameTop( field, startDate, endDate, platform, onComplete )
	local options = {}
	options.field = field
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.GetGameTop, options, onComplete )
end

--- Gets the lowest value of a game field.
-- @param field The name of the field to retrieve. See this page for options - http://wiki.scoreoid.net/api/game/getgamelowest/
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to check. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'lowest' and 'field'.
function GGScoreoid:getGameLowest( field, startDate, endDate, platform, onComplete )
	local options = {}
	options.field = field
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.GetGameLowest, options, onComplete )
end

--- Gets the total value of a game field.
-- @param field The name of the field to retrieve. See this page for options - http://wiki.scoreoid.net/api/game/getgametotal/
-- @param startDate Optional start date for the retrieval in YYYY-MM-DD format.
-- @param endDate Optional end date for the retrieval in YYYY-MM-DD format.
-- @param platform Optional string for the name of the platform to check. Matching the value set when creating/editing the player.
-- @param onComplete Optional function to be called when the request is complete. Two arguments are passed; 'total' and 'field'.
function GGScoreoid:getGameTotal( field, startDate, endDate, platform, onComplete )
	local options = {}
	options.field = field
	options.start_date = startDate
	options.end_date = endDate
	options.platform = platform
	self:makeRequest( GGScoreoid.Method.GetGameTotal, options, onComplete )
end

--- Gets your games notifications.
-- @param onComplete Optional function to be called when the request is complete. One argument is passed; 'notifications'.
function GGScoreoid:getGameNotifications( onComplete )
	self:makeRequest( GGScoreoid.Method.GetNotification, nil, onComplete )
end

--- Destroys this GGScoreoid object.
function GGScoreoid:destroy()
	self.apiURL = nil
  	self.apiKey = nil
  	self.gameID = nil
end

return GGScoreoid
