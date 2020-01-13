--[[
//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//
   __              __    __ _     _ _       _ _     _       ___             __ _       
  / / _   ___  __ / / /\ \ \ |__ (_) |_ ___| (_)___| |_    / __\___  _ __  / _(_) __ _ 
 / / | | | \ \/ / \ \/  \/ / '_ \| | __/ _ \ | / __| __|  / /  / _ \| '_ \| |_| |/ _` |
/ /__| |_| |>  <   \  /\  /| | | | | ||  __/ | \__ \ |_  / /__| (_) | | | |  _| | (_| |
\____/\__,_/_/\_\   \/  \/ |_| |_|_|\__\___|_|_|___/\__| \____/\___/|_| |_|_| |_|\__, |
                                                                                 |___/ 
//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//                                                                                 
   _   _ _     ___      _                      ___             __ _                                  _                     _____               ___                     
  /_\ | | |   / __\___ | | ___  _   _ _ __    / __\___  _ __  / _(_) __ _ ___    __ _ _ __ ___    __| | ___  _ __   ___    \_   \_ __         / _ \__ _ _ __ ___   ___ 
 //_\\| | |  / /  / _ \| |/ _ \| | | | '__|  / /  / _ \| '_ \| |_| |/ _` / __|  / _` | '__/ _ \  / _` |/ _ \| '_ \ / _ \    / /\/ '_ \ _____ / /_\/ _` | '_ ` _ \ / _ \
/  _  \ | | / /__| (_) | | (_) | |_| | |    / /__| (_) | | | |  _| | (_| \__ \ | (_| | | |  __/ | (_| | (_) | | | |  __/ /\/ /_ | | | |_____/ /_\\ (_| | | | | | |  __/
\_/ \_/_|_| \____/\___/|_|\___/ \__,_|_|    \____/\___/|_| |_|_| |_|\__, |___/  \__,_|_|  \___|  \__,_|\___/|_| |_|\___| \____/ |_| |_|     \____/\__,_|_| |_| |_|\___
                                                                    |___/                                                                                              
//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--//--// 
--]]

//-----DO NOT EDIT THESE TWO LINES-----\\
luxwlist = {}
luxwlist.config = {}
//-------------------------------------\\

//-- Whether or not the whitelist system is enabled. True for enabled | False for disabled
luxwlist.config.enabled = true

//-- Cmd = The chat command to use to open the whitelist menu if there are no arguments, or whitelist a player if there are arguments.
//-- For example, if the command is !whitelist, !whitelist alone will open the menu but !whitelist john blacksmith will whitelist john to blacksmith (if the job exists)
//-- Uncmd will always be an argument based command.
luxwlist.config.cmd = "!whitelist"
luxwlist.config.uncmd = "!unwhitelist"

//--Jobs that ignore the whitelist, recommended to set this to your default darkrp job. Set it to the job's NAME.
luxwlist.config.ignores = {
	"Citizen"
}
//-- Ranks = ranks that will be able to whitelist. Only works with ULX for now.
luxwlist.config.ranks = {
	"superadmin",
	"owner"
}

//----------DO NOT TOUCH THE LINES BELOW----------
if SERVER then
	AddCSLuaFile("luxwhitelist/cl_luxwhitelist.lua")
	include("luxwhitelist/sv_luxwhitelist.lua")
end
if CLIENT then
	include("luxwhitelist/cl_luxwhitelist.lua")
end