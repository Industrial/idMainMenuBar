local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local eventframe = CreateFrame('Frame')

local padding = 0
local buttons_per_bar = 12
local bar1
local bar2
local bar3

local nothing
local process_button
local create_bar
local hook_hidegrid
local onevent
local enable

function nothing (...)
end

function process_button (button)
	local name = button:GetName()
	local icon = _G[name .. 'Icon']
	local texture = (_G[name .. 'NormalTexture2'] or _G[name .. 'NormalTexture'])
	local hotkey = _G[name .. 'HotKey']
	local macrotext = _G[name .. 'Name']

	icon:SetTexCoord(0.08,0.92,0.08,0.92)

	hotkey:Hide()
	macrotext:Hide()

	texture:SetAlpha(0.5)
	texture:SetTexCoord(0,0,0,0)

	-- ugly but works
	texture.SetAlpha = nothing
	hotkey.Show = nothing
	macrotext.Show = nothing
end

function create_bar (barname, buttonname, padding, buttons_per_bar)
	local bar = _G[barname] or CreateFrame('Frame', barname, UIParent)

	bar:ClearAllPoints()

	for i = 1, buttons_per_bar do
		button = _G[buttonname .. i]

		button:Show()
		button.Hide = nothing

		button:SetParent(bar)

		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint(ML, bar, ML)
		else
			button:SetPoint(ML, _G[buttonname .. i - 1], MR, padding, 0)
		end
		button.SetPoint = nothing

		process_button(button)
	end

	bar:SetWidth(button:GetWidth() * buttons_per_bar + padding * buttons_per_bar)
	bar:SetHeight(button:GetHeight())
	bar:SetScale(1)

	return bar
end

function hook_hidegrid (button)
	button:Show()
end

function onevent (frame, event, ...)
	if event == 'PLAYER_LOGIN' then
		enable()
	end
end

function enable ()
	bar1 = create_bar('idMainMenuBar1', 'ActionButton', padding, 12)
	bar2 = create_bar('MultiBarBottomLeft', 'MultiBarBottomLeftButton', padding, 12)
	bar3 = create_bar('MultiBarBottomRight', 'MultiBarBottomRightButton', padding, 12)
	bar4 = create_bar('MultiBarRight', 'MultiBarRightButton', padding, 12)
	bar5 = create_bar('MultiBarLeft', 'MultiBarLeftButton', padding, 12)
	bar6 = create_bar('idMainMenuBar2', 'PetActionButton', padding, 10)

	bar1:SetPoint(BC, UIParent, BC, 0, padding)
	bar2:SetPoint(BC, bar1, TC, 0, padding)
	bar3:SetPoint(BC, bar2, TC, 0, padding)
	bar4:SetPoint(BC, bar3, TC, 0, padding)
	bar5:SetPoint(BC, bar4, TC, 0, padding)
	bar6:SetPoint(BC, bar5, TC, 0, padding)

	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomLeft'] = nil
	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomRight'] = nil
	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarRight'] = nil
	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarLeft'] = nil
	MultiBarBottomLeft.SetPoint = nothing
	MultiBarBottomRight.SetPoint = nothing
	MultiBarLeft.SetPoint = nothing
	MultiBarRight.SetPoint = nothing

	MainMenuBar:Hide()
	MainMenuBar.Show = nothing

	hooksecurefunc('ActionButton_HideGrid', hook_hidegrid)
end

eventframe:SetScript('OnEvent', onevent)
eventframe:RegisterEvent('PLAYER_LOGIN')

