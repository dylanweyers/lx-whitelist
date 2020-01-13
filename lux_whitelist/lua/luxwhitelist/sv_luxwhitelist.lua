//-- Read the config file

//-- Some definitions for my script to work

util.AddNetworkString( "lx_wlist_noti" )
util.AddNetworkString( "cl_request_wlist_refresh" )
util.AddNetworkString( "open_wlist_menu" )
util.AddNetworkString( "cl_request_whitelist" )

//-- Lux Whitelist Functions

--SET UP SQL TABLE IF NOT ALREADY DONE
local function lux_wlist_createtables()
	if not sql.TableExists( "luxwhitelist" ) or not sql.TableExists( "luxwhitelist_settings" ) then
		MsgC( Color( 255, 0, 0 ), "LuxWhitelist Data Tables don't exist!\n", Color(65,65,155), "Attempting to create...\n" )
		sql.Query( "CREATE TABLE luxwhitelist( Steamid TEXT, Job TEXT, Whitelister TEXT )" )
		sql.Query( "CREATE TABLE luxwhitelist_settings( Setting TEXT, Value TEXT ) ")
		if sql.TableExists( "luxwhitelist" ) and sql.TableExists( "luxwhitelist_settings" ) then
			MsgC( Color( 65, 65, 220), "LuxWhitelist Data Tables created!\n")
		end
	end
end

--NOTIFY PLAYER
local function lux_wlist_notify( ply, tx, col )
	if not ply then
		return
	end
	if not tx then
		return
	end
	if not col then
		col = Color(255,255,255)
	end
	net.Start( "lx_wlist_noti" )
		net.WriteString( tx )
		net.WriteColor( col )
	net.Send( ply )
end

--UTILITY FUNCTION TO FIND JOB AND RETURN COMMAND/NAME OF JOB
local function lux_wlist_findjob(job,ret)
	if not job then return end
	for k, v in pairs(RPExtraTeams) do
		if v.name == job or string.find(string.lower(v.name), string.lower(job)) or v.command == job or v.jobvar and v.jobvar == job then
			if not ret or ret == "cmd" then
				ret = v.command
			elseif ret == "name" then
				ret = v.name
			end
			return ret
		end
	end
	return false
end

--FIND PLAYER
local function lux_wlist_findply( ply, ret )
	if not ply then
		return
	end
	if tonumber( ply ) and isnumber( tonumber( ply ) ) then
		return ply
	elseif string.find( string.upper(ply), "STEAM_" ) then
		return util.SteamIDTo64( string.upper(ply) )
	elseif isentity(ply) or not string.find( ply, "STEAM_" ) and not isnumber( ply ) then
		for k, v in pairs( player.GetAll() ) do 
			if string.find( string.lower( v:GetName() ), string.lower( ply ) ) then
				if not ret or ret == "ent" then
					return v
				elseif ret == "name" then
					return v:GetName()
				end
			end
		end
	end
end

--RETURN WHETHER OR NOT PLAYER IS WHITELISTED TO JOB
local function lux_whitelisted( ply, job )
	local tempdat = sql.Query( "SELECT Job FROM luxwhitelist WHERE Steamid = "..ply:SteamID64() )
	if not tempdat then return end
	for k,v in pairs(tempdat) do
		if v.Job == job then
			return true
		end
	end
	return false
end

--ADD PLAYER TO WHITELIST
local function lux_add_whitelist( whitelister, ply, job )
	if not whitelister or not table.HasValue( luxwlist.config.ranks, whitelister:GetUserGroup() ) or not ply or not job then
		return
	end
	local sid64
	local plyname
	if isentity(ply) then
		sid64 = tostring(ply:SteamID64()) 
	elseif tonumber(ply) then
		sid64 = tostring(ply)
		ply = player.GetBySteamID64(sid64)
	elseif string.find(ply, "STEAM_") then
		sid64 = tostring(util.SteamIDTo64(ply))
		ply = player.GetBySteamID64(sid64)
	end 
	
	local lx_rpname = sql.Query( "SELECT rpname FROM darkrp_player WHERE uid='"..sid64.."'" )
	if lx_rpname then
		plyname = lx_rpname[1].rpname
	end
	job = lux_wlist_findjob(job)
	if job == false then 
		return
	end
	local tempdat = sql.Query( "SELECT Job FROM luxwhitelist WHERE Steamid='"..sid64.."' AND Job='"..job.."'" )
	local alreadywhitelisted = false
	if tempdat then
		for k, v in pairs( tempdat ) do
			if v.Job == job then
				alreadywhitelisted = true
				lux_wlist_notify( whitelister, "'"..plyname.."' is already whitelisted to this job!", Color(185,25,25) )
				return
			end
		end
	end
	sql.Query("INSERT INTO luxwhitelist( Steamid, Job ) VALUES( '"..sid64.."', '"..job.."')")
	local jobname = lux_wlist_findjob(job,"name")
	lux_wlist_notify( whitelister, "You whitelisted "..plyname.." to "..jobname..".", Color(25,195,25) )
	lux_wlist_notify( ply, "You were whitelisted to "..jobname.." by "..whitelister:GetName() or nil..".", Color(25,195,25) )
