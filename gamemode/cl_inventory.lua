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


function test2()
	-- Gutted the poor DFrame...
	--TODO: Everything. Record everything in variables and build the GUI in such a way so that we can change the dimensions of the frame and everything else will scale accordingly...Yeah gl me in the future.
	local frame = vgui.Create( "DFrame" )
	frame:SetPos( 500, 500 )
	frame:SetSize( 175, 165 )
	frame:SetTitle( "Frame" )
	frame:MakePopup()
	frame.Paint = 
	function()
		surface.SetDrawColor( 54, 35, 28, 255 )
		surface.DrawRect(0,0,frame:GetWide(), frame:GetTall())
		-- draw.RoundedBox( 8, 0, 0, frame:GetWide(), frame:GetTall(), Color( 0, 0, 0, 200 ) )
	end
	frame.btnMaxim:SetVisible( false )
	frame.btnMinim:SetVisible( false )
	frame.PerformLayout = 
	function()

		local titlePush = 0

		if ( IsValid( frame.imgIcon ) ) then

			frame.imgIcon:SetPos( 5, 5 )
			frame.imgIcon:SetSize( 16, 16 )
			titlePush = 16

		end
	
		frame.btnClose:SetPos( frame:GetWide() - 25, 0 )
		frame.btnClose:SetSize( 25, 25 )
		
		frame.lblTitle:SetPos( 8 + titlePush, 2 )
		frame.lblTitle:SetSize( frame:GetWide() - 25 - titlePush, 20 )

	end
	
	frame.btnClose.Paint = 
	function( panel, w, h )
		draw.RoundedBox( 10,0,0,w,h,Color( 30,40,50,255 ) )
		local x, y = frame.btnClose:LocalToScreen( 0, 0 )
		surface.SetDrawColor( 255,240,91,255 )
		surface.DrawLine(10,10,w-10,h-10)
		surface.DrawLine(10,h-10,w-10,10)
	end
    frame.lblTitle:SetTextColor( Color( 194,149,103 ) )

	local grid = vgui.Create( "DGrid", frame )
	grid:SetPos( 10, 30 )
	grid:SetCols( 5 )
	grid:SetColWide( 31 )
	grid:SetRowHeight( 21 )

	for i = 1, 30 do
		local but = vgui.Create( "DPanel" )
		but:SetSize( 31, 21 )
		but.Paint = 
		function()
			surface.SetDrawColor( 20, 12, 9, 255 )
			surface.DrawRect(1,1,but:GetWide()-1, but:GetTall()-1)
			surface.SetDrawColor( 45, 35, 28,255 )
			surface.DrawOutlinedRect( 0,0,but:GetWide(),but:GetTall() )
		-- draw.RoundedBox( 8, 0, 0, frame:GetWide(), frame:GetTall(), Color( 0, 0, 0, 200 ) )
		end
		but.OnCursorEntered = function()
			print("Coooool")		
		end
		grid:AddItem( but )
	end
end
concommand.Add( "GridTest",test2 ) 
