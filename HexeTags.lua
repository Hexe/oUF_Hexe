local function hex(r, g, b)
if r == nil then ChatFrame1:AddMessage("check one nil") end
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	if r == nil then ChatFrame1:AddMessage("check two nil") end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
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

oUF.Tags["[g.perhp]"] = function(unit)
local m = UnitHealthMax(unit)
	if (UnitAffectingCombat(unit)) then
		return m == 0 and 0 or math.floor(UnitHealth(unit)/m*100+0.5).."%"
	else
		return
	end
end

oUF.TagEvents['[g.perhp]'] = "UNIT_HEALTH"

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
  local v = UnitHealth(unit)
  local string = ""
  if UnitIsDeadOrGhost(unit) == 1 then
    string = "RiP"
  elseif UnitIsConnected(unit) == nil then
    string = "D/C"
  elseif v > 1e6 then
    string = (floor((v/1e6)*10)/10).."m"
  elseif v > 1e3 then
    string = (floor((v/1e3)*10)/10).."k"
  else
    string = v
  end  
  return string
end
oUF.TagEvents["[g.abshp]"] = "UNIT_HEALTH"
 
oUF.Tags["[g.absmp]"] = function(unit) 
  local v = UnitMana(unit)
  local string = ""
  if v > 1e6 then
    string = (floor((v/1e6)*10)/10).."m"
  elseif v > 1e3 then
    string = (floor((v/1e3)*10)/10).."k"
  else
    string = v
  end  
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
  
