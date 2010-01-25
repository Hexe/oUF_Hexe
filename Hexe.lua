
local font = "Interface\\AddOns\\oUF_Hexe\\media\\BaarSophia.ttf"  
  
local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, bottom = -1, left = -1, right = -1},
}  

local player_class_color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

local statusbar = "Interface\\AddOns\\oUF_Gaali\\media\\minimalist"

local frame_positions = {
	[1] =   { a1 = "RIGHT",    a2 = "CENTER",      af = "UIParent",               x = -15,   y = -150 }, --player 
  [2] =   { a1 = "LEFT",     a2 = "CENTER",      af = "UIParent",               x = 15,    y = -150 }, --useplayer target frame
  [3] =   { a1 = "TOP",      a2 = "BOTTOMRIGHT", af = "Hexe_Target",   x = 0,    y = -3   }, --useplayer tot
  [4] =   { a1 = "TOP",      a2 = "BOTTOMLEFT",  af = "Hexe_Player",   x = 0,    y = -3   }, --useplayer pet
  [5] =   { a1 = "CENTER",   a2 = "CENTER",      af = "UIParent",               x = 0,    y = -80  }, --useplayer focus
  [6] =   { a1 = "CENTER",   a2 = "CENTER",      af = "UIParent",               x = 0,    y = -150 }, --target frame
  [7] =   { a1 = "TOPRIGHT", a2 = "BOTTOMRIGHT", af = "Hexe_Target",   x = 0,    y = -4   }, --tot
  [8] =   { a1 = "BOTTOM",   a2 = "BOTTOM",      af = "UIParent",               x = -265, y = 25   }, --pet
  [9] =   { a1 = "TOPLEFT",  a2 = "BOTTOMLEFT",  af = "Hexe_Target",   x = 0,    y = -4   }, --focus
  [10] =  { a1 = "CENTER",   a2 = "CENTER",      af = "Hexe_Target",   x = 0,    y = 100  }, --castbar target
  [11] =  { a1 = "CENTER",   a2 = "CENTER",      af = "Hexe_Target",   x = 0,    y = -80  }, --castbar player
}
  
--menu  
local menu = function(self)
local unit = self.unit:sub(1, -2)
local cunit = self.unit:gsub("(.)", string.upper, 1)

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

--setup frame width, height, strata
local function setupFrame(self,w,h,strata)
  self.menu = menu
  self:RegisterForClicks("AnyUp")
  self:SetAttribute("*type2", "menu")
  self:SetScript("OnEnter", UnitFrame_OnEnter)
  self:SetScript("OnLeave", UnitFrame_OnLeave)
  self:SetFrameStrata(strata)
  self:SetWidth(w)
  self:SetHeight(h)
  self:SetBackdrop(backdrop)
  self:SetBackdropColor(0, 0, 0)
end
 
--set fontstring
local function SetFontString(parent, fontName, fontHeight, fontStyle)
  local fs = parent:CreateFontString(nil, "OVERLAY")
  fs:SetFont(fontName, fontHeight, fontStyle)
  fs:SetShadowOffset(1,1)
  fs:SetShadowColor(0,0,0,1)
  return fs
end

local function createHPFrames(self,unit)
	local Border = CreateFrame("Frame", nil, self)
	Border:SetBackdrop({edgeFile = "Interface\\AddOns\\oUF_Gaali\\media\\border.tga", edgeSize = 14, insets = {left = -2, right = -2, top = -2, bottom = -2}})
	Border:SetPoint("TOPLEFT", -4, 4)
	Border:SetPoint("BOTTOMRIGHT", 4, -4)
	Border:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	Border:SetFrameLevel(1)

	self.Health = CreateFrame("StatusBar", nil, self)
  self.Health:SetStatusBarTexture(statusbar)
  self.Health:SetPoint("TOPRIGHT")
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetStatusBarColor(0.45,0.45,0.45,1)
	
	if (unit == 'pet') or (unit == 'targettarget') or (unit == 'focus') then
		self.Health:SetHeight(8)
	else 
		self.Health:SetHeight(10)
	end
	
	self.Health.frequentUpdates = true
  self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
  self.Health.bg:SetTexture(statusbar)
  self.Health.bg:SetTexture(0.15, 0.15, 0.15, 1)
  self.Health.bg:SetAllPoints(self.Health)   
  self.Health.bg:SetVertexColor(0.15,0.15,0.15,1) 
  self.Health.Smooth = true
  
  self.Power = CreateFrame("StatusBar", nil, self)
  self.Power:SetStatusBarTexture(statusbar)
  self.Power:SetPoint('BOTTOMRIGHT')
	self.Power:SetPoint('BOTTOMLEFT')
	self.Power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
  self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
  self.Power.bg:SetTexture(statusbar)
  self.Power.bg:SetAllPoints(self.Power)
  self.Power.colorClass = true
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorReaction = unit ~= 'pet'
	self.Power.colorHappiness = unit == 'pet'
	self.Power.colorPower = unit == 'pet'
  self.Power.Smooth = true
  self.Power.frequentUpdates = true
