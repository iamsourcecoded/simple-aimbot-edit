-- uses camera and mouserel no predict fork of exunys
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false
local esptarget = nil
local modifier = 0
_G.Mode = 1 -- 1 = mouserel 2 = camera
_G.AimbotEnabled = true
_G.TeamCheck = false -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.


_G.CircleSides = 64 -- How many sides the FOV circle would have.
_G.CircleColor = Color3.fromRGB(255, 255, 255) -- (RGB) Color that the FOV circle would appear as.
_G.CircleTransparency = 0.7 -- Transparency of the circle.
_G.CircleRadius = 80 -- The radius of the circle / FOV.
_G.CircleFilled = false -- Determines whether or not the circle is filled.
_G.CircleVisible = true -- Determines whether or not the circle is visible.
_G.CircleThickness = 0 -- The thickness of the circle.

local FOVCircle = Drawing.new("Circle")
local Mouse = game.Players.LocalPlayer:GetMouse()
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function GetClosestPlayer()
	local MaximumDistance = _G.CircleRadius
	local Target = nil

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
							end
						end
					end
				end
			end
		end
	end

	return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding == true and _G.AimbotEnabled == true then
        if GetClosestPlayer().Character ~= nil then
        if _G.Mode == 1 then
            
        GetPositionsFromVector3 = Camera:WorldToScreenPoint(GetClosestPlayer().Character[_G.AimPart].Position - Vector3.new(0,modifier,0))
		mousemoverel((GetPositionsFromVector3.X - UserInputService:GetMouseLocation().X) / 4, (GetPositionsFromVector3.Y - UserInputService:GetMouseLocation().Y) / 4)
        end
        if _G.Mode == 2 then
        TweenService:Create(Camera, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, GetClosestPlayer().Character[_G.AimPart].Position)}):Play()
        end
         if GetClosestPlayer().Character[_G.AimPart] ~= esptarget and esptarget ~= nil then
             if esptarget.BOX ~= nil then
             esptarget.BOX:Destroy()
             end
        end
        if not GetClosestPlayer().Character[_G.AimPart]:FindFirstChild("BOX") then
        local a = Instance.new("BoxHandleAdornment")
        esptarget = GetClosestPlayer().Character[_G.AimPart]
		a.Name = "BOX"
        a.Parent = GetClosestPlayer().Character[_G.AimPart]
		a.Adornee = GetClosestPlayer().Character[_G.AimPart]
		a.AlwaysOnTop = true
		a.ZIndex = 10
		a.Size = GetClosestPlayer().Character[_G.AimPart].Size
		a.Transparency = 0.5
		end
        end
end

    if esptarget ~= nil and Holding ~= true then
        esptarget.BOX:Destroy()
        esptarget = nil
    end
    
    -- now i must calculate distance
    if LocalPlayer.Character ~= nil and GetClosestPlayer().Character ~= nil then
            distance = math.floor((GetClosestPlayer().Character[_G.AimPart].Position - LocalPlayer.Character.Head.Position).Magnitude)   
           modifier = math.floor(distance / 20)
           -- epic now mousemoverel is functional
    end
end)
