local localPlayer = game:GetService("Players").LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local lightningService = game:GetService("Lighting")

local library = {}

library.themes = {
	dark = {
		
		Font = "Inter",
		
		bg_primary = {11, 15, 26,0.2},
		bg_secondary = {24, 28, 45, 0.45},
		bg_tertiary = {30, 35, 55, 0.55},
		
		-- buttons
			
		button_primary = {0, 122, 255, 0.3},
		button_primary_text = {255,255,255,0},
		
		button_primary_hover = {0, 122, 255, 0.10},
		button_primary_pressed = {0, 102, 215, 0.05},

		button_primary_stroke = {255, 255, 255, 0.65},
		button_primary_highlight = {255, 255, 255, 0.7},
		
		-- btn secondary
		
		button_secondary = {255, 255, 255, 0.82},
		button_secondary_text = {255,255,255,0.08},
		button_secondary_stroke = {255,255,255,0.8},
		
		button_secondary_deselected = {255, 255, 255, 1},
		button_secondary_text_deselected = {255,255,255,0.55},
		button_secondary_stroke_deselected = {255,255,255,1},
		
		
		stroke_primary = {255, 255, 255, 0.88},
		
		-- text
		text_primary = {255, 255, 255, 0},
		text_secondary = {235, 235, 245, 0.4},
		text_tertiary = {235, 235, 245, 0.7},
		text_disabled = {235,235, 245, 0.82}
		
	},
	
	light = {
		
		Font = "Inter",
		
		bg_primary = {245, 247, 252,0.4},
		bg_secondary = {245, 247, 252, 0.75},
		bg_tertiary = {235, 238, 245, 0.85},
		
		-- buttons
		
		button_primary = {0, 122, 255, 0.25},
		button_primary_hover = {0, 122, 255, 0.18},
		button_primary_pressed = {0, 102, 215, 0.12},
		button_primary_text = {255,255,255,0},

		button_primary_stroke = {255, 255, 255, 0.4},
		button_primary_highlight = {255, 255, 255, 0.7},
		
		-- btn secondary
		
		button_secondary = {0, 0, 0, 0.88},
		button_secondary_text = {0, 0, 0, 0.08},
		button_secondary_stroke = {0, 0, 0, 0.82},
		button_secondary_deselected = {0, 0, 0, 1},
		button_secondary_text_deselected = {0, 0, 0, 0.55},
		button_secondary_stroke_deselected = {0, 0, 0, 1},
			
		stroke_primary = {60, 60, 67, 0.85},
		
		
		-- text
		text_primary = {0, 0, 0,0},
		text_secondary = {60, 60, 67,0.4},
		text_tertiary = {60, 60, 67, 0.7},
		text_disabled = {60, 60, 67, 0.82}
	}
}

library.theme = library.themes.dark

library.Styles = {
	Dashboard = "styleDashboard",
	Custom = "styleCustom"
}

library.Flags = {
	["NoResize"] = "flagNoResize",
	["NoDrag"] = "flagNoDrag",
	["NoAnimations"] = "flagNoAnimations"
}

library.Components = {
	Button = {
		Primary = "vBtnPrimary",
		Secondary = "vBtnSecondary"
	}
}

local logger = {
	warn = function(name,content)
		warn("Quartz: "..name.." - "..content)
	end,
	
	error = function(name,content)
		error("Quartz: "..name.." - "..content)
	end,
}

NewFont = function(Weight,Style)
	if library.theme.Font == "Inter" then
		return Font.new(Font.fromId(12187365364).Family,Weight,Style)	
	end

	return Font.new(Font.fromEnum(library.theme.Font),Weight,Style)
end

