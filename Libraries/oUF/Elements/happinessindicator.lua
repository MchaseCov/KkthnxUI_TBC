--[[
# Element: HappinessIndicator

Handles the visibility and updating of player pet happiness.

## Widget

HappinessIndicator - A `Texture` used to display the current happiness level.
The element works by changing the texture's vertex color.

## Notes

A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.

## Examples

    -- Position and size
    local HappinessIndicator = self:CreateTexture(nil, 'OVERLAY')
    HappinessIndicator:SetSize(16, 16)
    HappinessIndicator:SetPoint('TOPRIGHT', self)

    -- Register it with oUF
    self.HappinessIndicator = HappinessIndicator
--]]

local _, ns = ...
local oUF = ns.oUF

local GetPetHappiness = GetPetHappiness
local HasPetUI = HasPetUI

-- Changed tooltip for KkthnxUI
local function UpdateTooltip()
	local happiness, damage_percentage = GetPetHappiness()
	if happiness then
		GameTooltip:SetText(_G["PET_HAPPINESS"..happiness])
		if damage_percentage then
			GameTooltip:AddLine(format(PET_DAMAGE_PERCENTAGE, damage_percentage), "", 1, 1, 1)
		end
		GameTooltip:Show()
	end
end

local function OnEnter(element)
	GameTooltip:SetOwner(element, "ANCHOR_BOTTOM", 0, -5) -- KkthnxUI
	UpdateTooltip()
end

local function OnLeave()
	GameTooltip:Hide()
end

local function Update(self, _, unit)
	if(not unit or self.unit ~= unit) then return end

	local element = self.HappinessIndicator

	--[[ Callback: HappinessIndicator:PreUpdate()
	Called before the element has been updated.

	* self - the ComboPoints element
	--]]
	if(element.PreUpdate) then
		element:PreUpdate()
	end

	local _, hunterPet = HasPetUI()
	local happiness, damagePercentage = GetPetHappiness()

	if(hunterPet and happiness) then
		if(happiness == 1) then
			element:SetTexCoord(0.375, 0.5625, 0, 0.359375)
			element.IconBorder.KKUI_Border:SetVertexColor(0.87, 0.37, 0.37)
		elseif(happiness == 2) then
			element:SetTexCoord(0.1875, 0.375, 0, 0.359375)
			element.IconBorder.KKUI_Border:SetVertexColor(0.85, 0.77, 0.36)
		elseif(happiness == 3) then
			element:SetTexCoord(0, 0.1875, 0, 0.359375)
			element.IconBorder.KKUI_Border:SetVertexColor(0.29, 0.67, 0.30)
		end

		element:Show()
		element.IconBorder:Show()
	else
		return element:Hide(), element.IconBorder:Hide()
	end

	--[[ Callback: HappinessIndicator:PostUpdate(role)
	Called after the element has been updated.

	* self      - the ComboPoints element
	* unit      - the unit for which the update has been triggered (string)
	* happiness        - the numerical happiness value of the pet (1 = unhappy, 2 = content, 3 = happy) (number)
	* damagePercentage - damage modifier, happiness affects this (unhappy = 75%, content = 100%, happy = 125%) (number)
	--]]
	if(element.PostUpdate) then
		return element:PostUpdate(unit, happiness, damagePercentage)
	end
end

local function Path(self, ...)
	--[[ Override: HappinessIndicator.Override(self, event, ...)
	Used to completely override the internal update function.

	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.HappinessIndicator.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.HappinessIndicator
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_HAPPINESS', Path)

		if(element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\PetPaperDollFrame\UI-PetHappiness]])
		end

		if(element.IconBorder and element.IconBorder:IsMouseEnabled()) then
			element.tooltipAnchor = element.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'

			if(not element.IconBorder:GetScript('OnEnter')) then
				element.IconBorder:SetScript('OnEnter', OnEnter)
			end

			if(not element.IconBorder:GetScript('OnLeave')) then
				element.IconBorder:SetScript('OnLeave', OnLeave)
			end
		end

		return true
	end
end

local function Disable(self)
	local element = self.HappinessIndicator
	if(element) then
		element:Hide()
		element.IconBorder:Hide()

		self:UnregisterEvent('UNIT_HAPPINESS', Path)
	end
end

oUF:AddElement('HappinessIndicator', Path, Enable, Disable)
