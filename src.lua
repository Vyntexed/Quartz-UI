local localPlayer = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local library = {}

library.themes = {
	dark = {
		bg_primary = {11, 15, 26,0.2},
		
	},
	
	light = {
		bg_primary = {245, 247, 252,0.4}
	}
}

library.currentTheme = library.themes.dark

library.flags = {
	["NoResize"] = "flagNoResize"
}

local misc = {
	Frame = function()
		local a = Instance.new("Frame", library._internal.latestObject)
		library._internal.latestObject = a
		return a	
	end,
	
	UiGradient = function(Parent)
		local a = Instance.new("UIGradient",library._internal.latestObject or Parent)
		return a	
	end,
	
	UiAspectRatio = function(ratio,parent)
		local parent = parent or library._internal.latestObject
		local d = Instance.new("UIAspectRatioConstraint",parent)
		d.AspectRatio = ratio

		return d
	end,
	
	UiCorner = function(t1,parent)
		local parent = parent or library._internal.latestObject
		local d = Instance.new("UICorner",parent)
		d.CornerRadius = UDim.new(t1[1],t1[2])

		return d
	end,
	
	Button = function(parent)
		local parent = parent or library._internal.latestObject
		
		local d = Instance.new("TextButton",parent)
		
		return d
	end,
	
	UiListLayout = function(Parent)
		local d = Instance.new("UIListLayout",library._internal.latestObject or Parent)
		
		return d
	end,
	
	UiPadding = function(Parent)
		local d = Instance.new("UIPadding",library._internal.latestObject or Parent)
		
		return d
	end,
	
	-- other
	
	add_drag = function(activator,target)
		local dragging = false
		local offset = Vector2.new()

		local function mouseScale(parent)
			local m = userInputService:GetMouseLocation()
			local p, s = parent.AbsolutePosition, parent.AbsoluteSize
			return Vector2.new(
				(m.X - p.X) / s.X,
				(m.Y - p.Y) / s.Y
			)
		end

		activator.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true

				local parent = target.Parent
				local mouse = mouseScale(parent)

				offset = mouse - Vector2.new(
					target.Position.X.Scale,
					target.Position.Y.Scale
				)
			end
		end)

		activator.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)

		userInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

			local parent = target.Parent
			local mouse = mouseScale(parent)

			local pos = mouse - offset

			target.Position = UDim2.new(pos.X, 0, pos.Y, 0)
		end)
	end,
	
	table_to_UDIM2 = function(t1,t2)
		return UDim2.new(t1[1],t1[2],t2[1],t2[2])
	end,
	
	blur = function(to_blur)
		local Lighting          = game:GetService("Lighting")
		local camera			= workspace.CurrentCamera

		local BLUR_SIZE         = Vector2.new(10, 10)
		local PART_SIZE         = 0.01
		local PART_TRANSPARENCY = 1 - 1e-7
		local START_INTENSITY	= 1

		script.Parent:SetAttribute("BlurIntensity", START_INTENSITY)

		local BLUR_OBJ          = Instance.new("DepthOfFieldEffect")
		BLUR_OBJ.FarIntensity   = 0
		BLUR_OBJ.NearIntensity  = script.Parent:GetAttribute("BlurIntensity")
		BLUR_OBJ.FocusDistance  = 0.25
		BLUR_OBJ.InFocusRadius  = 0
		BLUR_OBJ.Parent         = Lighting

		local PartsList         = {}
		local BlursList         = {}
		local BlurObjects       = {}
		local BlurredGui        = {}

		BlurredGui.__index      = BlurredGui

		function rayPlaneIntersect(planePos, planeNormal, rayOrigin, rayDirection)
			local n = planeNormal
			local d = rayDirection
			local v = rayOrigin - planePos

			local num = n.x*v.x + n.y*v.y + n.z*v.z
			local den = n.x*d.x + n.y*d.y + n.z*d.z
			local a = -num / den

			return rayOrigin + a * rayDirection, a
		end

		function rebuildPartsList()
			PartsList = {}
			BlursList = {}
			for blurObj, part in pairs(BlurObjects) do
				table.insert(PartsList, part)
				table.insert(BlursList, blurObj)
			end
		end

		function BlurredGui.new(frame, shape)
			local blurPart        = Instance.new("Part")
			blurPart.Size         = Vector3.new(1, 1, 1) * 0.01
			blurPart.Anchored     = true
			blurPart.CanCollide   = false
			blurPart.CanTouch     = false
			blurPart.Material     = Enum.Material.Glass
			blurPart.Transparency = PART_TRANSPARENCY
			blurPart.Parent       = workspace.CurrentCamera

			local mesh
			if (shape == "Rectangle") then
				mesh        = Instance.new("BlockMesh")
				mesh.Parent = blurPart
			elseif (shape == "Oval") then
				mesh          = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.Sphere
				mesh.Parent   = blurPart
			end

			local ignoreInset = false
			local currentObj  = frame

			while true do
				currentObj = currentObj.Parent

				if (currentObj and currentObj:IsA("ScreenGui")) then
					ignoreInset = currentObj.IgnoreGuiInset
					break
				elseif (currentObj == nil) then
					break
				end
			end

			local new = setmetatable({
				Frame          = frame;
				Part           = blurPart;
				Mesh           = mesh;
				IgnoreGuiInset = ignoreInset;
			}, BlurredGui)

			BlurObjects[new] = blurPart
			rebuildPartsList()

			game:GetService("RunService"):BindToRenderStep("...", Enum.RenderPriority.Camera.Value + 1, function()
				blurPart.CFrame = camera.CFrame * CFrame.new(0,0,0)
				BlurredGui.updateAll()
			end)
			return new
		end

		function updateGui(blurObj)
			if (not blurObj.Frame.Visible) then
				blurObj.Part.Transparency = 1
				return
			end

			local camera = workspace.CurrentCamera
			local frame  = blurObj.Frame
			local part   = blurObj.Part
			local mesh   = blurObj.Mesh

			part.Transparency = PART_TRANSPARENCY

			local corner0 = frame.AbsolutePosition + BLUR_SIZE
			local corner1 = corner0 + frame.AbsoluteSize - BLUR_SIZE*2
			local ray0, ray1

			if (blurObj.IgnoreGuiInset) then
				ray0 = camera:ViewportPointToRay(corner0.X, corner0.Y, 1)
				ray1 = camera:ViewportPointToRay(corner1.X, corner1.Y, 1)
			else
				ray0 = camera:ScreenPointToRay(corner0.X, corner0.Y, 1)
				ray1 = camera:ScreenPointToRay(corner1.X, corner1.Y, 1)
			end

			local planeOrigin = camera.CFrame.Position + camera.CFrame.LookVector * (0.05 - camera.NearPlaneZ)
			local planeNormal = camera.CFrame.LookVector
			local pos0 = rayPlaneIntersect(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
			local pos1 = rayPlaneIntersect(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

			local pos0 = camera.CFrame:PointToObjectSpace(pos0)
			local pos1 = camera.CFrame:PointToObjectSpace(pos1)

			local size   = pos1 - pos0
			local center = (pos0 + pos1)/2

			mesh.Offset = center
			mesh.Scale  = size / PART_SIZE
		end

		function BlurredGui.updateAll()
			BLUR_OBJ.NearIntensity = tonumber(script.Parent:GetAttribute("BlurIntensity"))

			for i = 1, #BlursList do
				updateGui(BlursList[i])
			end

			local cframes = table.create(#BlursList, workspace.CurrentCamera.CFrame)
			workspace:BulkMoveTo(PartsList, cframes, Enum.BulkMoveMode.FireCFrameChanged)

			BLUR_OBJ.FocusDistance = 0.25 - camera.NearPlaneZ
		end

		function BlurredGui:Destroy()
			self.Part:Destroy()
			BlurObjects[self] = nil
			rebuildPartsList()
		end

		BlurredGui.new(to_blur, "Rectangle")

		BlurredGui.updateAll()
	end,
}

function library:init()
	library._internal = {}
	library._internal.latestObject = nil
	library._internal.latestWindow = nil
	library._internal.screen = Instance.new("ScreenGui")
	library._internal.screen.Parent = localPlayer.PlayerGui
end

function library:new_window(...)
	local window = misc.Frame()
	window.Parent = library._internal.screen
	
	window.Size = misc.table_to_UDIM2({0.506, 0},{0.651, 0})
	window.Position = UDim2.new(0.5,0,0.5,0)
	window.AnchorPoint = Vector2.new(0.5,0.5)
	
	misc.blur(window)
	misc.UiCorner({0.036, 0})
	local winAR = misc.UiAspectRatio(1.561)
	winAR.Parent = window
	
	window.BackgroundTransparency = library.currentTheme.bg_primary[4]
	window.BackgroundColor3 = Color3.fromRGB(library.currentTheme.bg_primary[1],library.currentTheme.bg_primary[2],library.currentTheme.bg_primary[3])
	
	library._internal.latestWindow = window
	
	local win_dec = misc.Frame()
	win_dec.Parent = window
	win_dec.Size = misc.table_to_UDIM2({1, 0},{1, 0})
	misc.UiCorner({0.036,0},win_dec)
	local uigrad_dec = misc.UiGradient(win_dec)
	uigrad_dec.Rotation = -90
	uigrad_dec.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
	uigrad_dec.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.75)})
	
	local topbar = misc.Frame()
	topbar.Size = misc.table_to_UDIM2({1, 0},{0.071, 0})
	topbar.Position = misc.table_to_UDIM2({0, 0},{0, 0})
	topbar.BackgroundTransparency = 1
	
	local topbar_button_holder = misc.Frame()
	topbar_button_holder.Parent = topbar
	topbar_button_holder.Size = misc.table_to_UDIM2({0.194, 0},{1, 0})
	topbar_button_holder.BackgroundTransparency = 1
	
	local x_btn = misc.Button(topbar_button_holder)
	x_btn.BackgroundColor3 = Color3.fromRGB(252, 82, 85)
	x_btn.Text = ""
	x_btn.LayoutOrder = 1
	x_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	misc.UiAspectRatio(1,x_btn)
	misc.UiCorner({1,0},x_btn)
	
	local fullscreen_btn = misc.Button(topbar_button_holder)
	fullscreen_btn.BackgroundColor3 = Color3.fromRGB(44, 191, 77)
	fullscreen_btn.Text = ""
	fullscreen_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	fullscreen_btn.LayoutOrder = 3
	misc.UiAspectRatio(1,fullscreen_btn)
	misc.UiCorner({1,0},fullscreen_btn)
	
	local minimize_btn = misc.Button(topbar_button_holder)
	minimize_btn.BackgroundColor3 = Color3.fromRGB(245, 193, 7)
	minimize_btn.LayoutOrder = 2
	minimize_btn.Text = ""
	minimize_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	misc.UiAspectRatio(1,minimize_btn)
	misc.UiCorner({1,0},minimize_btn)
	
	local padding = misc.UiPadding(topbar_button_holder)
	padding.PaddingLeft = UDim.new(0.06, 0)
	padding.PaddingTop = UDim.new(0.1, 0)
	
	local ULL = misc.UiListLayout(topbar_button_holder)
	ULL.VerticalAlignment = Enum.VerticalAlignment.Center
	ULL.Padding = UDim.new(0.06, 0)
	ULL.FillDirection = Enum.FillDirection.Horizontal
	ULL.SortOrder = Enum.SortOrder.LayoutOrder
	
	if not table.find({...},library.flags.NoResize) then
		--local pos = window.Position
		--local size = window.Size
		--local topbarSize = topbar.Size
		
		--fullscreen_btn.Activated:Connect(function()
		--	winAR:Destroy()
			
		--	if window.Size == UDim2.new(1,0,1,0) then
		--		winAR = misc.UiAspectRatio(1.561)
		--		winAR.Parent = window
		--		window.Position = pos
		--		window.Size = size
		--		topbar.Size = topbarSize
		--	else
		--		pos = window.Position
		--		size = window.Size
				
		--		topbarSize = topbar.Size
		--		topbar.Size = UDim2.new(1, 0, 0, topbar.AbsoluteSize.Y)
				
		--		window.Size = misc.table_to_UDIM2({1, 0},{1, 0})
		--		window.Position = misc.table_to_UDIM2({0.5,0},{0.5,0})
		--	end	
		--end)
	end
	
	misc.add_drag(topbar,window)
end

return library
