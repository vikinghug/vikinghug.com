### Unitframes are very big or I just don't like their location
Make sure you have done the following:  ESC -> Interface -> windows and reset all postions. 

The UnitFrame can be moved and scaled as you like. 

0. Hold ctrl down and click on the top edge to move it.
1. Find a corner and you'll see the rescaleing arrows. 

(Note that the background gradiant isn't large enough atm. This does it doesn't scale correctly together with the rest. Will be fixed soon by replacing it with a higher gradiant)
### Actionbars won't show up
Check that you haven't disabled actionbars by pressing ESC -> HUD and check Skills. It should be Always on.*

### Some addons won't load in game
If you downloaded your addons from GitHub, you need to remove the -master or -development part from the folder name.

### Other Addons won't work with VikingUI installed
This happens if other addons calls the normal UI addons. Like Datachron calling Questtracker. When other addons then call these by their "Carbine Name" and you have VikingUI installed they can't find eachother. A solution could be to make the addon know you have VikingUI Installed and call the VikingName. This does require some knowledge of Lua and Wildstar addons.

We will later on try and work out how to support other addons.

### The Downloader only downloads some of the folders
Make sure your firewall is allowing it to download. Some firewalls might block it.

### How do I change size/color/placement?
Simply put: you don't. VIkingUI is in its early stages and we don't have customization done yet. It will come, just not yet.

### The Tradeskills doesn't work and gives "Package not found" error
Thats because you have installed VikingTooltips which is not working as intended atm. (It isn't even tested beyond that error)
