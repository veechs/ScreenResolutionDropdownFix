# Screen Resolution Dropdown Fix
TL;DR: Don’t bother installing this unless you’re getting a Lua error when opening the Video Options dialog and having issues selecting screen resolutions as a result.

### Fix the UIDROPDOWNMENU_OPEN_MENU error
When Vanilla WoW is run in a Windows VM (like Parallels), a huge list of resolutions may be offered – more than Blizzard’s UI code can handle. As a result, the Lua error below pops up at login and when the Video Options dialog is opened. In addition, the highest resolutions are missing from the dropdown and accessing them requires editing config.wtf.

`Interface\FrameXML\UIDropDownMenu.lua:156: attempt to concatenate global UIDROPDOWNMENU_OPEN_MENU' (a nil value)`

SRDF culls the resolutions provided to Video Options, allowing the dropdown to function normally. It also redirects the initial error popup to chat so you can stop clicking Okay at every login.

### Automatically get the highest resolutions or whitelist only the ones you want

In default mode (which should be fine for most use cases) the list of available resolutions is simply limited to the 32 *highest* ones. This cuts out things like 800x600 that are pretty useless most of the time anyway. If for some reason you need to whitelist only specific resolutions, you can do that by editing ScreenResolutionDropdownFix.lua.
<br><br>

## Installation

#### Easy mode

Use [GitAddonsManager](https://woblight.gitlab.io/overview/gitaddonsmanager/).

#### Manual instructions

1. Download the code (green **Code** button > **Download ZIP**)
2. Extract the ZIP file in your Downloads folder and move **!ScreenResolutionDropdownFix** to **<Path\To\WoW Folder>\Interface\Addons**

Once you're done, the folder structure should be **<Path\To\WoW Folder>\Interface\Addons\\!ScreenResolutionDropdownFix\\!ScreenResolutionDropdownFix.toc**
<br><br>

## Notes

#### There are chat commands for debugging
The slash commands below are added so you can easily see the lists of resolutions the addon is using.

| Command | Resolution List | Output |
| --- | --- | --- |
| `/listres` | Original from [GetScreenResolutions()](https://wowpedia.fandom.com/wiki/API_GetScreenResolutions?oldid=234457) | `<ID>: <Resolution>` | 
| `/listfres` | Filtered  | `<New ID> [<Original ID>]: <Resolution>` |

#### This is basically a better version of [Hide Script Error Frame At Login](https://github.com/veechs/HideScriptErrorFrameAtLogin/)
You *do not* need both (but they won't conflict).
