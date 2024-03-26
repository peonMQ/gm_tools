---@class Command
---@field Execute fun(...)
---@field Queue fun(...)


---@class CommandHandler
---@field Execute fun()

---@type CommandHandler[]
local queue = {}

---@param command fun()
local function enqueue(command)
    table.insert(queue, { Execute = command })
end

---@return CommandHandler|nil #Returns the oldest item on the queue
local function deQueue()
    for idx, command in ipairs(queue) do
        table.remove(queue, idx)
        return command
    end

    return nil
end

-- Clears the command queue
local function clear()
    queue = {}
end

local function process()
    local command = deQueue()
    if command == nil then
        return
    end

    command.Execute()
end

return {
    Clear = clear,
    Enqueue = enqueue,
    Process = process,
}

-- table.remove performance issue
-- https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating


-- Priority queue
-- http://lua-users.org/lists/lua-l/2007-07/msg00482.html