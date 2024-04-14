--##########################################################################--
-- MAKE CHANGES BELOW HERE
--##########################################################################--

-- Set true to use whitelisting instead of simply displaying the 32 highest resolutions (as limited by UIDROPDOWNMENU_MAXBUTTONS)
local whitelistMode = false

-- Edit this list to filter the available resolutions when whitelistMode = true
local whitelist = {
    "1024x768",
    "1400x900",
}

--##########################################################################--
-- MAKE CHANGES ABOVE HERE
--##########################################################################--





--##########################################################################--
-- ACTUAL CODE BELOW HERE - DO NOT EDIT unless you know what you're doing
--##########################################################################--

--//////////////////////////////////////////////////////////////////////////--
-- Initialization
--//////////////////////////////////////////////////////////////////////////--
local resolutionList = {}
local resolutionsToOriginalIds = {}
local originalIdsToMyIds = {}
local allowedResolutions


--//////////////////////////////////////////////////////////////////////////--
-- Helpers
--//////////////////////////////////////////////////////////////////////////--

--**********************************************************************--
-- Helper function for wiping a table
local function tclear(tbl)
	if type(tbl) ~= "table" then
		return
	end

	-- Clear array-type tables first so table.insert will start over at 1
	for i = getn(tbl), 1, -1 do
        tremove(tbl, i)
    end

	-- Remove any remaining associative table elements
	-- Credit: https://stackoverflow.com/a/27287723
	for k in next, tbl do rawset(tbl, k, nil) end
end


--**********************************************************************--
-- Add the given resolution to our list, recording the necessary ID information
-- so we can translate back to something SetScreenResolution() will accept
local function addResolution(resolution, id)
    if table.getn(resolutionList) < UIDROPDOWNMENU_MAXBUTTONS then
        table.insert(resolutionList, resolution)
        resolutionsToOriginalIds[resolution] = id
        originalIdsToMyIds[id] = table.getn(resolutionList)
    end
end


--//////////////////////////////////////////////////////////////////////////--
-- Main functionality
--//////////////////////////////////////////////////////////////////////////--

--**********************************************************************--
-- Produce the list of filtered resolutions and populate our lookup tables
local function GetFilteredScreenResolutions()

    -- Get the full list of resolutions
    local availableResolutions = {GetScreenResolutions()}

    -- Reset tracking tables
    tclear(resolutionList)
    tclear(resolutionsToOriginalIds)
    tclear(originalIdsToMyIds)

    -- Whitelist mode
    if whitelistMode then

        -- Set whitelist resolutions as table keys so it's easy to determine what's allowed
        if allowedResolutions == nil then
            allowedResolutions = {}
            for _, resolution in whitelist do
                allowedResolutions[resolution] = resolution
            end
        end

        -- Add whitelisted entries from the original list of resolutions
        for id, resolution in availableResolutions do
            if allowedResolutions[resolution] then
                addResolution(resolution, id)
            end
        end


    -- Only the top 32 resolutions
    else
        for id = math.max(getn(availableResolutions) - UIDROPDOWNMENU_MAXBUTTONS + 1, 1), getn(availableResolutions) do
            addResolution(availableResolutions[id], id)
        end
    end

    -- GetScreenResolutions() returns an unpacked list, so we have do to the same
    return unpack(resolutionList)
end


--**********************************************************************--
-- Print list of resolutions to chat
local function PrintResolutions(filtered)
    local availableResolutions = filtered and {GetFilteredScreenResolutions()} or {GetScreenResolutions()}
    DEFAULT_CHAT_FRAME:AddMessage((filtered and "Filtered" or "Original") .. " screen resolution list:")
    for id, resolution in availableResolutions do
        DEFAULT_CHAT_FRAME:AddMessage(string.format("%02d", id) .. (filtered and (" [" .. string.format("%02d", resolutionsToOriginalIds[resolutionList[id]]) .. "]") or "") .. ": " .. tostring(resolution))
    end
end


--**********************************************************************--
-- Register slash commands
SLASH_PrintOriginalResolutions1 = "/listres"
SlashCmdList["PrintOriginalResolutions"] = function() PrintResolutions(false) end

SLASH_PrintFilteredResolutions1 = "/listfres"
SlashCmdList["PrintFilteredResolutions"] = function() PrintResolutions(true) end



--//////////////////////////////////////////////////////////////////////////--
-- HideScriptErrorFrameAtLogin functionality
--//////////////////////////////////////////////////////////////////////////--
if (ScriptErrors:IsShown()) then
    local e = ScriptErrors_Message:GetText()
    DEFAULT_CHAT_FRAME:AddMessage("Script error at login: " .. e, 1, 0.578, 0)
    ScriptErrors:Hide()
end


--//////////////////////////////////////////////////////////////////////////--
-- Hacks for Video Options dialog
--//////////////////////////////////////////////////////////////////////////--

--**********************************************************************--
-- When the Okay button is clicked in video options, we need to step in and return the original resolution ID as expected by SetScreenResolution()
local oldUIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID
UIDropDownMenu_GetSelectedID = function(frame)
    -- Okay was clicked in the Video Options dialog
    if (frame and frame:GetName() == "OptionsFrameResolutionDropDown") and (this and this:GetName() == "OptionsFrameOkay") then
        local id = oldUIDropDownMenu_GetSelectedID(frame)
        -- id shouldn't be empty, but just to be safe
        if id then
            id = resolutionsToOriginalIds[resolutionList[id]]
        end
        return id

    -- Normal behavior
    else
        return oldUIDropDownMenu_GetSelectedID(frame)
    end
end

--**********************************************************************--
-- Update the functions for the screen resolution dropdown to use our filtered list
function OptionsFrameResolutionDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, OptionsFrameResolutionDropDown_Initialize)
	-- This line has to be changed so the appropriate current resolution will be selected
    UIDropDownMenu_SetSelectedID(this, originalIdsToMyIds[GetCurrentResolution()], 1)
	UIDropDownMenu_SetWidth(90, OptionsFrameResolutionDropDown)
end
function OptionsFrameResolutionDropDown_Initialize()
	-- Use the filtered list of resolutions instead of the original
    OptionsFrameResolutionDropDown_LoadResolutions(GetFilteredScreenResolutions())
end