local misc = {
	Frame = function()
		local a = Instance.new("Frame", library._internal.latestObject)
		library._internal.latestObject = a
		return a	
	end,
	
	Label = function(Text,Parent)
		local a = Instance.new("TextLabel",Parent or library._internal.latestObject)
		library._internal.latestObject = a
		
		a.Text = Text or "Placeholder"
		a.FontFace = NewFont(Enum.FontWeight.Medium,Enum.FontStyle.Normal)
		
		return a
	end,
	
	UiGradient = function(Parent)
		local a = Instance.new("UIGradient",Parent or library._internal.latestObject)
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
		d.TextScaled = true
		d.FontFace = NewFont(Enum.FontWeight.Medium,Enum.FontStyle.Normal)
		
		return d
	end,
	
	UiListLayout = function(Parent)
		local d = Instance.new("UIListLayout",Parent or library._internal.latestObject)
		
		return d
	end,
	
	UiPadding = function(Parent)
		local d = Instance.new("UIPadding",Parent or library._internal.latestObject)
		
		return d
	end,
	
	UiStroke = function(Parent)
		local d = Instance.new("UIStroke",Parent or library._internal.latestObject)
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
	
	get_color = function(tbl)
		return {Color3.fromRGB(tbl[1],tbl[2],tbl[3]),tbl[4] or 0}
	end,
	
	blur = function(to_blur)
		local camera			= workspace.CurrentCamera

		local BLUR_SIZE         = Vector2.new(10, 10)
		local PART_SIZE         = 0.01
		local PART_TRANSPARENCY = 1 - 1e-7
		local START_INTENSITY	= 1

		local BLUR_OBJ          = Instance.new("DepthOfFieldEffect")
		BLUR_OBJ.FarIntensity   = 0
		BLUR_OBJ.NearIntensity  = START_INTENSITY
		BLUR_OBJ.FocusDistance  = 0.25
		BLUR_OBJ.InFocusRadius  = 0
		BLUR_OBJ.Parent         = lightningService

		local PartsList         = {}
		local BlursList         = {}
		local BlurObjects       = {}
		local BlurredGui        = {}

		BlurredGui.__index      = BlurredGui

		local function rayPlaneIntersect(planePos, planeNormal, rayOrigin, rayDirection)
			local n = planeNormal
			local d = rayDirection
			local v = rayOrigin - planePos

			local num = n.x*v.x + n.y*v.y + n.z*v.z
			local den = n.x*d.x + n.y*d.y + n.z*d.z
			local a = -num / den

			return rayOrigin + a * rayDirection, a
		end

		local function rebuildPartsList()
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

		local function updateGui(blurObj)
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

		local self = BlurredGui.new(to_blur, "Rectangle")

		BlurredGui.updateAll()
		
		return {
			Destroy = function()
				BlurredGui.Destroy(self)
			end,
			Update = function()
				BlurredGui.updateAll()
			end,
		}
	end,
	
}

function library:init(data)

	library._internal = {}
	library._internal.latestObject = nil
	library._internal.latestWindow = nil
	library._internal.screen = Instance.new("ScreenGui")


	library._internal.settings = {
		secure = false
	}

	local hasBeenParented = false

	if data then

		if data.secure == true then
			library._internal.settings.secure = data.secure
			
			xpcall(function()
				library._internal.screen.Parent = game:GetService("CoreGui")
				
				if library._internal.screen.Parent == nil then
					hasBeenParented = false
				else
					hasBeenParented = true
				end
			end, function()
				hasBeenParented = false
			end)
			
			if hasBeenParented == false then
				logger.error("secure","Unable to access CoreGui, since secure is enabled execution has been stopped")
			end
			
			misc.blur = function()
				return {
					Destroy = function() end,
					Update = function() end
				}
			end	
		end
	end
	
	if hasBeenParented == false then
		hasBeenParented = true
		library._internal.screen.Parent = localPlayer.PlayerGui
	end
	
	repeat
		task.wait(0.1)
	until
	game:IsLoaded()
end