end

--REMOVE PLAYER FROM WHITELIST
local function lux_remove_whitelist( unwhitelister, ply, job )
	if not unwhitelister or not table.HasValue( luxwlist.config.ranks, unwhitelister:GetUserGroup() ) or not ply or not job then
		return
	end
	local sid64
	local plyname
	if isentity(ply) then
		sid64 = tostring(ply:SteamID64()) 
	elseif tonumber(ply) then
		sid64 = tostring(ply)
		ply = player.GetBySteamID64(sid64)
	elseif string.find(ply, "STEAM_") then
		sid64 = tostring(util.SteamIDTo64(ply))
		ply = player.GetBySteamID64(sid64)
	end 
	local lx_rpname = sql.Query( "SELECT rpname FROM darkrp_player WHERE uid='"..sid64.."'" )
	if lx_rpname then
		plyname = lx_rpname[1].rpname
	end
	local job = lux_wlist_findjob(job)
	local tempdat = sql.Query( "SELECT Job FROM luxwhitelist WHERE Steamid="..sid64 )
	if tempdat then
		for k, v in pairs(tempdat) do
			if v.Job == job then
				sql.Query( "DELETE FROM luxwhitelist WHERE Steamid='"..sid64.."' AND Job='"..job.."'")
				local jobname = lux_wlist_findjob(job,"name")
				lux_wlist_notify( unwhitelister, "You unwhitelisted "..plyname.." from "..jobname..".", Color(195,25,25) )
				lux_wlist_notify( ply, "You were unwhitelisted from "..jobname.." by "..unwhitelister:GetName()..".", Color(195,25,25) )
				return
			end
		end
		lux_wlist_notify( unwhitelister, "'"..plyname.."' can't be removed if they weren't whitelisted in the first place.", Color( 195, 25, 25 ) )
		return
	end
end

--FUNCTION TO UPDATE WHITELIST'S JOBS (MOSTLY FOR IF CONFIG GETS CHANGED, NEED TO REVERT THE WHITELIST CUSTOMCHECK)
local function lux_wlist_refresh()
	if luxwlist.config.enabled == true then
		for k, v in pairs( RPExtraTeams ) do
			if table.HasValue( luxwlist.config.ignores, v.name ) then
				v.customCheck = nil
				continue
			end
			v.customCheck = function(ply) return lux_whitelisted( ply, v.command ) end
			v.CustomCheckFailMsg = "You are not whitelisted to "..v.name.."!"
		end
	end
	if luxwlist.config.enabled == false then
		for k, v in pairs(RPExtraTeams) do
			v.customCheck = nil
		end
	end
end
//-- Hooks

hook.Add( "Initialize", "create_luxwhitelist_tables", lux_wlist_createtables )

hook.Add( "InitPostEntity", "luxwhitelist_insert_customchecks", lux_wlist_refresh )

hook.Add("PlayerSay", "lux_whitelist_cmd", function(ply,tex)
	if string.sub(string.lower(tex),1,#luxwlist.config.cmd) == string.lower(luxwlist.config.cmd) and table.HasValue( luxwlist.config.ranks, ply:GetUserGroup() ) then
		local args = string.Explode(" ", tex)
		if not args[2] and not args[3] then
			net.Start( "open_wlist_menu" )
			net.Send( ply )
			return
		end
		PrintTable(args)
		if not lux_wlist_findply( args[2] ) or string.len(tostring(args[3])) <= 2 then 
			lux_wlist_notify( ply, "Failed to find player or job. Try using the menu if this occurs again.", Color( 195, 25, 25 ) )
			return
		end
		lux_add_whitelist( ply, lux_wlist_findply( args[2], "ent" ), args[3] )
	end
end )

hook.Add("PlayerSay", "lux_whitelist_uncmd", function(ply,tex)
	if string.sub(string.lower(tex),1,#luxwlist.config.uncmd) == string.lower(luxwlist.config.uncmd) and table.HasValue( luxwlist.config.ranks, ply:GetUserGroup() ) then
		local args = string.Explode(" ", tex)
		if not args[2] or not lux_wlist_findply( args[2] ) or not args[3] or string.len(args[3]) < 2 then 
			lux_wlist_notify( ply, "Failed to find player or job. Try using the menu if this occurs again.", Color( 195, 25, 25 ) )
			return
		end
		lux_remove_whitelist( ply, lux_wlist_findply( args[2] ), args[3] )
	end
end )

net.Receive( "cl_request_wlist_refresh", lux_wlist_refresh )

net.Receive( "cl_request_whitelist", function( len, whitelister )
	local act = net.ReadString()
	local ply = net.ReadEntity()
	local job = net.ReadString()
	if act == "add" then
		lux_add_whitelist( whitelister, ply, job )
	elseif act == "remove" then
		lux_remove_whitelist( whitelister, ply, job )
	end
end ) 

print(sql.LastError())