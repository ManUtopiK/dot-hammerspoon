function moveWinLeft()
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
end

function moveWinRight()
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
end

function moveWinUp()
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
end

function moveWinDown()
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
end

function moveWinFullscreen()
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
end