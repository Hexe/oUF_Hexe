
local function hex(r, g, b)
if r == nil then ChatFrame1:AddMessage("check one nil") end
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	if r == nil then ChatFrame1:AddMessage("check two nil") end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

local function shortVal(value)
	if(value >= 1e6) then
		return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
	elseif(value >= 1e4) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

oUF.Tags['[g.name]'] = function(unit)
	local _, x = UnitClass(unit)
  	local colorString = hex((UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) and oUF.colors.tapped or
		(not UnitIsConnected(unit)) and oUF.colors.disconnected or
		(not UnitIsPlayer(unit)and not(UnitPlayerControlled(unit))) and oUF.colors.reaction[UnitReaction(unit, 'player')] or
		(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) and {1, 0, 0} or
		(UnitPlayerControlled(unit) and not(UnitIsPlayer(unit))) and oUF.colors.class[x] or oUF.colors.class[x])
		
	local uname = UnitName(unit)
  if uname:len() > 16 then
    uname = UnitName(unit):sub(1, 16)..""
  end
	return ('%s%s|r'):format(colorString, uname)
end
  
oUF.Tags['[g.petname]'] = function(unit)
	local colorString = hex(oUF.colors.happiness[(GetPetHappiness() or 3)]) 
	return ('%s%s|r'):format(colorString, UnitName(unit))
end
oUF.TagEvents["[g.petname]"] = "UNIT_HAPPINESS UNIT_PET"

oUF.Tags["[g.misshp]"] = function(unit) 
  local max, min = UnitHealthMax(unit), UnitHealth(unit)
  local v = max-min
  local string = ""
  if UnitIsDeadOrGhost(unit) == 1 then
    string = "RiP"
  elseif UnitIsConnected(unit) == nil then
    string = "D/C"
  elseif v == 0 then
    string = ""
  elseif v > 1e6 then
    string = -(floor((v/1e6)*10)/10).."m"
  elseif v > 1e3 then
    string = -(floor((v/1e3)*10)/10).."k"
  else
    string = -v
  end  
  return string
end
oUF.TagEvents["[g.misshp]"] = "UNIT_HEALTH"
 
oUF.Tags["[g.abshp]"] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	
	local status = not UnitIsConnected(unit) and 'D/C' or UnitIsGhost(unit) and 'BOO' or UnitIsDead(unit) and 'RIP'
	
	local target = unit == 'target' and UnitCanAttack('player', unit) and ('%s  %d|cffA3E496%%|r'):format(min, min / max * 100)
	
	local player = unit == 'player' and min ~= max and ('|cffff8080%d|r %d|cff0090ff%%|r'):format(min - max, min / max * 100)
	
	return status and status or target and target or player and player or min ~= max and ('%s |cff0090ff/|r %s'):format(shortVal(min), shortVal(max)) or max
end
oUF.TagEvents["[g.abshp]"] = "UNIT_HEALTH"
 
oUF.Tags["[g.absmp]"] = function(unit) 
--	if (UnitMana(unit) <= 0) then
  	local v = UnitMana(unit)
  	local string = ""
  	if v > 1e6 then
    	string = (floor((v/1e6)*10)/10).."m"
  	elseif v > 1e3 then
    	string = (floor((v/1e3)*10)/10).."k"
  	else
    	string = v
  	end
 -- else
 -- 	string = ""
 -- end  
  return string
end
oUF.TagEvents["[g.absmp]"] = "UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER"
  
oUF.Tags["[gradientcolor]"] = function(unit)
  r, g, b = oUF.ColorGradient(oUF.Tags["[curhp]"](unit) / oUF.Tags["[maxhp]"](unit), 1, 0, 0, 1, 1, 0, 0, 1, 0)
  return string.format('|cff%02x%02x%02x', r*255, g*255, b*255)
end
oUF.TagEvents["[gradientcolor]"] = "UNIT_HEALTH"
 
oUF.Tags["[g.classtext]"] = function(unit) 
  local string, nstring, tmpstring, sp = "", "", "", " "
  if UnitLevel(unit) ~= -1 then
    string = UnitLevel(unit)
  else
    string = "??"
  end    
  string = string..sp
  local _, x = UnitClass(unit)
  	local colorString = hex((UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) and oUF.colors.tapped or
		(not UnitIsConnected(unit)) and oUF.colors.disconnected or
		(not UnitIsPlayer(unit)and not(UnitPlayerControlled(unit))) and oUF.colors.reaction[UnitReaction(unit, 'player')] or
		(UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit)) and {1, 0, 0} or
		(UnitPlayerControlled(unit) and not(UnitIsPlayer(unit))) and oUF.colors.class[x] or oUF.colors.class[x])
	local uname = UnitName(unit)
  if unit == "target" then
    if uname:len() > 22 then
      uname = uname:sub(1, 22)..""
    end
  else
    if uname:len() > 16 then
      uname = UnitName(unit):sub(1, 16)..""
    end
  end
	nstring = ('%s%s|r'):format(colorString, uname)
  local unit_classification = UnitClassification(unit)    
  if unit_classification == "worldboss" then
    tmpstring = "Boss"
  elseif unit_classification == "rare" or unit_classification == "rareelite" then
    tmpstring = "Rare"
    if unit_classification == "rareelite" then
      tmpstring = tmpstring.." Elite"
    end
  elseif unit_classification == "elite" then
    tmpstring = "Elite"
  end    
  if tmpstring ~= "" then
    tmpstring = sp..sp..tmpstring..sp  
  end    
  string = string..nstring..tmpstring
  tmpstring = ""    
  return string
end
  
oUF.Tags['[phealth]'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	
	local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'
	local target = unit == 'target' and UnitCanAttack('player', unit) and ('%s (%d|cff0090ff%%|r)'):format(shortVal(min), min / max * 100)
	local player = unit == 'player' and min ~= max and ('|cffff8080%d|r %d|cff0090ff%%|r'):format(min - max, min / max * 100)
	
	return status and status or target and target or player and player or min ~= max and ('%s |cff0090ff/|r %s'):format(shortVal(min), shortVal(max)) or max
end

