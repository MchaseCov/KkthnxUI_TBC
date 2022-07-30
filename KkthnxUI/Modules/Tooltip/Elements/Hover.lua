local K, _, L = unpack(KkthnxUI)
local Module = K:GetModule("Tooltip")

local _G = _G
local string_match = _G.string.match
local string_split = _G.string.split
local tonumber = _G.tonumber

local BOSS = _G.BOSS
local GameTooltip = _G.GameTooltip
local INSTANCE = _G.INSTANCE
local NUM_CHAT_WINDOWS = _G.NUM_CHAT_WINDOWS

local orig1, orig2, sectionInfo = {}, {}, {}
local linkTypes = {
	currency = true,
	enchant = true,
	instancelock = true,
	item = true,
	quest = true,
	spell = true,
	talent = true,
	unit = true,
}

function Module:HyperLink_SetTypes(link)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", -3, 5)
	GameTooltip:SetHyperlink(link)
	GameTooltip:Show()
end

function Module:HyperLink_OnEnter(link, ...)
	local linkType = string_match(link, "^([^:]+)")
	if linkType and linkTypes[linkType] then
		Module.HyperLink_SetTypes(self, link)
	end

	if orig1[self] then
		return orig1[self](self, link, ...)
	end
end

function Module:HyperLink_OnLeave(_, ...)
	GameTooltip:Hide()

	if orig2[self] then
		return orig2[self](self, ...)
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", Module.HyperLink_OnEnter)
	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", Module.HyperLink_OnLeave)
end