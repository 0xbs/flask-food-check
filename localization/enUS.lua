local FFC = select(2, ...)
local L = {}

L["food"] = "food"
L["flask"] = "flask"
L["rune"] = "rune"
L["Currently checking for:"] = "Currently checking for:"
L[" (eating)"] = " (eating)"
L["Flask missing: "] = "Flask missing: "
L["Flask with low stats: "] = "Flask with low stats: "
L["Flask expires: "] = "Flask expires: "
L["Food missing: "] = "Food missing: "
L["Food with low stats: "] = "Food with low stats: "
L["Food expires: "] = "Food expires: "
L["Rune missing: "] = "Rune missing: "
L["Rune with low stats: "] = "Rune with low stats: "
L["Rune expires: "] = "Rune expires: "
L["Everyone has flask and food buff! #bestraid"] = "Everyone has flask and food buff! #bestraid"
L["Hooray, everyone has food, flask and rune buff! #incredibleraid"] = "Hooray, everyone has food, flask and rune buff! #incredibleraid"
L["Everyone has food buff."] = "Everyone has food buff."
L["Everyone has flask buff."] = "Everyone has flask buff."
L["Everyone has rune buff."] = "Everyone has rune buff."
L["Not in raid."] = "Not in raid."
L["%d min"] = "%d min"
L["Slash commands"] = "Slash commands"
L["/ffc run - Manually trigger a flask and food buff check."] = "|cff4794ec/ffc run|r - Manually trigger a flask and food buff check."
L["/ffc mute - Mute the addon (do not write to raid channel, but display locally)."] = "|cff4794ec/ffc mute|r - Mute the addon (do not write to raid channel, but display locally)."
L["/ffc unmute - Unmute if previously muted."] = "|cff4794ec/ffc unmute|r - Unmute if previously muted."
L["/ffc require any - Print messages on every ready check in a raid, regardless of rights."] = "|cff4794ec/ffc require any|r - Print messages on every ready check in a raid, regardless of rights."
L["/ffc require assist - Print messages on every read check in a raid if you have at least assistant rights (default)."] = "|cff4794ec/ffc require assist|r - Print messages on every read check in a raid if you have at least assistant rights (default)."
L["/ffc require raidlead - Print messages on every read check in a raid if you are the raid leader."] = "|cff4794ec/ffc require raidlead|r - Print messages on every read check in a raid if you are the raid leader."
L["/ffc check food - Enable or disable food check (default on)."] = "|cff4794ec/ffc check food|r - Enable or disable food check (default on)."
L["/ffc check flask - Enable or disable flask check (default on)."] = "|cff4794ec/ffc check flask|r - Enable or disable flask check (default on)."
L["/ffc check rune - Enable or disable rune check (default off)."] = "|cff4794ec/ffc check rune|r - Enable or disable rune check (default off)."
L["/ffc minlevel <level> - Minimum player level in order to appear in the output (default 100)."] = "|cff4794ec/ffc minlevel|r |cff9ab7db<level>|r - Minimum player level in order to appear in the output (default 100)."
L["/ffc minfood <amount> - Mininum stats required on food buff (default 100)."] = "|cff4794ec/ffc minfood|r |cff9ab7db<amount>|r - Mininum stats required on food buff (default 100)."
L["/ffc minflask <amount> - Mininum stats required on flask buff (default 250)."] = "|cff4794ec/ffc minflask|r |cff9ab7db<amount>|r - Mininum stats required on flask buff (default 250)."
L["/ffc minrune <amount> - Mininum stats required on rune buff (default 50)."] = "|cff4794ec/ffc minrune|r |cff9ab7db<amount>|r - Mininum stats required on rune buff (default 50)."
L["/ffc expire <seconds> - Seconds before a buff is marked as expiring (default 480 = 8 min)."] = "|cff4794ec/ffc expire|r |cff9ab7db<seconds>|r - Seconds before a buff is marked as expiring (default 480 = 8 min)."
L["/ffc values - List all values currently set (minfood, minflask, etc.)."] = "|cff4794ec/ffc values|r - List all values currently set (minfood, minflask, etc.)."
L["/ffc val - Same as above, but shorter."] = "|cff4794ec/ffc val|r - Same as above, but shorter."
L["Muted."] = "Muted."
L["Unmuted."] = "Unmuted."
L["Minimum player level set to %d."] = "Minimum player level set to %d."
L["Minimum stats on food set to %d."] = "Minimum stats on food set to %d."
L["Minimum stats on flask set to %d."] = "Minimum stats on flask set to %d."
L["Minimum stats on rune set to %d."] = "Minimum stats on rune set to %d."
L["Expiration warning set to %d seconds (approx. %d min)."] = "Expiration warning set to %d seconds (approx. %d min)."
L["Unknown command."] = "Unknown command."
L["Unknown value."] = "Unknown value."
L["Minimum player level is currently set to %d."] = "Minimum player level is currently set to %d."
L["Minimum stats on food is currently set to %d."] = "Minimum stats on food is currently set to %d."
L["Minimum stats on flask is currently set to %d."] = "Minimum stats on flask is currently set to %d."
L["Minimum stats on rune is currently set to %d."] = "Minimum stats on rune is currently set to %d."
L["Expiration warning is currently set to %d seconds (approx. %d min)."] = "Expiration warning is currently set to %d seconds (approx. %d min)."
L["No special raid rights are now required for printing to raid channel."] = "No special raid rights are now required for printing to raid channel."
L["Being assistant is now required for printing to raid channel."] = "Being assistant is now required for printing to raid channel."
L["Being raidlead is now required for printing to raid channel."] = "Being raidlead is now required for printing to raid channel."
L["Currently no special raid rights are required for printing to raid channel."] = "Currently no special raid rights are required for printing to raid channel."
L["Currently being assistant is required for printing to raid channel."] = "Currently being assistant is required for printing to raid channel."
L["Currently being raidlead is required for printing to raid channel."] = "Currently being raidlead is required for printing to raid channel."

FFC.L = L