AddCSLuaFile()

local ConfigObject = include("includes/libbys_config_object.lua")

local MODULE = {}
MODULE.__index = MODULE

AccessorFunc(MODULE, "m_strName", "Name", FORCE_STRING)
AccessorFunc(MODULE, "m_bEnabled", "Enabled_Internal", FORCE_BOOL)

function MODULE:Init()
	self:ConfigInit()
end

function MODULE:Setup(name)
	self:SetName(name)
	self:SetEnabled(true)
end

function MODULE:OnEnabled()
	-- For override
end

function MODULE:OnDisabled()
	-- For override
end

function MODULE:SetEnabled(status)
	self:SetEnabled_Internal(status)

	util.SafeCallback(self:GetEnabled_Internal() and self.OnEnabled or self.OnDisabled, self)
end
MODULE.GetEnabled = MODULE.GetEnabled_Internal

return setmetatable(MODULE, ConfigObject)
