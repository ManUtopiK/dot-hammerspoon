
function getBrowserUrl(browser)
    local ret, url = hs.osascript.applescript(
        'tell application "' .. browser .. [["
            get URL of active tab of first window
        end tell]]
    )
    return url
end

function keewebNewEntry(appName)
    return function()
        local domain = getBrowserUrl(appName):match('^%w+://([^/]+)')
        hs.eventtap.keyStroke({}, "ESCAPE")
        hs.eventtap.keyStroke('alt', 'n')
        hs.eventtap.keyStrokes(domain)
        hs.eventtap.keyStroke({}, "tab")
        hs.eventtap.keyStroke({}, "tab")
        hs.eventtap.keyStroke('cmd', "g")
        hs.eventtap.keyStroke({}, "return")
        hs.eventtap.keyStroke('cmd', "a")
        hs.eventtap.keyStroke('cmd', "c")
        hs.eventtap.keyStroke({}, "tab")
        hs.eventtap.keyStrokes(domain)
        hs.eventtap.keyStroke('shift', "tab")
        hs.eventtap.keyStroke('shift', "tab")
        hs.eventtap.keyStroke({}, "down")
    end
end

function vscodeNewEntry()
    -- hs.eventtap.keyStroke('cmd', 'S')
    local code = hs.application.frontmostApplication()
    code:selectMenuItem({"Fichier", "Enregistrer"})
    hs.osascript.applescript(
        [[tell application "Google Chrome" to tell the active tab of its first window
            reload
        end tell]]
    )
end

local keewebHKGoogle = hs.hotkey.new('alt', 'g', keewebNewEntry("Google Chrome"))
local keewebHKVivaldi = hs.hotkey.new('alt', 'v', keewebNewEntry("Vivaldi"))
local VSCodeHK = hs.hotkey.new({"cmd", "ctrl"}, 's', vscodeNewEntry)

function applicationWatcher(appName, eventType, appObject)
    print(appName)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            appObject:selectMenuItem({"Fenêtre", "Tout ramener au premier plan"})
        end
        if (appName == "KeeWeb") then
            keewebHKGoogle:enable()
            keewebHKVivaldi:enable()
        end
        if (appName == "Code") then
            VSCodeHK:enable()
        end
    end
    if (eventType == hs.application.watcher.deactivated) then
        if (appName == "KeeWeb") then
            VSCodeHK:disable()
        end
        if (appName == "Code") then
            VSCodeHK:disable()
        end
    end

end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()