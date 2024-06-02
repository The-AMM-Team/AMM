local module = {}

function module:timeFunctionCall(func: (...any) -> (), ...: any): number
    local startTime = os.clock()

    func(...)

    return os.clock() - startTime
end

return module