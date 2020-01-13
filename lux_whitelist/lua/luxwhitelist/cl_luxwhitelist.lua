surface.CreateFont( "whitelist_30", {
	font = "Roboto Lt", 
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "whitelist_18", {
	font = "Roboto Lt", 
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local function lux_wlist_receivenoti( len, ply )
	local msg = net.ReadString()
	local col = net.ReadColor()
	chat.AddText(col,msg)
end
net.Receive( "lx_wlist_noti", lux_wlist_receivenoti )

local function luxmenu_jobs(nam,guy)
	if not lx_main or not ValidPanel(lx_main) then
		return
	end
	if luxjobz and ValidPanel(luxjobz) then
		luxjobz:Close()
	end

	luxjobz = vgui.Create("DFrame", lx_main)
	luxjobz:SetSize( 1001, 700 )
	luxjobz:SetPos( 249, 50 )
	luxjobz:SetDraggable(false)
	luxjobz:SetTitle("")
	luxjobz:ShowCloseButton(false)
	luxjobz.Paint = function()
	end

	local blockdock = vgui.Create("DLabel", luxjobz)
	blockdock:SetSize(1000, 25)
	blockdock:SetText("")
	blockdock.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(222,222,222))
		draw.SimpleText(nam.."'s whitelist settings", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	local luxjobs = vgui.Create( "DScrollPanel", luxjobz )
	luxjobs:Dock( FILL )
	luxjobs.Paint = function(self,w,h)
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	local jobsbar = luxjobs:GetVBar()
	function jobsbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function jobsbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0 ) )
		draw.SimpleText("▲", "whitelist_18", self:GetWide()/2, self:GetTall()/2-2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function jobsbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0 ) )
		draw.SimpleText("▼", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function jobsbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 36,36,36 ) )
		draw.SimpleText("↕", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	table.sort(RPExtraTeams, function(a,b) return string.lower(a.name) < string.lower(b.name) end)
	for k, v in pairs(RPExtraTeams) do
		if table.HasValue(luxwlist.config.ignores, v.name ) then 
			continue
		end
		lx_jobp = vgui.Create("DPanel", luxjobs)
		lx_jobp:Dock( TOP )
		lx_jobp:DockMargin(5,5,5,2)
		lx_jobp.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(222,222,222))
			if self:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
			end
			draw.SimpleText( v.name, "whitelist_18", 10, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			surface.SetDrawColor(65,65,255)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		local lx_jobA = vgui.Create("DButton", lx_jobp)
		lx_jobA:SetText("")
		lx_jobA:SetSize(125,25)
		lx_jobA:SetPos(700)
		lx_jobA.Paint = function(self,w,h)
			draw.SimpleText("Add to whitelist", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(65,65,255)
			surface.DrawOutlinedRect(0,0,w,h)
			if self:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(35,185,35,45))
				draw.SimpleText("Add to whitelist", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(35,185,35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetDrawColor(35,185,35)
				surface.DrawOutlinedRect(0,0,w,h)
			end
		end
		lx_jobA.DoClick = function()
			net.Start("cl_request_whitelist")
				net.WriteString("add")
				net.WriteEntity(guy)
				net.WriteString(v.command)
			net.SendToServer()
		end
		local lx_jobR = vgui.Create("DButton", lx_jobp)
		lx_jobR:SetText("")
		lx_jobR:SetSize(155,25)
		lx_jobR:SetPos(825)
		lx_jobR.Paint = function(self,w,h)
			draw.SimpleText("Remove from whitelist", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetDrawColor(65,65,255)
			surface.DrawOutlinedRect(0,0,w,h)
			if self:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(215,35,35,35))
				draw.SimpleText("Remove from whitelist", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(215,35,35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				surface.SetDrawColor(215,35,35)
				surface.DrawOutlinedRect(0,0,w,h)
			end
		end
		lx_jobR.DoClick = function()
			net.Start("cl_request_whitelist")
				net.WriteString("remove")
				net.WriteEntity(guy)
				net.WriteString(v.command)
			net.SendToServer()
		end
	end
end
local function lux_open_wlist()
	lx_main = vgui.Create( "DFrame" )
	lx_main:SetSize( 1250, 750 )
	lx_main:MakePopup()
	lx_main:Center()
	lx_main:SetTitle("")
	lx_main:ShowCloseButton(false)
	lx_main.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(27,27,27,245))
		draw.RoundedBox(0,0,0,w,50,Color(222,222,222))
		draw.SimpleText("Lux Whitelist", "whitelist_30", self:GetWide()/2, 25, Color( 65, 65, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	local lx_close = vgui.Create( "DButton", lx_main )
	lx_close:SetText("")
	lx_close:SetSize(25,15)
	lx_close:SetPos(lx_main:GetWide()-lx_close:GetWide()-1,1)
	lx_close.DoClick = function()
		lx_main:Close()
	end
	lx_close.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(255,0,0))
	end

	local lx_left = vgui.Create( "DScrollPanel", lx_main )
	lx_left:SetSize( 250, 700 )
	lx_left:SetPos( 0, 50 )
	lx_left.Paint = function(self,w,h)
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	local lx_bar = lx_left:GetVBar()
	function lx_bar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function lx_bar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0 ) )
		draw.SimpleText("▲", "whitelist_18", self:GetWide()/2, self:GetTall()/2-2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function lx_bar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0 ) )
		draw.SimpleText("▼", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	function lx_bar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 36,36,36 ) )
		draw.SimpleText("↕", "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if self:IsHovered() then
			draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
		end
		surface.SetDrawColor(65,65,255)
		surface.DrawOutlinedRect(0,0,w,h)
	end
	for k, v in ipairs(player.GetAll()) do
		lx_ply = vgui.Create("DButton", lx_left)
		lx_ply:Dock( TOP )
		lx_ply:DockMargin(5,5,5,2)
		lx_ply:SetText("")
		lx_ply.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(222,222,222))
			if self:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(65,65,255,65))
			end
			draw.SimpleText( v:GetName(), "whitelist_18", self:GetWide()/2, self:GetTall()/2, Color(65,65,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			surface.SetDrawColor(65,65,255)
			surface.DrawOutlinedRect(0,0,w,h)
		end
		lx_ply.DoClick = function()
			luxmenu_jobs(v:GetName(),v)
		end
	end
end
net.Receive( "open_wlist_menu", lux_open_wlist )