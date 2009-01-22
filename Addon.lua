local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local padding = 3
local buttons_per_bar = 12

local function hide (x)
	x:Hide()
	x:SetScript('OnShow', x.Hide)
end

local function nothing(...) end

local function bar (barname, buttonname, padding)
	local f = _G[barname] or CreateFrame('Frame', barname, UIParent)
	local b, t

	f:ClearAllPoints()

	for i = 1, buttons_per_bar do
		b = _G[buttonname .. i]
		t = (_G[buttonname .. i .. 'NormalTexture2'] or _G[buttonname .. i .. 'NormalTexture'])
		b:SetParent(f)
		b:ClearAllPoints()
		b:Show()
		b.Hide = nothing
		t:SetAlpha(0.5)
		t.SetAlpha = nothing
		if i == 1 then
			b:SetPoint(ML, f, ML)
		else
			b:SetPoint(ML, _G[buttonname .. i - 1], MR, padding, 0)
		end
	end
	f:SetWidth(b:GetWidth() * buttons_per_bar + padding * buttons_per_bar)
	f:SetHeight(b:GetHeight())
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

