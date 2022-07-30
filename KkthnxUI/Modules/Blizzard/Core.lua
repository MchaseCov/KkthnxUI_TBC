local K = unpack(KkthnxUI)
local Module = K:NewModule("Blizzard")

function Module:OnEnable()
	self:CreateUIWidgets()
	self:CreateMirrorBars()
	self:CreateAlertFrames()
	self:CreateColorPicker()
	self:CreateMirrorBars()
	self:CreateNoBlizzardTutorials()
	self:CreateRaidUtility()
end