function library:new_window(data, ...)
	
	local args = {...}
	
	if data ~= nil then
		table.insert(args,data)
	end
	

	local CurrentStyle = {}

	for i, v in pairs({...}) do
		for a,b in pairs(library.Styles) do
			if v == b then
				table.insert(CurrentStyle,v)
			end
		end
	end

	if #CurrentStyle > 1 then
		logger.warn("window_style","Multiple styles used defaulting to style with the index 1")
	elseif #CurrentStyle <= 0 then
		CurrentStyle = {library.Styles.Custom}
	end

	CurrentStyle = CurrentStyle[1]

	local cache = {
		flags = {}
	}

	local function hasFlag(Flag)

		if cache.flags[Flag] then
			return cache.flags[Flag]
		end

		if table.find(args,Flag) then
			cache.flags[Flag] = true
			return true
		end


		cache.flags[Flag] = false
		return false
	end
	
	local load_window = { t = tick(), w = nil, bl = nil}
	
	if data ~= nil then

		if data.loadingWindow ~= nil and data.loadingWindow.Enabled == true then
			local dt = data.loadingWindow

			local lW = misc.Frame()
			load_window.w = lW
			lW.Visible = false
			lW.Parent = library._internal.screen

			lW.Size = misc.table_to_UDIM2({0.234, 0},{0.284, 0})
			lW.Position = UDim2.new(0.5,0,0.5,0)
			lW.AnchorPoint = Vector2.new(0.5,0.5)

			misc.UiCorner({0.036, 0}).Parent = lW
			local winAR = misc.UiAspectRatio(1.648)
			winAR.Parent = lW
			load_window.s = winAR

			lW.BackgroundTransparency = misc.get_color(library.theme.bg_primary)[2]
			lW.BackgroundColor3 = misc.get_color(library.theme.bg_primary)[1]

			local win_dec = misc.Frame()
			win_dec.Parent = lW
			win_dec.Size = misc.table_to_UDIM2({1, 0},{1, 0})
			misc.UiCorner({0.036,0},win_dec)
			local uigrad_dec = misc.UiGradient(win_dec)
			uigrad_dec.Rotation = -90
			uigrad_dec.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
			uigrad_dec.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.75)})

			local TitleLabel = misc.Label(dt.Title or "Quartz UI",lW)

			TitleLabel.TextScaled = true
			TitleLabel.BackgroundTransparency = 1
			TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
			TitleLabel.FontFace = NewFont(Enum.FontWeight.Bold,Enum.FontStyle.Normal)
			TitleLabel.TextTransparency = misc.get_color(library.theme.text_primary)[2]
			TitleLabel.TextColor3 = misc.get_color(library.theme.text_primary)[1]

			TitleLabel.Size = misc.table_to_UDIM2({0.576, 0},{0.204, 0})
			TitleLabel.Position = misc.table_to_UDIM2({0.039, 0},{0.089, 0})

			local Subtitle = misc.Label(dt.Subtitle or "UI Framework",lW)

			Subtitle.TextScaled = true
			Subtitle.BackgroundTransparency = 1
			Subtitle.TextXAlignment = Enum.TextXAlignment.Left

			Subtitle.TextTransparency = misc.get_color(library.theme.text_secondary)[2]
			Subtitle.TextColor3 = misc.get_color(library.theme.text_secondary)[1]

			Subtitle.Size = misc.table_to_UDIM2({0.576, 0},{0.138, 0})
			Subtitle.Position = misc.table_to_UDIM2({0.039, 0},{0.26, 0})

			local versionlabel = misc.Label(dt.Version or "v1.0.0",lW)

			versionlabel.TextScaled = true
			versionlabel.BackgroundTransparency = 1
			versionlabel.TextXAlignment = Enum.TextXAlignment.Right

			versionlabel.TextTransparency = misc.get_color(library.theme.text_tertiary)[2]
			versionlabel.TextColor3 = misc.get_color(library.theme.text_tertiary)[1]

			versionlabel.Size = misc.table_to_UDIM2({0.576, 0},{0.114, 0})
			versionlabel.Position = misc.table_to_UDIM2({0.378, 0},{0.795, 0})
			
			if hasFlag(library.Flags.NoAnimations) == false then
				local vT = versionlabel.TextTransparency
				local sT = Subtitle.TextTransparency
				local tT = TitleLabel.TextTransparency
				local wT = lW.BackgroundTransparency
				local wdT = win_dec.BackgroundTransparency
								
				TitleLabel.TextTransparency = 1
				versionlabel.TextTransparency = 1
				Subtitle.TextTransparency = 1
				win_dec.BackgroundTransparency = 1
				lW.BackgroundTransparency = 1
				
				local t1 = tweenService:Create(versionlabel,TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),{TextTransparency=vT})
				local t2 = tweenService:Create(Subtitle,t1.TweenInfo,{TextTransparency=sT})
				local t3 = tweenService:Create(TitleLabel,t1.TweenInfo,{TextTransparency=tT})

				local t4 = tweenService:Create(lW,t1.TweenInfo,{BackgroundTransparency=wT})
				local t5 = tweenService:Create(win_dec,t1.TweenInfo,{BackgroundTransparency=wdT})
				
				lW.Visible = true

				t1:Play(); t2:Play(); t3:Play(); t4:Play(); t5:Play()
				
			end
			
			load_window.bl = misc.blur(lW)	
			lW.Visible = true

		end

	end
	
	local window = misc.Frame()
	window.Visible = false
	window.Parent = library._internal.screen
	
	window.Size = misc.table_to_UDIM2({0.506, 0},{0.651, 0})
	window.Position = UDim2.new(0.5,0,0.5,0)
	window.AnchorPoint = Vector2.new(0.5,0.5)
	window.ZIndex = -2
	
	misc.blur(window)
	misc.UiCorner({0.036, 0})
	local winAR = misc.UiAspectRatio(1.561)
	winAR.Parent = window
	
	local ustr = misc.UiStroke(window)
	ustr.Color = misc.get_color(library.theme.stroke_primary)[1]
	ustr.Transparency = misc.get_color(library.theme.stroke_primary)[2]
	ustr.Thickness = 2
	
	window.BackgroundTransparency = misc.get_color(library.theme.bg_primary)[2]
	window.BackgroundColor3 = misc.get_color(library.theme.bg_primary)[1]
	library._internal.latestWindow = window
	
	local win_dec = misc.Frame()
	win_dec.ZIndex = -1
	win_dec.Parent = window
	win_dec.Size = misc.table_to_UDIM2({1, 0},{1, 0})
	misc.UiCorner({0.036,0},win_dec)
	local uigrad_dec = misc.UiGradient(win_dec)
	uigrad_dec.Rotation = -90
	uigrad_dec.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
	uigrad_dec.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.75)})
	
	local topbar = misc.Frame()

	topbar.ZIndex = 9999999
	
	topbar.Parent = window
	topbar.Size = misc.table_to_UDIM2({1, 0},{0.071, 0})
	topbar.Position = misc.table_to_UDIM2({0, 0},{0, 0})
	topbar.BackgroundTransparency = 1
	
	local topbar_button_holder = misc.Frame()
	

	topbar_button_holder.ZIndex = 9999999
	topbar_button_holder.Parent = topbar
	topbar_button_holder.Size = misc.table_to_UDIM2({0.194, 0},{1, 0})
	topbar_button_holder.BackgroundTransparency = 1
	
	local x_btn = misc.Button(topbar_button_holder)
	x_btn.BackgroundColor3 = Color3.fromRGB(252, 82, 85)
	x_btn.Text = ""
	x_btn.ZIndex = 9999999
	x_btn.LayoutOrder = 1
	x_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	misc.UiAspectRatio(1,x_btn)
	misc.UiCorner({1,0},x_btn)
	
	local fullscreen_btn = misc.Button(topbar_button_holder)
	fullscreen_btn.BackgroundColor3 = Color3.fromRGB(44, 191, 77)
	fullscreen_btn.Text = ""
	fullscreen_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	fullscreen_btn.LayoutOrder = 3
	fullscreen_btn.ZIndex = 9999999
	misc.UiAspectRatio(1,fullscreen_btn)
	misc.UiCorner({1,0},fullscreen_btn)
	
	local minimize_btn = misc.Button(topbar_button_holder)
	minimize_btn.BackgroundColor3 = Color3.fromRGB(245, 193, 7)
	minimize_btn.LayoutOrder = 2
	minimize_btn.Text = ""
	minimize_btn.Size = misc.table_to_UDIM2({0.5, 0},{0.5, 0})
	misc.UiAspectRatio(1,minimize_btn)
	misc.UiCorner({1,0},minimize_btn)
	minimize_btn.ZIndex = 9999999
	
	local padding = misc.UiPadding(topbar_button_holder)
	padding.PaddingLeft = UDim.new(0.06, 0)
	padding.PaddingTop = UDim.new(0.1, 0)
	
	local ULL = misc.UiListLayout(topbar_button_holder)
	ULL.VerticalAlignment = Enum.VerticalAlignment.Center
	ULL.Padding = UDim.new(0.06, 0)
	ULL.FillDirection = Enum.FillDirection.Horizontal
	ULL.SortOrder = Enum.SortOrder.LayoutOrder

	if load_window.w ~= nil then
		
		local dur = data.loadingWindow.minLoadTime or  3
		
		if tick()-load_window.t <= dur then
			task.wait(math.clamp( ( dur - (tick()-load_window.t) ),0,dur+5))
		end
		
		if hasFlag(library.Flags.NoAnimations) == true then
			load_window.w.Visible = false
			window.Visible = true
			load_window.bl.Update()
			load_window.bl:Destroy()
			load_window.w:Destroy()
		else
			local t1 = tweenService:Create(load_window.w,TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),{Size=window.Size,Position=window.Position})
			local t2 = tweenService:Create(load_window.s,t1.TweenInfo,{AspectRatio=winAR.AspectRatio})
			
			for i, v in pairs(load_window.w:GetDescendants()) do
				if v:IsA("TextLabel") then
					v.Transparency = 1
					--tweenService:Create(v,TweenInfo.new(t1.TweenInfo.Time*1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{TextTransparency=1}):Play()
				end
			end
			
			t1:Play()
			t2:Play()
			t1.Completed:Wait()
			window.Visible = true
			load_window.w.Visible = false
			load_window.w:Destroy()
		end
		
	end
	
	window.Visible = true
	
	local hooks = {
		buttons = {
			close_btn = {},
			minimize_btn = {},
			maximize_btn = {},
		}
	}

	local to_return = {
		hooks = {
			buttons = {
				close_btn = {
					Connect = function(self,name,func)
						local a = x_btn.Activated:Connect(func)

						hooks.buttons.close_btn[name] = a

						return a
					end,

					Disconnect = function(self,name)
						if hooks.buttons.close_btn[name] ~= nil then
							hooks.buttons.close_btn[name]:Disconnect()
						else
							logger.warn("close_btn",`No hook named {name}`)
						end
					end,
				},
				minimize_btn = {
					Connect = function(self,name,func)
						local a = minimize_btn.Activated:Connect(func)

						hooks.buttons.minimize_btn[name] = a

						return a
					end,

					Disconnect = function(self,name)
						if hooks.buttons.minimize_btn[name] ~= nil then
							hooks.buttons.minimize_btn[name]:Disconnect()
						else
							logger.warn("minimize_btn",`No hook named {name}`)
						end
					end,
				},
				maximize_btn = {
					Connect = function(self,name,func)
						local a = fullscreen_btn.Activated:Connect(func)

						hooks.buttons.maximize_btn[name] = a

						return a
					end,

					Disconnect = function(self,name)
						if hooks.buttons.maximize_btn[name] ~= nil then
							hooks.buttons.maximize_btn[name]:Disconnect()
						else
							logger.warn("maximize_btn",`No hook named {name}`)
						end
					end,
				}
			}
		}
	}
	
	if hasFlag(library.Styles.Dashboard) then
		local sidebar = misc.Frame()
		
		sidebar.BackgroundTransparency = misc.get_color(library.theme.bg_secondary)[2]
		sidebar.BackgroundColor3 = misc.get_color(library.theme.bg_secondary)[1]
		
		sidebar.Parent = window
		sidebar.Size = misc.table_to_UDIM2({0.294, 0},{1.002, 0})
		sidebar.Position = misc.table_to_UDIM2({0, 0},{0, 0})
		
		local gradUi = misc.UiGradient(sidebar)
		gradUi.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
		gradUi.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.381),NumberSequenceKeypoint.new(1,0.681)})
		
		misc.UiCorner({0.1,0},sidebar)
		
		misc.UiAspectRatio(0.458,sidebar)
		
		misc.UiPadding(sidebar).PaddingTop = UDim.new(0.1,0)
		
		local lsa = misc.UiListLayout(sidebar)
		lsa.HorizontalAlignment = Enum.HorizontalAlignment.Center
		lsa.Padding = UDim.new(0.05,0)
		
		library._internal.style = {}
		library._internal.style.sidebar = sidebar
		library._internal.style.sidebar_sel = nil
	end
	
	to_return.Button = function(self,Text,Variant)
		local btn = misc.Button()
		
		Variant = Variant or library.Components.Button.Primary
		
		btn.Text = Text or "Button"
		
		local rtrn = {}
		rtrn.structure = {btn=btn}
		
		if Variant == library.Components.Button.Primary then
			btn.BackgroundColor3 = misc.get_color(library.theme.button_primary)[1]
			btn.BackgroundTransparency = misc.get_color(library.theme.button_primary)[2]
			btn.TextScaled = true

			btn.TextTransparency = misc.get_color(library.theme.button_primary_text)[2]
			btn.TextColor3 = misc.get_color(library.theme.button_primary_text)[1]
			
			local grad1 = misc.UiGradient(btn)
			grad1.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
			grad1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0)})
			
			local str = misc.UiStroke(btn)
			str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			str.Color = misc.get_color(library.theme.button_primary_stroke)[1]
			str.Transparency = misc.get_color(library.theme.button_primary_stroke)[2]
			str.Thickness = 1
			
			local fr = Instance.new("Frame",btn)
			fr.BackgroundColor3 = Color3.fromRGB(255,255,255)
			fr.Size = misc.table_to_UDIM2({1,0},{1,0})
			fr.Position = UDim2.new(0,0,0,0)

			local uicorn = misc.UiCorner({0.25,0},btn)
			uicorn:Clone().Parent = fr
			
			local cak = misc.UiGradient(fr)
			cak.Color = ColorSequence.new(
				{
					ColorSequenceKeypoint.new(0,misc.get_color(library.theme.button_primary_highlight)[1]),
					ColorSequenceKeypoint.new(1,misc.get_color(library.theme.button_primary_highlight)[1])})
			cak.Rotation = 90
			cak.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,misc.get_color(library.theme.button_primary_highlight)[2]),NumberSequenceKeypoint.new(1,1)})
			
			-- return
			
			rtrn.structure.stroke = str
			rtrn.structure.outerGradient = grad1
			rtrn.structure.innerFrame = fr
			rtrn.structure.innerGradient = cak
		elseif Variant == library.Components.Button.Secondary then
			btn.BackgroundColor3 = misc.get_color(library.theme.button_secondary)[1]
			btn.BackgroundTransparency = misc.get_color(library.theme.button_secondary)[2]
			btn.TextTransparency = misc.get_color(library.theme.button_secondary_text)[2]
			btn.TextColor3 = misc.get_color(library.theme.button_secondary_text)[1]
			btn.TextScaled = true
			
			misc.UiCorner({0.25, 0},btn)
			
			local str = misc.UiStroke(btn)
			str.Color = misc.get_color(library.theme.button_secondary_stroke)[1]
			str.Transparency = misc.get_color(library.theme.button_secondary_stroke)[2]
			str.Thickness = 1
			str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			
			-- return	
			rtrn.structure.stroke = str
			
		else
			logger.error("Components","Unknown component variant "..tostring(Variant))
			return rtrn
		end
		
		return rtrn
	end

	to_return.Tab = function(self,Title)
		if hasFlag(library.Styles.Custom) == true then
			logger.error("styles","Using custom style, no tab could be created")
			return
		elseif hasFlag(library.Styles.Dashboard) then
			local sidebar = library._internal.style.sidebar
			
			local a = to_return:Button(Title,library.Components.Button.Secondary)
			a.structure.btn.Parent = sidebar
			a.structure.btn.Size = misc.table_to_UDIM2({0.787, 0},{0.068, 0})
			
			if library._internal.style.sidebar_sel == nil then
				library._internal.style.sidebar_sel = a.structure.btn
			else
				a.structure.stroke.Enabled = false
				a.structure.btn.BackgroundTransparency = misc.get_color(library.theme.button_secondary_deselected)[2]
				a.structure.btn.BackgroundColor3 = misc.get_color(library.theme.button_secondary_deselected)[1]

				a.structure.btn.TextTransparency = misc.get_color(library.theme.button_secondary_text_deselected)[2]
				a.structure.btn.BackgroundColor3 = misc.get_color(library.theme.button_secondary_text_deselected)[1]

				a.structure.stroke.Color = misc.get_color(library.theme.button_secondary_stroke_deselected)[1]
				a.structure.stroke.Transparency = misc.get_color(library.theme.button_secondary_stroke_deselected)[2]
			end
		end
	end
	
	if hasFlag(library.Flags.NoDrag) == false then
		misc.add_drag(topbar,window)
	end

	if hasFlag(library.Flags.NoResize) == false then
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
	
	return to_return
end

return library
