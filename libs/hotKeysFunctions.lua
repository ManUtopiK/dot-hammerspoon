----------------------------------------------------
-- closures functions used for HotKeys
----------------------------------------------------
--move cursor to position. Default: x=50, y=50
function moveCursorTo(x, y)
    x = x or 50
    y = y or 50
    local win = hs.window.focusedWindow()
    local f = win:frame()
    hs.mouse.setAbsolutePosition({
        x = f.x + f.w * x / 100,
        y = f.y + f.h * y / 100,
    })
end

-- open app and mouse cursor
function open(app)
    return function()
        hs.application.launchOrFocus(app)
        if (app == 'keeweb' or app == 'ForkLift') then
            local win = hs.window.focusedWindow()
            if (app == 'keeweb') then
                local f = win:frame()
                hs.eventtap.leftClick({
                    x = f.x + f.w / 1.7,
                    y = f.y + f.h / 2,
                })
            end
            hs.eventtap.keyStroke('cmd', 'F', 30)
        end
        moveCursorTo()
    end
end

-- Switch current tab to Vivaldi or Chrome
function switchTabOfBrowers()
    return function()
        local app = hs.application.frontmostApplication():name()

        if (app == 'Vivaldi') then
            local url = getBrowserUrl('Vivaldi')
            print(url)
            hs.eventtap.keyStroke('cmd', 'W')
            hs.osascript.applescript([[tell application "Google Chrome"
                activate
                open location "]] .. url .. [["
            end tell]])
        elseif (app == 'Google Chrome') then
            local url = getBrowserUrl('Google Chrome')
            print(url)
            hs.eventtap.keyStroke('cmd', 'W')
            hs.osascript.applescript([[tell application "Vivaldi"
                activate
                open location "]] .. url .. [["
            end tell]])
        end
    end
end

-- what is my ip, copying the IP in clipboard
function getMyIP()
    status, data, headers = hs.http.get("https://api.ipify.org/") -- http://ip.wains.be")
    -- hs.execute('echo ' .. data .. ' | pbcopy')
    hs.alert.show("Your IP is " .. data, 4)
    hs.pasteboard.setContents(data)
    -- hs.webview:html('<div>TEST</div>')
end

-- display info about Wi-Fi
function infoWifi()
    local wifi = hs.wifi.currentNetwork()
    if wifi then
        hs.alert.show("Wi-Fi connecté sur " .. hs.wifi.currentNetwork(), 4)
    else
        hs.alert.show("Le wifi est désactivé")
    end
end

-- display circle around mouse
function mouseHighlight()
    local mouseCircle = nil
    local mouseCircleTimer = nil
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end