-- "local" = variables
local tink_sound  = hs.sound.getByName("Tink") -- Sounds in /System/Library/Sounds

local myVar = false
local hyper = {"cmd", "alt", "ctrl"}

-- Set grid size.
-- hs.grid.GRIDWIDTH  = 10
-- hs.grid.GRIDHEIGHT = 2
-- hs.grid.MARGINX    = 0
-- hs.grid.MARGINY    = 0
-- No animation
hs.window.animationDuration = 0


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



-----------------------------------------------
-- apps
-----------------------------------------------
function moveCursorToCenterWindow()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    hs.mouse.setAbsolutePosition({
        x = f.x + f.w / 2,
        y = f.y + f.h / 2,
    })
end

appCuts = {
    h = 'hyper',
    g = 'Google Chrome',
    v = 'Vivaldi',
    c = 'Visual Studio Code',
    space = 'ForkLift',
    k = 'keeweb'
}
for key, app in pairs(appCuts) do
    hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
    moveCursorToCenterWindow()
    if (app == 'keeweb' or app == 'ForkLift') then
        hs.eventtap.keyStroke('cmd', 'F')
    end
    end)
end

hs.hotkey.bind(hyper, 'escape', function()
    hs.hints.windowHints()
end)

-- hyper {DELETE} lock the screen
hs.hotkey.bind(hyper, "DELETE", function()
    -- os.execute("pmset displaysleepnow")
    hs.caffeinate.systemSleep()
end)

-- what is my ip, copying the IP in clipboard
hs.hotkey.bind(hyper, 'z', function ()
    status, data, headers = hs.http.get("https://api.ipify.org/") -- http://ip.wains.be")
    hs.applescript('do shell script "echo " .. data .. " | pbcopy"')
    hs.alert.show("Your IP is " .. data, 4)
    hs.pasteboard.setContents(data)
    hs.webview:html('<div>TEST</div>')
end)

-- connected Wi-Fi
hs.hotkey.bind(hyper, 'w', function ()
    local wifi = hs.wifi.currentNetwork()
    if wifi then
    hs.alert.show("Wi-Fi connecté sur " .. hs.wifi.currentNetwork(), 4)
    else
    hs.alert.show("Le wifi est désactivé")
    end
end)




-----------------------------------------------
-- Window resizing
-----------------------------------------------
hs.hotkey.bind(hyper, "left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local divider = 2

    if (f.x == 0 and f.w == math.floor(max.w / 2)) then
    divider = 2.5
    end
    if (f.x == 0 and f.w == math.floor(max.w / 2.5)) then
    divider = 3
    end
    if (f.x == 0 and f.w == math.floor(max.w / 3)) then
    divider = 1.5
    end
    if (f.x == 0 and f.w == math.floor(max.w / 1.5)) then
    divider = 5/3
    end

    f.x = max.x
    f.y = max.y
    f.w = max.w / divider
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind(hyper, "right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local divider = 2
    local screenDivider = 2

    if (f.x == max.w / 2 and f.w == math.floor(max.w / 2)) then
    divider = 2.5
    screenDivider = 5/3
    end
    if (f.x == math.floor(max.w / (5/3)) and f.w == math.floor(max.w / 2.5)) then
    divider = 3
    screenDivider = 1.5
    end
    if (f.x == math.floor(max.w / 1.5) and f.w == math.floor(max.w / 3)) then
    divider = 1.5
    screenDivider = 3
    end
    if (f.x == math.floor(max.w / 3) and f.w == math.floor(max.w / 1.5)) then
    divider = 1.5
    screenDivider = 2.5
    end
-- print(f)
    f.x = max.w / screenDivider
    f.y = max.y
    f.w = max.w / divider
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind(hyper, "up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local divider = 2
    local menubarHeight = 23

    if (f.y == menubarHeight and f.h == math.floor(max.h / 2)) then
    divider = 3
    end
    if (f.y == menubarHeight and f.h == math.floor(max.h / 3)) then
    divider = 1.5
    end

    f.y = max.y
    f.h = max.h / divider

    if (f.w == math.floor(max.w / 1.5) or f.w == math.floor(max.w / 2) or f.w == math.floor(max.w / 3)) then
    else
    f.x = max.x
    f.w = max.w
    end

    win:setFrame(f)
end)

hs.hotkey.bind(hyper, "down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local divider = 2
    local screenDivider = 2
    local menubarHeight = 23

    if (f.y == math.floor(max.h / 2) + menubarHeight and f.h == math.floor(max.h / 2)) then
    divider = 3
    screenDivider = 1.5
    end
    if (f.y == math.floor(max.h / 1.5) + menubarHeight and f.h == math.floor(max.h / 3)) then
    divider = 1.5
    screenDivider = 3
    end

    f.y = max.y + (max.h / screenDivider)
    f.h = max.h / divider

    if (f.w == math.floor(max.w / 1.5) or f.w == math.floor(max.w / 2) or f.w == math.floor(max.w / 3)) then
    else
    f.x = max.x
    f.w = max.w
    end

    win:setFrame(f)
end)

hs.hotkey.bind(hyper, "f", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local divider = 1

    if (f.x == 0 and f.w == max.w) then
    divider = 1.5
    f.x = (max.w - (max.w / divider)) / 2
    elseif (f.x == math.floor((max.w - (max.w / 1.5)) / 2) and f.w == math.floor(max.w / 1.5)) then
    divider = 3
    f.x = (max.w - (max.w / divider)) / 2

    else
    f.x = max.x
    end

    f.y = max.y
    f.h = max.h
    f.w = max.w / divider
    win:setFrame(f)
end)

hs.hotkey.bind(hyper, 'pagedown', hs.grid.pushWindowNextScreen)
hs.hotkey.bind(hyper, 'pageup', hs.grid.pushWindowPrevScreen)






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








-- test ------------------------------



hs.urlevent.bind("test1", function(eventName, params)
    if params["someParam"] then
    hs.alert.show(params["someParam"])
    end
end)











-----------------------------------------------
-- Auto config reloading
-----------------------------------------------
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
tink_sound:play()
hs.notify.new({title="Hammerspoon", informativeText="init.lua rechargé !"}):send():release()

-- watch for keyboard layout change and reload hammerspoon config
reloadConfigOnKeyboardLayoutChange = hs.distributednotifications.new(
    function(name, object, userInfo)
        if (name == 'com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged') then
            hs.reload()
        end
    end
)
reloadConfigOnKeyboardLayoutChange:start()

function applicationWatcher(appName, eventType, appObject)
    if (appName == "Finder" and eventType == hs.application.watcher.activated) then
        -- Bring all Finder windows forward when one gets activated
        appObject:selectMenuItem({"Fenêtre", "Tout ramener au premier plan"})
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()


-- track events
--[[ foo = hs.distributednotifications.new(function(name, object, userInfo) print(string.format("name: %s\nobject: %s\nuserInfo: %s\n", name, object, hs.inspect(userInfo))) end)
foo:start() ]]

