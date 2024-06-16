AddCSLuaFile()

local error = error
local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local Format = Format

function FormatError(message, ...)
	error(Format(message, ...), 2)
end

function FormatErrorNoHalt(message, ...)
	ErrorNoHaltWithStack(Format(message, ...), 2)
end

function FormatAssert(condition, message, ...)
	if not condition then
		error(Format(message, ...), 2)
	end
end
