local _G = _G

local TL, TC, TR = 'TOPLEFT', 'TOP', 'TOPRIGHT'
local ML, MC, MR = 'LEFT', 'CENTER', 'RIGHT'
local BL, BC, BR = 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'

local eventframe = CreateFrame('Frame')

local padding = 1
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

function nothing(...) end

function process_button (button)
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

function create_bar (barname, buttonname, padding)
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

function hook_hidegrid (button)
	button:Show()
end

function onevent (frame, event, ...)
	if event == 'PLAYER_LOGIN' then
		enable()
	end
end

function enable ()
	bar1 = create_bar('idMainMenuBar1', 'ActionButton', padding)
	bar2 = create_bar('MultiBarBottomLeft', 'MultiBarBottomLeftButton', padding)
	bar3 = create_bar('MultiBarBottomRight', 'MultiBarBottomRightButton', padding)

	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomLeft'] = nil
	_G.UIPARENT_MANAGED_FRAME_POSITIONS['MultiBarBottomRight'] = nil

	bar1:SetPoint(BC, UIParent, BC, 0, padding)
	bar2:SetPoint(BC, bar1, TC, 0, padding)
	bar3:SetPoint(BC, bar2, TC, 0, padding)

	MainMenuBar:Hide()
	MainMenuBar.Show = nothing

	hooksecurefunc('ActionButton_HideGrid', hook_hidegrid)
end

eventframe:SetScript('OnEvent', onevent)
eventframe:RegisterEvent('PLAYER_LOGIN')

