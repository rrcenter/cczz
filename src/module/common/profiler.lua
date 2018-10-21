require("socket")

local Profiler = {}
Profiler.names = {}
Profiler.starts = {}

Profiler.checkStart = function(name)
    table.insert(Profiler.names, name)
    table.insert(Profiler.starts, socket.gettime())
    print(string.format("%s接口性能检查开始", name))
end

Profiler.checkEnd = function()
    if #Profiler.names == 0 then
        return
    end

    print(string.format("%s接口耗时：%d ms", Profiler.names[#Profiler.names], (socket.gettime() - Profiler.starts[#Profiler.starts]) * 1000))
    table.remove(Profiler.names)
    table.remove(Profiler.starts)
end

return Profiler