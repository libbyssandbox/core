local Angle = Angle
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local isvector = isvector
local tobool = tobool
local tonumber = tonumber
local tostring = tostring
local xpcall = xpcall

local function PrintCallbackError(message)
	ErrorNoHaltWithStack(message)
end

function util.SafeCallback(callback, ...)
	xpcall(callback, PrintCallbackError, ...)
end

function util.ForceType(value, force)
	if force == FORCE_STRING then
		return tostring(value)
	elseif force == FORCE_NUMBER then
		return tonumber(value) or 0
	elseif force == FORCE_BOOL then
		return tobool(value)
	elseif force == FORCE_ANGLE then
		return Angle(value)
	elseif force == FORCE_COLOR then
		if isvector(value) then
			return value:ToColor()
		else
			return string.ToColor(tostring(value))
		end
	elseif force == FORCE_VECTOR then
		if IsColor(value) then
			return value:ToVector()
		else
			return Vector(value)
		end
	else
		return value
	end
end
