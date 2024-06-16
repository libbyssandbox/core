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
