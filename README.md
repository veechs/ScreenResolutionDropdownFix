# Screen Resolution Dropdown Fix
TL;DR: Don’t bother installing this unless you’re getting a Lua error when opening the Video Options dialog and having issues selecting screen resolutions as a result.

### Fix the UIDROPDOWNMENU_OPEN_MENU error
When Vanilla WoW is run in a Windows VM (like Parallels), a huge list of possible resolutions may be offered – more than Blizzard’s UI code can deal with. This causes the Lua error below to pop up at login and when the Video Options dialog is opened. Because of this issue, the highest resolutions are not available in the dropdown and require editing config.wtf to access.

`Interface\FrameXML\UIDropDownMenu.lua:156: attempt to concatenate global UIDROPDOWNMENU_OPEN_MENU' (a nil value)`

By culling the resolutions provided to Video Options, the error is prevented and the dropdown functions normally.

### Automatically get the highest resolutions or whitelist only the ones you want

In default mode (which should be fine for most use cases) the list of available resolutions is simply limited to the 32 *highest* ones. This cuts out things like 800x600 that are pretty useless most of the time anyway. If for some reason you need to whitelist only specific resolutions, you can do that by editing ScreenResolutionDropdownFix.lua.

### This is basically a better version of [Hide Script Error Frame At Login](https://github.com/veechs/HideScriptErrorFrameAtLogin/)
You *do not* need both (but they won't conflict).

### There are chat commands for debugging
The slash commands below are added so you can easily see the lists of resolutions the addon is using.

| Command | Resolution List | Output |
| --- | --- | --- |
| `/listres` | Original from [GetScreenResolutions()](https://wowpedia.fandom.com/wiki/API_GetScreenResolutions?oldid=234457) | `<ID>: <Resolution>` | 
| `/listfres` | Filtered  | `<New ID> [<Original ID>]: <Resolution>` |

## Installation

#### Easy mode

Use [GitAddonsManager](https://woblight.gitlab.io/overview/gitaddonsmanager/).

#### Manual instructions

1. Download the code (green **Code** button > **Download ZIP**)
2. Extract the ZIP file in your Downloads folder and move **!ScreenResolutionDropdownFix** to **<Path\To\WoW Folder>\Interface\Addons**

Once you're done, the folder structure should be **<Path\To\WoW Folder>\Interface\Addons\!ScreenResolutionDropdownFix\!ScreenResolutionDropdownFix.toc**

