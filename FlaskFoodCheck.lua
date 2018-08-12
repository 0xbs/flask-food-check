-------------------------------------------------------------------------------
-- FlaskFoodCheck
-- Checks if all raid members have flask, food and rune buff.
-------------------------------------------------------------------------------
-- Copyright (C) 2015 Elotheon-Arthas-EU
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

FlaskFoodCheck = select(2, ...)

local FFC = FlaskFoodCheck
local L = FFC.L


-- we use the name of this spell to get the correct locale of the "Well Fed" buff
local FFC_WELLFED_SPELL_REF = 160726
-- we use the name of this spell to get the correct locale of the "Food" (=eating) buff
local FFC_EATING_SPELL_REF = 433


local FFC_FOOD_TABLE = {
	-- WARLORDS OF DRAENOR
	[177931] = 75, -- 75 versatility (Pre-Mixed Pot of Noodles)

	-- herb garden tree fruits
	[174062] = 75, -- 75 critical strike (Perfect Nagrand Cherry)
	[174079] = 75, -- 75 haste (Perfect O'ruk Orange)
	[174077] = 75, -- 75 mastery (Perfect Fuzzy Pear)
	[174080] = 75, -- 75 multistrike (Perfect Greenskin Apple)
	[174078] = 75, -- 75 versatility (Perfect Ironpeel Plantain)

	-- cooking 75-stat and herb garden tree fruits
	[160600] = 75, -- 112 stamina (Hearty Elekk Steak, Steamed Scorpion)
	[160724] = 75, -- 75 critical strike (Blackrock Ham, Grilled Gulper, Nagrand Cherry)
	[160726] = 75, -- 75 haste (Pan-Seared Talbuk, Sturgeon Stew, O'ruk Orange)
	[160793] = 75, -- 75 mastery (Braised Riverbeast, Fat Sleeper Cakes, Fuzzy Pear)
	[160832] = 75, -- 75 multistrike (Rylak Crepes, Fiery Calamari, Greenskin Apple)
	[160839] = 75, -- 75 versatility (Clefthoof Sausages, Skulker Chowder, Ironpeel Plantain)

	-- cooking 100-stat
	[160883] = 100, -- 100 stamina
	[160889] = 100, -- 100 critical strike
	[160893] = 100, -- 100 haste
	[160897] = 100, -- 100 mastery
	[160900] = 100, -- 100 multistrike
	[160902] = 100, -- 100 versatility

	-- unknown
	[175218] = 100, -- 100 critical strike
	[175219] = 100, -- 100 haste
	[175220] = 100, -- 100 mastery
	[175222] = 100, -- 100 multistrike
	[175223] = 100, -- 100 versatility

	-- cooking 125-stat, feast 75-stat, feast 100-stat (check value2)
	[180747] = 125, -- 187 stamina
	[180745] = 125, -- 125 critical strike
	[180748] = 125, -- 125 haste
	[180750] = 125, -- 125 mastery
	[180749] = 125, -- 125 multistrike
	[180746] = 125, -- 125 versatility

	[188534] = 125, -- felmouth frenzy

	-- LEGION
	[201223] = 225, -- 225 critical strike
	[201330] = 225, -- 225 haste
	[201332] = 225, -- 225 mastery
	[201334] = 225, -- 225 versatility
	[201336] = 225, -- fire volley proc (10194 damage)

	[201350] = 1,   -- gain sprint after killing an enemy
	[201695] = 1,   -- increased out-of-combat health regeneration

	[225597] = 300, -- 300 critical strike
	[225598] = 300, -- 300 haste
	[225599] = 300, -- 300 mastery
	[225600] = 300, -- 300 versatility
	[225601] = 300, -- fire volley proc (13592 damage)

	[225602] = 375, -- 375 critical strike
	[225603] = 375, -- 375 haste
	[225604] = 375, -- 375 mastery
	[225605] = 375, -- 375 versatility
	[225606] = 375, -- fire volley proc (16990 damage)
}

local FFC_FLASK_TABLE = {
	-- WARLORDS OF DRAENOR
	[176151] = 100, -- 100 stamina, intellect, agility and strength (crystal)

	[156077] = 200, -- 250 stamina
	[156070] = 200, -- 200 intellect
	[156073] = 200, -- 200 agility
	[156071] = 200, -- 200 strength

	[156084] = 250, -- 375 stamina
	[156079] = 250, -- 250 intellect
	[156064] = 250, -- 250 agility
	[156080] = 250, -- 250 strength

	-- LEGION
	[188035] = 1300, -- 1950 stamina
	[188031] = 1300, -- 1300 intellect
	[188033] = 1300, -- 1300 agility
	[188034] = 1300, -- 1300 strength

	[188116] = 1300, -- flask from cauldron
}

local FFC_RUNE_TABLE = {
	-- WARLORDS OF DRAENOR
	[175457] = 50, -- 50 intellect
	[175456] = 50, -- 50 agility
	[175439] = 50, -- 50 strength

	-- LEGION
	[224001] = 325, -- 325 intellect, agility and strength (Defiled Augment Rune)
}

local FFC_EATING_TABLE = {
	[433] = 1, -- food
	[430] = 1, -- drink
	[160598] = 1, -- food
	[160599] = 1, -- drink
	[192002] = 1, -- food & drink
	[225743] = 1, -- food & drink
}



-------------------------------------------------------------------------------
-- Addon Functionality
-------------------------------------------------------------------------------

function FFC:OnInitialize()
	local defaults = {
		debug = false,
		muted = false,
		playerLevelMin = 100,
		foodStatsMin = 100,
		flaskStatsMin = 250,
		runeStatsMin = 50,
		expiresWarnSec = 480,
		requireRightsForAutoRun = 1,
		checkFood = true,
		checkFlask = true,
		checkRune = false,
	}

	FlaskFoodCheckDB = FlaskFoodCheckDB or {}

	for key, value in pairs(defaults) do
		if( FlaskFoodCheckDB[key] == nil ) then
			FlaskFoodCheckDB[key] = value
		end
	end

	self.db = FlaskFoodCheckDB
end


function FFC:debug(msg)
	if self.db.debug then
		print(string.format("|cffff0088[FFC][%s.%3d]|r %s", 
			date("%H:%M:%S"), (GetTime() % 1) * 1000, msg))
	end
end


function FFC:PlayerName(name)
	if string.find(name, "-") then
		return name, GetRealmName()
	else
		local _, _, fname, frealm = string.find(name, "([^-]+)-([^-]+)")
		return fname, frealm
	end
end


function FFC:GetPlayerBuffValueAndRemaining(player, spellTable, fallbackSpellId)
	for spellid, amount in pairs(spellTable) do
		local name, _, _, _, _, _, expires, _, _, _, _, _, _, 
			value1, value2, value3 = UnitBuff(player, GetSpellInfo(spellid))
		if name then
			if value2 and value2 > 0 then amount = value2 end
			local remaining = 0
			if expires > 0 then remaining = math.ceil(expires - GetTime()) end
			return amount, remaining
		end
	end
	if fallbackSpellId then
		-- fallback: try to find a buff called "Well Fed"/"Food"/etc in the 
		-- current locale and read its special value2
		local name, _, _, _, _, _, expires, _, _, _, _, _, _, 
			value1, value2, value3 = UnitBuff(player, GetSpellInfo(fallbackSpellId))
		if name then
			local remaining = 0
			if expires > 0 then remaining = math.ceil(expires - GetTime()) end
			if value2 and value2 > 0 then
				return value2, remaining
			else
				-- return 1 if we found such a buff but cannot read its value2
				return 1, remaining
			end
		end
	end
	return 0, 0
end


function FFC:GetPlayerFood(player)
	return self:GetPlayerBuffValueAndRemaining(player, 
		FFC_FOOD_TABLE, FFC_WELLFED_SPELL_REF)
end


function FFC:GetPlayerFlask(player)
	return self:GetPlayerBuffValueAndRemaining(player, FFC_FLASK_TABLE)
end


function FFC:GetPlayerRune(player)
	return self:GetPlayerBuffValueAndRemaining(player, FFC_RUNE_TABLE)
end


function FFC:GetPlayerEating(player)
	local amount, remaining = self:GetPlayerBuffValueAndRemaining(player, 
		FFC_EATING_TABLE, FFC_EATING_SPELL_REF)
	return (amount > 0)
end


function FFC:IsInSameZone(zone)
	local zonereal = GetRealZoneText()
	local zonetext = GetZoneText()
	local zoneinst = GetInstanceInfo()
	local zonemap = GetMapNameByID(GetCurrentMapAreaID())
	if zone and ((zonereal and zonereal == zone) or (zonetext and zonetext == zone) or 
		(zoneinst and zoneinst == zone) or (zonemap and zonemap == zone)) then
		return true
	end
	return false
end


function FFC:AggregateSelfInfo()
	local raid = {}
	if UnitLevel("player") >= self.db.playerLevelMin and not UnitIsDeadOrGhost("player") then
		local name = UnitName("player");
		raid[name] = {}
		raid[name]["food"]   = { self:GetPlayerFood(name) }
		raid[name]["flask"]  = { self:GetPlayerFlask(name) }
		raid[name]["rune"]   = { self:GetPlayerRune(name) }
		raid[name]["eating"] = self:GetPlayerEating(name)
	end
	return raid
end


function FFC:AggregatePartyInfo()
	local raid = {}
	for i = 1, GetNumGroupMembers() do
		local unit = ""
		if i == GetNumGroupMembers() then unit = "player" else unit = "party"..i end
		if UnitLevel(unit) >= self.db.playerLevelMin and not UnitIsDeadOrGhost(unit) then
			local name = UnitName(unit);
			if name then
				-- local simplename = self:PlayerName(name)
				raid[name] = {}
				raid[name]["food"]   = { self:GetPlayerFood(name) }
				raid[name]["flask"]  = { self:GetPlayerFlask(name) }
				raid[name]["rune"]   = { self:GetPlayerRune(name) }
				raid[name]["eating"] = self:GetPlayerEating(name)
			end
		end
	end
	return raid
end


function FFC:AggregateRaidInfo()
	local raid = {}
	-- loop through raid members and aggregate information
	for i = 1, GetNumGroupMembers() do
		local name, rank, subgroup, level, class, _, zone, 
			online, isdead, role, isml = GetRaidRosterInfo(i)
		if name and level and level >= self.db.playerLevelMin and online and not isdead then
			--  and self:IsInSameZone(zone)
			-- local simplename = self:PlayerName(name)
			raid[name] = {}
			raid[name]["food"]   = { self:GetPlayerFood(name) }
			raid[name]["flask"]  = { self:GetPlayerFlask(name) }
			raid[name]["rune"]   = { self:GetPlayerRune(name) }
			raid[name]["eating"] = self:GetPlayerEating(name)
		end
	end
	return raid
end


function FFC:AnalyseInformation(infoTable, outputChannel)
	local foodMissingCount = 0
	local foodLowStatCount = 0
	local foodExpiresCount = 0

	local flaskMissingCount = 0
	local flaskLowStatCount = 0
	local flaskExpiresCount = 0

	local runeMissingCount = 0
	local runeLowStatCount = 0
	local runeExpiresCount = 0

	local foodMissing = {}
	local foodLowStat = {}
	local foodExpires = {}

	local flaskMissing = {}
	local flaskLowStat = {}
	local flaskExpires = {}

	local runeMissing = {}
	local runeLowStat = {}
	local runeExpires = {}

	for name, info in pairs(infoTable) do
		if info["food"][1] == 0 then
			foodMissingCount = foodMissingCount + 1
			if info["eating"] then
				table.insert(foodMissing, name..L[" (eating)"])
			else
				table.insert(foodMissing, name)
			end
		else
			if info["food"][1] < self.db.foodStatsMin then
				foodLowStatCount = foodLowStatCount + 1
				if info["eating"] then
					table.insert(foodLowStat, name..L[" (eating)"])
				else
					table.insert(foodLowStat, name .. " (" .. info["food"][1] .. ")")
				end
			else
				if info["food"][2] > 0 and info["food"][2] < self.db.expiresWarnSec then
					foodExpiresCount = foodExpiresCount + 1
					if info["eating"] then
						table.insert(foodExpires, name..L[" (eating)"])
					else
						table.insert(foodExpires, name .. " (" .. 
							string.format(L["%d min"], info["food"][2] / 60) .. ")")
					end
				end
			end
		end

		if info["flask"][1] == 0 then
			flaskMissingCount = flaskMissingCount + 1
			table.insert(flaskMissing, name)
		else
			if info["flask"][1] < self.db.flaskStatsMin then
				flaskLowStatCount = flaskLowStatCount + 1
				table.insert(flaskLowStat, name .. " (" .. info["flask"][1] .. ")")
			else
				if info["flask"][2] > 0 and info["flask"][2] < self.db.expiresWarnSec then
					flaskExpiresCount = flaskExpiresCount + 1
					table.insert(flaskExpires, name .. " (" .. 
						string.format(L["%d min"], math.ceil(info["flask"][2] / 60)) .. ")")
				end
			end
		end

		if info["rune"][1] == 0 then
			runeMissingCount = runeMissingCount + 1
			table.insert(runeMissing, name)
		else
			if info["rune"][1] < self.db.runeStatsMin then
				runeLowStatCount = runeLowStatCount + 1
				table.insert(runeLowStat, name .. " (" .. info["rune"][1] .. ")")
			else
				if info["rune"][2] > 0 and info["rune"][2] < self.db.expiresWarnSec then
					runeExpiresCount = runeExpiresCount + 1
					table.insert(runeExpires, name .. " (" .. 
						string.format(L["%d min"], math.ceil(info["rune"][2] / 60)) .. ")")
				end
			end
		end

	end

	if self.db.checkFood then
		if flaskMissingCount > 0 then self:PrintToChannel(L["Flask missing: "] .. 
			table.concat(flaskMissing, ", "), outputChannel) end
		if flaskLowStatCount > 0 then self:PrintToChannel(L["Flask with low stats: "] .. 
			table.concat(flaskLowStat, ", "), outputChannel) end
		if flaskExpiresCount > 0 then self:PrintToChannel(L["Flask expires: "] .. 
			table.concat(flaskExpires, ", "), outputChannel) end
	end

	if self.db.checkFlask then
		if foodMissingCount > 0 then self:PrintToChannel(L["Food missing: "] .. 
			table.concat(foodMissing, ", "), outputChannel) end
		if foodLowStatCount > 0 then self:PrintToChannel(L["Food with low stats: "] ..
			table.concat(foodLowStat, ", "), outputChannel) end
		if foodExpiresCount > 0 then self:PrintToChannel(L["Food expires: "] .. 
			table.concat(foodExpires, ", "), outputChannel) end
	end

	if self.db.checkRune then
		if runeMissingCount > 0 then self:PrintToChannel(L["Rune missing: "] .. 
			table.concat(runeMissing, ", "), outputChannel) end
		if runeLowStatCount > 0 then self:PrintToChannel(L["Rune with low stats: "] ..
			table.concat(runeLowStat, ", "), outputChannel) end
		if runeExpiresCount > 0 then self:PrintToChannel(L["Rune expires: "] .. 
			table.concat(runeExpires, ", "), outputChannel) end
	end

	if self.db.checkFood and self.db.checkFlask and self.db.checkRune and 
		foodMissingCount == 0 and foodLowStatCount == 0 and foodExpiresCount == 0 and 
		flaskMissingCount == 0 and flaskLowStatCount == 0 and flaskExpiresCount == 0 and 
		runeMissingCount == 0 and runeLowStatCount == 0 and runeExpiresCount == 0 then
		-- wow, everyone got everything
		self:PrintToChannel(L["Hooray, everyone has food, flask and rune buff! #incredibleraid"], outputChannel)
	elseif self.db.checkFood and self.db.checkFlask and not self.db.checkRune and 
		foodMissingCount == 0 and foodLowStatCount == 0 and foodExpiresCount == 0 and 
		flaskMissingCount == 0 and flaskLowStatCount == 0 and flaskExpiresCount == 0 then
		-- yay, everyone got flask and food
		self:PrintToChannel(L["Everyone has flask and food buff! #bestraid"], outputChannel)
	else
		-- something somewhere missing
		if self.db.checkFood and foodMissingCount == 0 and foodLowStatCount == 0 and foodExpiresCount == 0 then
			self:PrintToChannel(L["Everyone has food buff."], outputChannel)
		end
		if self.db.checkFlask and flaskMissingCount == 0 and flaskLowStatCount == 0 and flaskExpiresCount == 0 then
			self:PrintToChannel(L["Everyone has flask buff."], outputChannel)
		end
		if self.db.checkRune and runeMissingCount == 0 and runeLowStatCount == 0 and runeExpiresCount == 0 then
			self:PrintToChannel(L["Everyone has rune buff."], outputChannel)
		end
	end

end


function FFC:RunCheck(isReadyCheck)
	if isReadyCheck then
		-- called because of a ready check
		if IsInRaid() and self:IsRealRaid() then
			-- always display information in a raid, but only to raid channel if sufficient rights
			if self:HasRaidRights() then
				self:AnalyseInformation(self:AggregateRaidInfo(), "raid")
			else
				self:AnalyseInformation(self:AggregateRaidInfo(), "self")
			end
		elseif IsInInstance() and self:IsRealChallengeMode() then
			-- always display information in a challenge mode
			self:AnalyseInformation(self:AggregatePartyInfo(), "instance")
		end
	else
		-- called manually, always print
		if IsInRaid() then
			self:debug("raid analysis")
			self:AnalyseInformation(self:AggregateRaidInfo(), "raid")
		elseif IsInInstance() then
			self:debug("party analysis")
			self:AnalyseInformation(self:AggregatePartyInfo(), "instance")
		elseif IsInGroup() then
			self:debug("party analysis")
			self:AnalyseInformation(self:AggregatePartyInfo(), "group")
		else
			self:debug("self analysis")
			self:AnalyseInformation(self:AggregateSelfInfo(), "self")
		end
	end
end


function FFC:HasRaidRights()
	if  (self.db.requireRightsForAutoRun == 2 and UnitIsGroupLeader("player")) or
		(self.db.requireRightsForAutoRun == 1 and (UnitIsGroupLeader("player") or UnitIsRaidOfficer("player"))) or
		(self.db.requireRightsForAutoRun == 0) then
		return true
	end
	return false
end


function FFC:IsRealRaid()
	-- see http://wow.gamepedia.com/API_GetDifficultyInfo
	local difficulty = GetRaidDifficultyID()
	if difficulty == 14 or difficulty == 15 or difficulty == 16 then
		return true
	end
	return false
end


function FFC:IsRealChallengeMode()
	return (GetRaidDifficultyID() == 8)
end


function FFC:PrintToChannel(msg, channel)
	-- never print anything to a channel when muted
	if self.db.muted then
		channel = "self"
	end

	-- if channel not specified, find the right channel
	if not channel then
		if IsInRaid() then
			channel = "raid"
		elseif IsInInstance() then
			channel = "instance"
		elseif IsInGroup() then
			channel = "party"
		else
			channel = "self"
		end
	end

	-- print to correct channel
	if channel == "self" then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	elseif channel == "raid" then
		SendChatMessage(msg, "RAID")
	elseif channel == "instance" then
		SendChatMessage(msg, "INSTANCE_CHAT")
	elseif channel == "group" then
		SendChatMessage(msg, "PARTY")
	else
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end


function FFC:PrintCurrentRequirements()
	if self.db.requireRightsForAutoRun == 0 then
		self:Print(L["No special raid rights are now required for printing to raid channel."])
	elseif self.db.requireRightsForAutoRun == 1 then
		self:Print(L["Currently being assistant is required for printing to raid channel."])
	elseif self.db.requireRightsForAutoRun == 2 then
		self:Print(L["Currently being raidlead is required for printing to raid channel."])
	else
		self:Print(L["Unknown value."])
	end
end


function FFC:PrintCurrentRequirementsShort()
	if self.db.requireRightsForAutoRun == 0 then
		self:Print("require any")
	elseif self.db.requireRightsForAutoRun == 1 then
		self:Print("require assist")
	elseif self.db.requireRightsForAutoRun == 2 then
		self:Print("require raidlead")
	end
end


function FFC:PrintCurrentToggles()
	local msg = L["Currently checking for:"]
	if self.db.checkFood then msg = msg .. " " .. L["food"] end
	if self.db.checkFlask then msg = msg .. " " .. L["flask"] end
	if self.db.checkRune then msg = msg .. " " .. L["rune"] end
	self:Print(msg)
end


function FFC:PrintCurrentTogglesShort()
	local msg = "check"
	if self.db.checkFood then msg = msg .. " food" end
	if self.db.checkFlask then msg = msg .. " flask" end
	if self.db.checkRune then msg = msg .. " rune" end
	self:Print(msg)
end



function FFC:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff006ee8FlaskFoodCheck:|r " .. msg)
end



-------------------------------------------------------------------------------
-- Slash Command Handling
-------------------------------------------------------------------------------

SLASH_FFC1 = "/ffc"
SLASH_FFC2 = "/flaskfoodcheck"
SlashCmdList["FFC"] = function(msg)
	msg = msg or ""
	local cmd, arg = string.split(" ", msg, 2)
	cmd = string.lower(cmd or "")
	arg = string.lower(arg or "")

	local self = FFC

	self:debug("cmd is '"..cmd.."'")
	self:debug("arg is '"..arg.."'")

	if cmd == "run" then
		self:RunCheck(false)
	elseif cmd == "mute" then
		self.db.muted = true
		self:Print(L["Muted."])
	elseif cmd == "unmute" then
		self.db.muted = false
		self:Print(L["Unmuted."])
	
	elseif cmd == "minlevel" and arg == "" then
		self:Print(string.format(L["Minimum player level is currently set to %d."], self.db.playerLevelMin))
	elseif cmd == "minlevel" and arg ~= "" then
		self.db.playerLevelMin = tonumber(string.match(arg, "%d+"))
		self:Print(string.format(L["Minimum player level set to %d."], self.db.playerLevelMin))
	
	elseif cmd == "minfood" and arg == "" then
		self:Print(string.format(L["Minimum stats on food is currently set to %d."], self.db.foodStatsMin))
	elseif cmd == "minfood" and arg ~= "" then
		self.db.foodStatsMin = tonumber(string.match(arg, "%d+"))
		self:Print(string.format(L["Minimum stats on food set to %d."], self.db.foodStatsMin))
	
	elseif cmd == "minflask" and arg == "" then
		self:Print(string.format(L["Minimum stats on flask is currently set to %d."], self.db.flaskStatsMin))
	elseif cmd == "minflask" and arg ~= "" then
		self.db.flaskStatsMin = tonumber(string.match(arg, "%d+"))
		self:Print(string.format(L["Minimum stats on flask set to %d."], self.db.flaskStatsMin))
	
	elseif cmd == "minrune" and arg == "" then
		self:Print(string.format(L["Minimum stats on rune is currently set to %d."], self.db.runeStatsMin))
	elseif cmd == "minrune" and arg ~= "" then
		self.db.runeStatsMin = tonumber(string.match(arg, "%d+"))
		self:Print(string.format(L["Minimum stats on rune set to %d."], self.db.runeStatsMin))
	
	elseif cmd == "expire" and arg == "" then
		self:Print(string.format(L["Expiration warning is currently set to %d seconds (approx. %d min)."], self.db.expiresWarnSec, math.ceil(self.db.expiresWarnSec / 60)))
	elseif cmd == "expire" and arg ~= "" then
		self.db.expiresWarnSec = tonumber(string.match(arg, "%d+"))
		self:Print(string.format(L["Expiration warning set to %d seconds (approx. %d min)."], self.db.expiresWarnSec, math.ceil(self.db.expiresWarnSec / 60)))
	
	elseif cmd == "require" and arg == "" then
		self:PrintCurrentRequirements()
	elseif cmd == "require" and arg ~= "" then
		if arg == "any" then
			self.db.requireRightsForAutoRun = 0
			self:Print(L["No special raid rights are now required for printing to raid channel."])
		elseif arg == "assist" then
			self.db.requireRightsForAutoRun = 1
			self:Print(L["Being assistant is now required for printing to raid channel."])
		elseif arg == "raidlead" then
			self.db.requireRightsForAutoRun = 2
			self:Print(L["Being raidlead is now required for printing to raid channel."])
		else
			self:Print(L["Unknown command."])
		end
	
	elseif cmd == "check" and arg == "" then
		self:PrintCurrentToggles()
	elseif cmd == "check" and arg ~= "" then
		if arg == "food" then
			self.db.checkFood = not self.db.checkFood
		elseif arg == "flask" then
			self.db.checkFlask = not self.db.checkFlask
		elseif  arg == "rune" then
			self.db.checkRune = not self.db.checkRune
		else
			self:Print(L["Unknown command."])
		end
		self:PrintCurrentToggles()

	elseif cmd == "values" then
		if self.db.muted then self:Print(L["Muted."]) end
		self:Print(string.format(L["Minimum player level is currently set to %d."], self.db.playerLevelMin))
		self:Print(string.format(L["Minimum stats on food is currently set to %d."], self.db.foodStatsMin))
		self:Print(string.format(L["Minimum stats on flask is currently set to %d."], self.db.flaskStatsMin))
		self:Print(string.format(L["Minimum stats on rune is currently set to %d."], self.db.runeStatsMin))
		self:Print(string.format(L["Expiration warning is currently set to %d seconds (approx. %d min)."], self.db.expiresWarnSec, math.ceil(self.db.expiresWarnSec / 60)))
		self:PrintCurrentRequirements()
		self:PrintCurrentToggles()
	
	elseif cmd == "val" then
		if self.db.muted then self:Print("muted") end
		self:Print(string.format("minplayer %d", self.db.playerLevelMin))
		self:Print(string.format("minfood %d", self.db.foodStatsMin))
		self:Print(string.format("minflask %d", self.db.flaskStatsMin))
		self:Print(string.format("minrune %d", self.db.runeStatsMin))
		self:Print(string.format("expire %d sec (~%d min)", self.db.expiresWarnSec, math.ceil(self.db.expiresWarnSec / 60)))
		self:PrintCurrentRequirementsShort()
		self:PrintCurrentTogglesShort()

	elseif cmd == "debug" then
		self.db.debug = not self.db.debug
		if self.db.debug then
			self:Print("Debugging enabled.")
		else
			self:Print("Debugging disabled.")
		end

	else
		self:Print(L["Slash commands"])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc run - Manually trigger a flask and food buff check."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc mute - Mute the addon (do not write to raid channel, but display locally)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc unmute - Unmute if previously muted."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc require any - Print messages on every ready check in a raid, regardless of rights."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc require assist - Print messages on every read check in a raid if you have at least assistant rights (default)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc require raidlead - Print messages on every read check in a raid if you are the raid leader."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc check food - Enable or disable food check (default on)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc check flask - Enable or disable flask check (default on)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc check rune - Enable or disable rune check (default off)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc minlevel <level> - Minimum player level in order to appear in the output (default 100)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc minfood <amount> - Mininum stats required on food buff (default 100)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc minflask <amount> - Mininum stats required on flask buff (default 250)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc minrune <amount> - Mininum stats required on rune buff (default 50)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc expire <seconds> - Seconds before a buff is marked as expiring (default 480 = 8 min)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc values - List all values currently set (minfood, minflask, etc.)."])
		DEFAULT_CHAT_FRAME:AddMessage(L["/ffc val - Same as above, but shorter."])
	end
end



-------------------------------------------------------------------------------
-- Event Handling
-------------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("READY_CHECK")
frame:SetScript("OnEvent", 
	function(self, event, ...)
		if event == "ADDON_LOADED" then
			FFC:OnInitialize()
			self:UnregisterEvent("ADDON_LOADED")
		elseif event == "READY_CHECK" then
			FFC:RunCheck(true)
		end
	end
)
