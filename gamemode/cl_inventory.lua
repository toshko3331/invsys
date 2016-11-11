//Client-side file for inventory system.
inventory = {}
inventory.invTable = {}

function inventory.HandleFullInvUpdate()
	inventory.invTable = net.ReadTable()
end
net.Receive( "FullInvUpdate",inventory.HandleFullInvUpdate )

function inventory.HandleAddItem()
	local item = net.ReadString()
	local slot = net.ReadInt( 32 )
	inventory.invTable[slot] = item
end
net.Receive( "ItemAdd", inventory.HandleAddItem )

function inventory.PrintInvTable()
	PrintTable(inventory.invTable)
end
concommand.Add( "print_invTable",inventory.PrintInvTable ) 

