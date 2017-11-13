--[[
 $Id$

 Copyright © 2015 VideoLAN and AUTHORS

 Authors: Diego Fernando Nieto <diegofn at me dot com>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
--]]

function descriptor()
    return { title="ColombiaTV" }
end

lazy_loaded = false
json = nil

function lazy_load()
    if lazy_loaded then return nil end
    json = require "dkjson"
    json["parse_url"] = function(url)
        local string = ""
        local line = ""
        local stream = vlc.stream(url)

 				line = stream:readline()
 				while line ~= nil do
					string = string..line
					line = stream:readline()
				end 

        return json.decode(string, 1)
    end
    lazy_loaded = true
end

--
-- Main Function
--
function main()

	lazy_load()
	--
	-- Create a new TuneinRadio object
	--
	colombiaTV = NewColombiaTV ()

	--
	-- Add the main categories to browse ColombiaTV
	--
	colombiaTV.add_channels_list( )
end

--
-- Class ColombiaTV
--
function NewColombiaTV ()
	--
	-- ColombiaTV private parameters
	--
	local self = {  __listURLprefix__ = "https://gist.githubusercontent.com",
									__listURLsuffix__ = "/diegofn/b00362278b1ca171b27eb40bd7c2d5e4/raw/fe4702a051b468f332f02aabb0fdfafc8d037295/",
									__listURLfile__		= "channels.json"
	}
    
	--
	-- Add the channel list to VLC playlist
	--
	local add_channels_list = function ()

		--
		-- Get channel list using json
		--
		local url = self.__listURLprefix__ .. self.__listURLsuffix__ .. self.__listURLfile__
		local result = json.parse_url(url)
		local channel_list = nil

		if result then
			for i = 1, #result.ColombiaTV do
				item = result.ColombiaTV[i]

				-- 
				-- Add the channel to VLC playlist
				--
				vlc.sd.add_item( {path = item["url"],
													title = item["title"],
													arturl =	item["image"]
											})
			end
		end
	end

	return {
		add_channels_list = add_channels_list
	}
end


