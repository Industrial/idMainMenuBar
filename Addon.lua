local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local padding = 1
local buttons_per_bar = 12

local function hide (x)
	x:Hide()
	x:SetScript('OnShow', x.Hide)
end

local function nothing(...) end

local function process_button (button)
	local name = button:GetName()
	local icon = _G[name .. 'Icon']
	local texture = (_G[name .. i .. 'NormalTexture2'] or _G[name .. i .. 'NormalTexture'])
	local macrotext = _G[name .. 'Name']

	button:ClearAllPoints()
	button:Show()

	icon:SetTexCoord(0.08,0.92,0.08,0.92)

	macrotext:Hide()

	texture:SetAlpha(0.5)
	texture:SetTexCoord(0,0,0,0)

	-- ugly but works
	button.Hide = nothing
	texture.SetAlpha = nothing
	macrotext.Show = nothing
end

local function bar (barname, buttonname, padding)
	local f = _G[barname] or CreateFrame('Frame', barname, UIParent)

	f:ClearAllPoints()

	for i = 1, buttons_per_bar do
		button = _G[buttonname .. i]
		button:SetParent(f)
		process_button(button)
		if i == 1 then
			button:SetPoint(ML, f, ML)
		else
			button:SetPoint(ML, _G[buttonname .. i - 1], MR, padding, 0)
		end
	end
	f:SetWidth(button:GetWidth() * buttons_per_bar + padding * buttons_per_bar)
	f:SetHeight(button:GetHeight())
	return f
end

local function hookHideGrid (button)
	button:Show()
end
hooksecurefunc('ActionButton_HideGrid', hookHideGrid)

local barframe1 = bar('idMainMenuBar1', 'ActionButton', padding)
local barframe2 = bar('MultiBarBottomLeft', 'MultiBarBottomLeftButton', padding)
local barframe3 = bar('MultiBarBottomRight', 'MultiBarBottomRightButton', padding)

_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomLeft'] = nil
_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomRight'] = nil

barframe1:SetPoint(BC, UIParent, BC, 0, padding)
barframe2:SetPoint(BC, barframe1, TC, 0, padding)
barframe3:SetPoint(BC, barframe2, TC, 0, padding)

hide(MainMenuBar)

