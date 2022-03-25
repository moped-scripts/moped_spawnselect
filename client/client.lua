local current = 1
local active = false
local currentCam = nil
local fadeout = false

local function DrawText(text, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(fontscale, fontsize)
    SetTextColor(r, g, b, alpha)
    SetTextCentre(textcentred)
    if shadow then 
        SetTextDropshadow(1, 0, 0, 255)
    end
    SetTextFontForCurrentCommand(6)
    DisplayText(str, x, y)
end

AddEventHandler("vorp:initNewCharacter", function()
    DoScreenFadeOut(0)
    fadeout = true
    CreateThread(function()
		while fadeout do
            Wait(0)
            DoScreenFadeOut(0)
        end
    end)
    active = true
    Wait(6000)
    fadeout = false
    DoScreenFadeOut(0)
    currentCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    local coords = Config.SpawnLocations[current].coords
	SetCamCoord(currentCam, vector3(coords.x, coords.y, coords.z + 125))
	PointCamAtCoord(currentCam, coords)
	SetCamFov(currentCam, 65.0)
	SetCamActive(currentCam, true)
	RenderScriptCams(true, false, 1, 1, 1)
    StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, false, true, true)

    while IsPlayerTeleportActive() do
        Wait(100)
    end
    SetEntityVisible(PlayerPedId(), false, 0)

    DoScreenFadeIn(1000)
	CreateThread(function()
		while active do
			Wait(0)
            DisableAllControlActions(0)
			DrawText(Config.Locales.where..'\n\n'..Config.Locales.arrive..' '..Config.SpawnLocations[current].name..' '..Config.Locales.by..' '..Config.SpawnLocations[current].arrive..'.\n'..Config.Locales.press, 0.5, 0.75, 0.7, 0.7, 255, 255, 255, 255, true, true)
            if IsDisabledControlJustReleased(0, 0x7065027D) or IsDisabledControlJustReleased(0, 0xA65EBAB4) then -- A
                if current > 1 then
                    current = current - 1
                else
                    current = #Config.SpawnLocations
                end
                coords = Config.SpawnLocations[current].coords
                DoScreenFadeOut(100)
                Wait(100)
                StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, false, true, true)

                while IsPlayerTeleportActive() do
                    Wait(100)
                end
                SetEntityVisible(PlayerPedId(), false, 0)

                SetCamCoord(currentCam, vector3(coords.x, coords.y, coords.z + 125))
                PointCamAtCoord(currentCam, coords)
                SetCamFov(currentCam, 65.0)
                Wait(250)
                DoScreenFadeIn(500)
            elseif IsDisabledControlJustReleased(0, 0xB4E465B4) or IsDisabledControlJustReleased(0, 0xDEB34313) then -- D
                if current < #Config.SpawnLocations then
                    current = current + 1
                else
                    current = 1
                end
                coords = Config.SpawnLocations[current].coords
                DoScreenFadeOut(100)
                Wait(100)
                RequestCollisionAtCoord(coords)
                StartPlayerTeleport(PlayerId(), coords.x, coords.y, coords.z, 0.0, false, true, true)

                while IsPlayerTeleportActive() do
                    Wait(100)
                end
                SetEntityVisible(PlayerPedId(), false, 0)

                SetCamCoord(currentCam, vector3(coords.x, coords.y, coords.z + 125))
                PointCamAtCoord(currentCam, coords)
                SetCamFov(currentCam, 65.0)
                Wait(250)
                DoScreenFadeIn(500)
            elseif IsDisabledControlJustReleased(0, 0xC7B5340A) then -- ENTER
                DoScreenFadeOut(100)
                Wait(100)
                RenderScriptCams(0,0,4000)
                SetCamActive(currentCam, false)
			    DestroyCam(currentCam, false)
			    ClearFocus()
                currentCam = nil
                currentCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                local coords = Config.SpawnLocations[current].coords
                SetCamCoord(currentCam, vector3(coords.x, coords.y, coords.z + 125))
                PointCamAtCoord(currentCam, coords)
                SetCamFov(currentCam, 65.0)
                SetCamActive(currentCam, true)
                RenderScriptCams(true, false, 1, 1, 1)
                Wait(1000)
                DoScreenFadeIn(1000)
                RenderScriptCams(0,1,4000)
                SetEntityVisible(PlayerPedId(), true, 0)
                Wait(4000)
			    SetCamActive(currentCam, false)
			    DestroyCam(currentCam, false)
			    ClearFocus()
                currentCam = nil
                active = false
                current = 1
                break
            end
		end
	end)
end)