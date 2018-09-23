function execute(code)
    return function()
        hs.execute(code, true)
    end
end
