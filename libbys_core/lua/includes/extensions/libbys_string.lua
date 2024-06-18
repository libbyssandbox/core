AddCSLuaFile()

local string = string

local function DoTitleCase(first, rest)
	return string.upper(first) .. rest
end

function string.ToTitleCase(str)
	str = string.Trim(str)
	str = string.gsub(str, "[^%w]", "")

	return string.gsub(str, "(%a)([%w_']*)", DoTitleCase)
end

function string.ToPascalKey(str)
	str = string.ToTitleCase(str)

	return string.gsub(str, "[^%a]", "")
end

function string.ToSnakeKey(str)
	str = string.Trim(str)
	str = string.lower(str)
	str = string.Replace(str, " ", "_")

	return string.gsub(str, "[^%a_]", "")
end

function string.ToIndex(str)
	local SourceFenv = getfenv(2)
	setfenv(1, SourceFenv)

	local Result, LastKey, LastLocation
	local Blocks = string.Split(str, ".")

	for i = 1, #Blocks do
		local LastResult = Result or SourceFenv

		Result = LastResult[Blocks[i]]

		if Result == nil then
			return nil
		end

		LastKey = Blocks[i]
		LastLocation = LastResult
	end

	return Result, LastKey, LastLocation
end
