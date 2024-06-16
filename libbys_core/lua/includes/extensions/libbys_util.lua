local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local xpcall = xpcall

local function PrintCallbackError(message)
	ErrorNoHaltWithStack(message)
end

function util.SafeCallback(callback, ...)
	xpcall(callback, PrintCallbackError, ...)
end
