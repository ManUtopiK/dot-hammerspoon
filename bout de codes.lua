
Open a certain Chrome tab with alt + ?
For some apps such as Slack and HipChat, I want to run it as a web app in the browser, and I also want to quick switch to it. It’s a little tricky because Hammerspoon doesn’t have API for third party applications such as Chrome. So we need JXA to help with this. JXA is that using Javascript to complete some automation in OS X. Here is my solution:

function chrome_active_tab_with_name(name)
    return function()
        hs.osascript.javascript([[
            // below is javascript code
            var chrome = Application('Google Chrome');
            chrome.activate();
            var wins = chrome.windows;

            // loop tabs to find a web page with a title of <name>
            function main() {
                for (var i = 0; i < wins.length; i++) {
                    var win = wins.at(i);
                    var tabs = win.tabs;
                    for (var j = 0; j < tabs.length; j++) {
                    var tab = tabs.at(j);
                    tab.title(); j;
                    if (tab.title().indexOf(']] .. name .. [[') > -1) {
                            win.activeTabIndex = j + 1;
                            return;
                        }
                    }
                }
            }
            main();
            // end of javascript
        ]])
    end
end

--- Use
hs.hotkey.bind({"alt"}, "H", chrome_active_tab_with_name("HipChat"))









-----------------------------------------------
-- Pre-Configured Layouts
-----------------------------------------------

-- main work mode
    -- hides all apps then activates and arranges
    -- a pre-determined set of apps

-- I use Karabiner to bind these window functions
-- to keystrokes (e.g., W+D = default layout)

hs.urlevent.bind("defaultLayout", function()

    -- hide all windows using this AppleScript:

        --[[tell application "System Events"
            repeat with p in every process
                if name of p is in {"Google Chrome", "MailMate", "iA Writer Pro", "nvALT", "Finder"} then
                set visible of p to true
                else if background only of p is false then
                set visible of p to false
                end if
            end repeat
            end tell
         -- ]]

    hs.applescript._applescript('tell application "Hide All Windows" to activate')

    -- bring back the apps I want in front

    hs.application.launchOrFocus("Safari")
    hs.application.launchOrFocus("MailMate")
    hs.application.launchOrFocus("iA Writer Pro")
    hs.application.launchOrFocus("nvALT")

    -- define screens

    local bigScreen = "ASUS PB278"
    local laptop = "Color LCD"
    myScreen = hs.screen.mainScreen():name()

    -- layout for external monitor

    local asusLayout = {
        {"MailMate", nil, bigScreen, hs.geometry.rect(.7, 0.02, .25, .3), nil, nil},
        {"iA Writer Pro", nil, bigScreen, hs.geometry.rect(.35, .175, .3, .75), nil, nil},
        {"OmniFocus", nil, bigScreen, hs.geometry.rect(.35, .175, .3, .75), nil, nil},
        {"Safari", nil, bigScreen, hs.geometry.rect(0, .01, .33, .9), nil, nil},
        {"nvALT", nil, bigScreen, hs.geometry.rect(.7, .38, .25, .55), nil, nil},
    }

    -- layout for laptop screen

    local laptopLayout = {
        {"MailMate", nil, laptop, hs.geometry.rect(.7, 0.01, .29, .39), nil, nil},
        {"OmniFocus", nil, laptop, hs.geometry.rect(.31, .19, .39, .59), nil, nil},
        {"iA Writer Pro", nil, laptop, hs.geometry.rect(.25, .19, .39, .59), nil, nil},
        {"Safari", nil, laptop, hs.geometry.rect(0.01, 0.01, .68, .98), nil, nil},
        {"nvALT", nil, laptop, hs.geometry.rect(.7, .41, .29, .58), nil, nil},
    }

    -- applies layout based on active screen

    if (myScreen == laptop) then
    hs.layout.apply(laptopLayout)
    elseif (myScreen == bigScreen) then
    hs.layout.apply(asusLayout)
    end
end)





-- hs.require = require
-- require = rawrequire
-- local mods        = require("hs._asm.extras").mods
-- local app = hs.hotkey.modal.new(mods.CAsC, "a")

--     hs.fnutils.each({
--         { key = "a", app = "Arduino" },
--         { key = "p", app = "Activity Monitor" },
--         { key = "t", app = "Terminal" },
--         { key = "e", app = "TextWrangler" },
--         { key = "f", app = "Finder" },
--         { key = "m", app = "Mail" },
--         { key = "s", app = "Safari" },
--         { key = "c", app = "Console" },
--     },
--         function(object)
--             app:bind(mods.casc, object.key,
--                 function() hs.application.launchOrFocus(object.app) end,
--                 function() app:exit() end
--             )
--         end
--     )

--     function app:entered()
--         hs.alert.show("Entering Application Mode")
--     end
--     function app:exited()
--         hs.alert.show("Leaving Application Mode")
--     end
-- app:bind(mods.casc, "ESCAPE", function() app:exit() end)




-- hs.hotkey.bind(hyper, "d", function()
--  if myVar then
--    myVar = false
--    hs.alert.show("Quit Application Mode")
--  else
--    myVar = true
--    hs.alert.show("Entering Application Mode")
--  end
-- end)

-- k = hs.hotkey.modal.new('cmd-shift', 'd')
-- function k:entered() hs.alert'Entered mode' end
-- function k:exited() hs.alert'Exited mode' end
-- k:bind('', 'escape', function() k:exit() end)
-- k:bind('', 'J', 'Pressed J',function() print'let the record show that J was pressed' end)









Move windows to 30%, 50% and 70% of the left/right of the screen
I used Spectacle to achieve this until I discovered Hammerspoon. Why do I need one more application when I can use Hammerspoon to achieve it?

Here is my solution:

function move(dir)
    local counter = {
        right = 0,
        left = 0
    }
    return function()
        counter[dir] = _move(dir, counter[dir])
    end
end

function _move(dir, ct)
    local screenWidth = hs.screen.mainScreen():frame().w
    local focusedWindowFrame = hs.window.focusedWindow():frame()
    local x = focusedWindowFrame.x
    local w = focusedWindowFrame.w
    local value = dir == 'right' and x + w or x
    local valueTarget = dir == 'right' and screenWidth or 0
    if value ~= valueTarget then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 50])
        return 50
    elseif ct == 50 then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 70])
        return 70
    elseif ct == 70 then
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 30])
        return 30
    else
        hs.window.focusedWindow():moveToUnit(hs.layout[dir .. 50])
        return 50
    end
end

--- window
hs.window.animationDuration = 0
hs.hotkey.bind({"ctrl", "cmd"}, "Right", move('right'))
hs.hotkey.bind({"ctrl", "cmd"}, "Left", move('left'))