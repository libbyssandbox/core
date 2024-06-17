AddCSLuaFile()

local rawget = rawget
local rawset = rawset

module("libbys.modules", package.seeall)

ModuleList = {}

local ModuleEnvironmentMeta = {
	-- A touch more compliacted than I'd like it to be
	__index = function(self, key)
		return rawget(self._MODULE, key) or _G[key]
	end,

	__newindex = function(self, key, value)
		rawset(self._MODULE, key, value)
	end
}

local ModuleMeta = include("includes/libbys_module_meta.lua")

function libbys:StartModule(name)
	name = string.ToPascalKey(name)

	if istable(self.modules.ModuleList[name]) then
		FormatErrorNoHalt("Re-defining module %s", name)
	end

	local NewModule = setmetatable({}, ModuleMeta)
	local NewModuleEnvironment = setmetatable({}, ModuleEnvironmentMeta)

	rawset(NewModuleEnvironment, "self", NewModule) -- A little dangerous
	rawset(NewModuleEnvironment, "_MODULE", NewModule)
	rawset(NewModuleEnvironment, "_MODULE_NAME", Name)

	self.modules.ModuleList[name] = NewModule

	NewModule:Init()

	setfenv(2, NewModuleEnvironment)
end

function libbys:FinishModule() -- Needed because calling :Setup from :StartModule will make the module init before its functions are defined
	local ModuleEnvironment = getfenv(2)

	if not istable(ModuleEnvironment) or not istable(ModuleEnvironment._MODULE) then
		error("Attempt to call 'FinishModule' outside of module context")
	end

	ModuleEnvironment._MODULE:Setup(ModuleEnvironment._MODULE_NAME)

	setfenv(2, _G)
end
