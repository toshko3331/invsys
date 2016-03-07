//Client-side file for inventory system.
inventory.invTable = {}

function inventory.ServerInventoryUpdate( len )
	inventory.invTable = net.ReadTable()-- We may need to reverse the order of all the entries depending
	-- if the order is swaped around.
end
net.Receive( "SetClientInventory", inventory.ServerInventoryUpdate )