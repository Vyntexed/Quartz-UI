local RunService = game:GetService("RunService")

local logger = function(Title)
	return {
		error = function(content)
			error(Title..": "..content)
		end,
	}
end

local functions = {
	Linear = function(t)
		return t
	end,
}

local SPRING_TYPE = "Spring"

-- helpers
local helpers = {}
helpers.lerp = function(start, goal, t)
	return start + (goal - start) * t
end
helpers.lerpUDim2 = function(start, goal, t)
	return UDim2.new(
		helpers.lerp(start.X.Scale, goal.X.Scale, t),
		helpers.lerp(start.X.Offset, goal.X.Offset, t),
		helpers.lerp(start.Y.Scale, goal.Y.Scale, t),
		helpers.lerp(start.Y.Offset, goal.Y.Offset, t)
	)
end
helpers.lerpColor3 = function(start, goal, t)
	return Color3.new(
		helpers.lerp(start.R, goal.R, t),
		helpers.lerp(start.G, goal.G, t),
		helpers.lerp(start.B, goal.B, t)
	)
end

local function applyT(Object, Properties, startProps, t)
	for i, v in pairs(Properties) do
		if typeof(v) == "UDim2" then
			Object[i] = helpers.lerpUDim2(startProps[i], v, t)
		elseif typeof(v) == "number" then
			Object[i] = helpers.lerp(startProps[i], v, t)
		elseif typeof(v) == "Color3" then
			Object[i] = helpers.lerpColor3(startProps[i], v, t)
		end
	end
end

return function(self, data): { Play: (self: any) -> () }

	local log = logger("Quartz Motion")

	if data == nil then
		log.error("No data table provided")
	end

	local Type       = data.Type
	local Duration   = data.Duration
	local Properties = data.Properties
	local Object     = data.Object

	local Stiffness  = data.Stiffness or 170
	local Damping    = data.Damping or 26
	local Mass       = data.Mass or 1

	local isSpring = (Type == SPRING_TYPE)

	if not isSpring and functions[Type] == nil then
		log.error(`Use a valid animation type, "{Type}" is not a valid animation type`)
		return
	end

	if not isSpring and Duration == nil then
		log.error("No duration argument was provided")
		return
	end

	if Properties == nil or typeof(Properties) ~= "table" then
		log.error("No properties table provided or invalid properties table provided")
		return
	end

	if Object == nil then
		log.error("No object argument was provided")
	end

	local elapsed = 0
	local conn = nil
	local startProps = {}

	for i in pairs(Properties) do
		startProps[i] = Object[i]
	end
	
	local springPos = 0 
	local springVel = 0

	return {
		Play = function(playSelf)

			elapsed = 0
			springPos = 0
			springVel = 0

			conn = RunService.RenderStepped:Connect(function(dt)

				local t
				local finished = false

				if isSpring then

					local displacement = springPos - 1
					local force = (-Stiffness * displacement) - (Damping * springVel)
					springVel = springVel + (force / Mass) * dt
					springPos = springPos + springVel * dt

					t = springPos

					-- Snap and finish once the spring has effectively settled
					if math.abs(displacement) < 0.001 and math.abs(springVel) < 0.001 then
						t        = 1
						finished = true
					end
				else
					elapsed += dt

					t = functions[Type](
						math.clamp(elapsed / Duration, 0, 1)
					)

					if elapsed >= Duration then
						t        = 1
						finished = true
					end
				end

				applyT(Object, Properties, startProps, t)

				if finished then
					for i, v in pairs(Properties) do
						Object[i] = v
					end
					conn:Disconnect()
				end
			end)
		end,
	}
end
