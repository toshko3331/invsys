--Server-side file for the inventory system.
util.AddNetworkString( "SetClientInventory" )

inventory = { }
inventory.width = 8
inventory.height = 8
inventory.totalSlots = inventory.width * inventory.height

local function CreateInventory()
	sql.Query( "CREATE TABLE inventory( SteamID TEXT UNIQUE)" )
	for i=0,inventory.totalSlots - 1,1 do
		sql.Query( "ALTER TABLE inventory ADD COLUMN '"..i.."' TEXT" )
	end
end

function inventory.InitializeInventory()
	if (sql.Query( "SELECT * FROM inventory" ) == nil) then
		CreateInventory()
		print( "Table initialized!" )
	end
	
end
hook.Add( "Initialize", "Inventory Table Initialization", inventory.InitializeInventory )

function inventory.InitializePlayerInventory( ply )
	-- TEST THIS CODE.

	local steamID = ply:SteamID()

	if sql.QueryValue( "SELECT * FROM inventory WHERE SteamID = '"..steamID.."'" ) == false then
		-- Since the player does not have an inventory, one is created for him in the DB.
		sql.Query("INSERT INTO inventory ( SteamID ) VALUES ( '"..steamID.."' ) " )
		for i=0,inventory.totalSlots - 1,1 do
			sql.Query("UPDATE inventory SET '"..i.."' = '' WHERE SteamID = '"..steamID.."'" )
		end
	end
	-- Prep and send the data to the client.
	local inv = {}
	for i=0,inventory.totalSlots - 1,1 do
		inv[i] = sql.QueryValue( "SELECT '"..i.."' FROM inventory WHERE SteamID = '"..steamID.."'" )
	end
	inventory.SetClientInv( ply,inv )
end
hook.Add( "PlayerInitialSpawn", "Send the inventory to the client.", inventory.InitializePlayerInventory )

function inventory.AddItem()
	--TODO
end

function inventory.RemoveItem()
	--TODO
end

function inventory.SwapItems()
	--TODO
end

function inventory.SetClientInv( ply,inventoryTable )
	net.Start( "SetClientInventory" )
	net.WriteTable( inventoryTable )
	net.Send( ply )	
end