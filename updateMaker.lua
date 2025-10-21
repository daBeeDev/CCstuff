-- makeUpdater.lua
-- Usage: makeUpdater <pastebinCode> <programName>

local args = {...}
if #args < 2 then
    print("Usage: makeUpdater <pastebinCode> <programName>")
    return
end

local code = args[1]
local name = args[2]
local updaterName = name .. "Update"

-- Generate updater code
local updaterCode = string.format([[
-- Auto-generated updater for %s
local name = "%s"
local code = "%s"

if fs.exists(name) then
    fs.delete(name)
    print("Deleted old version of " .. name)
end

print("Downloading latest version from Pastebin...")
local result = shell.run("pastebin get " .. code .. " " .. name)

if result then
    print("Successfully updated " .. name)
else
    print("Failed to download " .. name)
end
]], name, name, code)

-- Save updater
local file = fs.open(updaterName, "w")
file.write(updaterCode)
file.close()

print("Updater created: " .. updaterName)
