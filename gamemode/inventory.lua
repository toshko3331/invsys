-- Potentially add items as JSONs in the table so we can store more data about them such as ammo, power, and other stats. 

--Server-side file for the inventory system.
util.AddNetworkString( "FullInvUpdate" )
util.AddNetworkString( "ItemAdd" )

inventory = { }
inventory.width = 8
inventory.height = 8
inventory.totalSlots = inventory.width * inventory.height
inventory.noItemLiteral = ""
inventory.fullInventory = -1 -- -1 because it expects a number and so -1 is the natural error value.

local function CreateInvTable()
	sql.Query( "CREATE TABLE inventory( SteamID TEXT UNIQUE)" )
	for i=0,inventory.totalSlots - 1,1 do
		sql.Query( "ALTER TABLE inventory ADD COLUMN '"..i.."' TEXT" )
	end
end

function inventory.InitInvTable()

	if not sql.TableExists( "inventory" ) then
		CreateInvTable()
		print( "Table initialized!" )
	end
end
hook.Add( "Initialize","InventoryTableInit",inventory.InitInvTable )

function inventory.InitializePlayerInventory( ply )
	-- TODO: Make more efficient by wrapping the last part in an else and moving the inv = {} out of it and re-writing the logic to avoid doing iterating through the inventory table twice.
	local steamID = ply:SteamID()
	
	if sql.QueryValue( "SELECT * FROM inventory WHERE SteamID = '"..steamID.."'" ) == nil then 
		-- Since the player does not have an inventory, one is created for him in the DB.
		sql.Query("INSERT INTO inventory ( SteamID ) VALUES ( '"..steamID.."' ) " )
		for i=0,inventory.totalSlots - 1,1 do
			sql.Query("UPDATE inventory SET '"..i.."' = '"..inventory.noItemLiteral.."' WHERE SteamID = '"..steamID.."'" )
		end
	end
	-- Prep and send the data to the client.
	local inv = {}
	for i=0,inventory.totalSlots - 1,1 do
		inv[i] = sql.QueryValue( "SELECT \""..i.."\" FROM inventory WHERE SteamID = '"..steamID.."'" )
	end
	hook.Run( "FullInvUpdate",ply,inv )
end
hook.Add( "PlayerInitialSpawn", "PlayerInvInit", inventory.InitializePlayerInventory )

function inventory.AddItem( ply,item,slot )
	-- Checking if the slot is occupied is left to the caller.
	
	local steamID = ply:SteamID()
	-- Does the player have an inventory?
	if sql.QueryValue( "SELECT * FROM inventory WHERE SteamID = '"..steamID.."'" ) == nil then
		print( "Player inventory doesn't exist." )
		return
	end
	
	-- Update the database and send update to client.
	sql.Query("UPDATE inventory SET '"..slot.."' = '"..item.."' WHERE SteamID = '"..steamID.."'")
	hook.Run( "ItemAdd",ply,item,slot )
end

function inventory.RemoveItem()
	--TODO
end

function inventory.SwapItems()
	--TODO
end

function inventory.GetNextAvailableSlot( ply )

	local steamID = ply:SteamID()
	local slot = inventory.fullInventory;
	for i=0,inventory.totalSlots - 1,1 do
		if sql.QueryValue( "SELECT \""..i.."\" FROM inventory WHERE SteamID = '"..steamID.."'" ) == inventory.noItemLiteral then
			slot = i
			break
		end
	end
	return slot
end

hook.Add( "FullInvUpdate", "PlyFullInvUpdate", function ( ply,inventoryTable )
	net.Start( "FullInvUpdate" )
	net.WriteTable( inventoryTable )
	net.Send( ply )	
end )

hook.Add( "ItemAdd", "PlyAddItem", function ( ply,item,slot )
	net.Start( "ItemAdd" )
	net.WriteString( item )
	net.WriteInt( slot,32 )
	net.Send( ply )	
end )