end

--credit p3lim (fix for vehicle combo points)
local function updateCPoints(self, event, unit)
	if(unit == PlayerFrame.unit) and (unit ~= self.CPoints.unit) then
		self.CPoints.unit = unit
	end
end

local function createPlayer(self,unit)
	setupFrame(self,150,12,"BACKGROUND")
	createHPFrames(self,unit)
	local hp = SetFontString(self.Health,font,9)
	hp:SetPoint("RIGHT",self.Health,-1,0)
	self:Tag(hp,"[gradientcolor][g.abshp]")
	local pp = SetFontString(self.Health,font,9)
	pp:SetPoint("LEFT",self.Health,1,0)
	self:Tag(pp,"[g.absmp]")
end

local function createTarget(self,unit)
	setupFrame(self,150,12,"BACKGROUND")
	createHPFrames(self,unit)
	local info = SetFontString(self.Health,font,10)
	info:SetPoint("BOTTOMLEFT",self.Health,"TOPLEFT",1,0)
	self:Tag(info,"[g.classtext]")
	local hp = SetFontString(self.Health,font,9)
	hp:SetPoint("RIGHT",self.Health,-1,0)
	self:Tag(hp,"[gradientcolor][g.abshp]")
	local hppc = SetFontString(self.Health,font,12)
	hppc:SetPoint("LEFT",self,"RIGHT",5,0)
	self:Tag(hppc,"[gradientcolor][g.perhp]")
	local pp = SetFontString(self.Health,font,9)
	pp:SetPoint("LEFT",self.Health,1,0)
	self:Tag(pp,"[g.absmp]")
end

local function createToTandPet(self,unit)
	setupFrame(self,90,8,"BACKGROUND")
	createHPFrames(self,unit)
	local info = SetFontString(self.Health,font,10)
	info:SetPoint("LEFT",self.Health,1,0)
	self:Tag(info,"[g.name]")
end

local function createFocus(self,unit)
	setupFrame(self,24,12,"BACKGROUND")
	createHPFrames(self,unit)
end

oUF:RegisterStyle('Hexe_player', createPlayer)
oUF:RegisterStyle('Hexe_target', createTarget)
oUF:RegisterStyle('Hexe_tot', createToTandPet)
oUF:RegisterStyle('Hexe_focus', createFocus)

oUF:SetActiveStyle('Hexe_player')
oUF:Spawn("player", "Hexe_Player"):SetPoint(frame_positions[1].a1, frame_positions[1].af, frame_positions[1].a2, frame_positions[1].x, frame_positions[1].y)

oUF:SetActiveStyle('Hexe_target')
oUF:Spawn("target", "Hexe_Target"):SetPoint(frame_positions[2].a1, frame_positions[2].af, frame_positions[2].a2, frame_positions[2].x, frame_positions[2].y)  

oUF:SetActiveStyle('Hexe_tot')
oUF:Spawn("pet", "Hexe_Pet"):SetPoint(frame_positions[4].a1, frame_positions[4].af, frame_positions[4].a2, frame_positions[4].x, frame_positions[4].y) 
oUF:Spawn("targettarget", "Hexe_ToT"):SetPoint(frame_positions[3].a1, frame_positions[3].af, frame_positions[3].a2, frame_positions[3].x, frame_positions[3].y) 

oUF:SetActiveStyle('Hexe_focus')
oUF:Spawn("focus", "Hexe_Focus"):SetPoint(frame_positions[5].a1, frame_positions[5].af, frame_positions[5].a2, frame_positions[5].x, frame_positions[5].y) 
   