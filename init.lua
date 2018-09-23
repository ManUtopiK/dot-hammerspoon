require("libs.utils")
require("libs.hotKeysFunctions")
require("libs.windowsManipulations")
require("libs.applicationsWatcher")


-----------------------------------------------
-- Settings
-----------------------------------------------
local hyper = {"cmd", "alt", "ctrl"}
local tink_sound  = hs.sound.getByName("Tink") -- Sounds in /System/Library/Sounds

-- No animation
hs.window.animationDuration = 0


-----------------------------------------------
-- apps & tools
-----------------------------------------------
-- open app
hs.hotkey.bind(hyper, "H", open('hyper'))
hs.hotkey.bind(hyper, "G", open('Google Chrome'))
hs.hotkey.bind(hyper, "V", open('Vivaldi'))
hs.hotkey.bind(hyper, "C", open('Visual Studio Code'))
hs.hotkey.bind(hyper, "SPACE", open('ForkLift'))
hs.hotkey.bind(hyper, "K", open('keeweb'))

-- Switch current tab to Vivaldi or Chrome
hs.hotkey.bind(hyper, "U", switchTabOfBrowers())

-- Show my notes on visual studio code
hs.hotkey.bind(hyper, "N", execute('code ~/Manu/notes'))

-- hyper {DELETE} lock the screen
hs.hotkey.bind(hyper, "DELETE", hs.caffeinate.systemSleep)

-- what is my ip, copying the IP in clipboard
hs.hotkey.bind(hyper, "Z", getMyIP)

-- display info about Wi-Fi
hs.hotkey.bind(hyper, "W", infoWifi)

-- Hints mode : show letter on each application and toggle to it
hs.hotkey.bind('shift', 'ESCAPE', hs.hints.windowHints)

-- Mouse : display circle around mouse
hs.hotkey.bind(hyper, "M", mouseHighlight)

-- Aide : modal windows with all hotKeys
hs.hotkey.showHotkeys(hyper, "A")


-----------------------------------------------
-- Window resizing
-----------------------------------------------
hs.hotkey.bind(hyper, "LEFT", moveWinLeft)
hs.hotkey.bind(hyper, "RIGHT", moveWinRight)
hs.hotkey.bind(hyper, "UP", moveWinUp)
hs.hotkey.bind(hyper, "DOWN", moveWinDown)
hs.hotkey.bind(hyper, "F", moveWinFullscreen)
hs.hotkey.bind(hyper, 'PAGEDOWN', hs.grid.pushWindowNextScreen)
hs.hotkey.bind(hyper, 'PAGEUP', hs.grid.pushWindowPrevScreen)


-- debug ------------------------------
-- track events
foo = hs.distributednotifications.new(function(name, object, userInfo) print(string.format("name: %s\nobject: %s\nuserInfo: %s\n", name, object, hs.inspect(userInfo))) end)
-- foo:start()


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
