AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Make prop to fall on spawn
	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:Wake() 
	end
end

function ENT:Use( activator, caller )
	if IsValid( caller ) and caller:IsPlayer() then
		local availableSlot = inventory.GetNextAvailableSlot( caller )
		if availableSlot ~= inventory.fullInventory then
			inventory.AddItem( caller,self:GetClass(),availableSlot )
			self:Remove()
		end
	end
end