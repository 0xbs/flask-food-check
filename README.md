# Flask Food Check

Small addon that reminds you and your raid members of using and renewing flask, food and rune buffs. 
On every ready check, FlaskFoodCheck simply writes the names of players to the raid channel that are missing buffs, 
missing buffs with the minimum stats required or with buffs that will expire soon. In the default configuration, 
FlaskFoodCheck will only write to a channel on ready check in two cases: 
(1) you are in raid and have at least assistance rights; 
(2) you are in a challenge mode dungeon. 
Of course, FlaskFoodCheck behaviour can be freely customized using slash commands.

### Available commands

* `/ffc run` - Manually trigger a flask and food buff check. Will be always printed to a raid channel (unless you are muted).
* `/ffc mute` - Mute the addon (never write to raid channel, but display locally). Useful if your angry flask-missing raid lead hates this addon.
* `/ffc unmute` - Unmute if previously muted.
* `/ffc require any` - Print messages on every ready check in a raid, regardless of raid rights.
* `/ffc require assist` - Print messages on every read check in a raid only if you have at least assistant rights (default).
* `/ffc require raidlead` - Print messages on every read check in a raid only if you are the raid leader.
* `/ffc check food` - Enable or disable food check (default on).
* `/ffc check flask` - Enable or disable flask check (default on).
* `/ffc check rune` - Enable or disable rune check (default off).
* `/ffc minlevel <level>` - Minimum player level in order to appear in the output (default 100).
* `/ffc minfood <amount>` - Mininum stats required on food buff (default 100).
* `/ffc minflask <amount>` - Mininum stats required on flask buff (default 250).
* `/ffc minrune <amount>` - Mininum stats required on rune buff (default 50).
* `/ffc expire <seconds>` - Seconds before a buff is marked as expiring (default 480 = 8 min).
* `/ffc values` - List all values currently set (minfood, minflask, etc.).
* `/ffc val` - Same as above, but shorter.


### Resources

* [Project on Curse](https://www.curseforge.com/wow/addons/flaskfoodcheck)
* [Project on Curseforge](https://wow.curseforge.com/projects/flaskfoodcheck)


### License

The software is provided under the GNU General Public License, Version 2. See the `LICENSE` file for details.
