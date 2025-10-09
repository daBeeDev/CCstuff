-- gpsHostSetup.lua
-- Creates or loads GPS host coordinates and starts GPS service

local CONFIG_FILE = "gpsConfig"

-- Helper function to read coordinates from file
local function readConfig()
    if not fs.exists(CONFIG_FILE) then return nil end
    local file = fs.open(CONFIG_FILE, "r")
    local x = tonumber(file.readLine())
    local y = tonumber(file.readLine())
    local z = tonumber(file.readLine())
    file.close()
    if x and y and z then
        return {x = x, y = y, z = z}
    else
        return nil
    end
end

-- Helper function to write coordinates to file
local function writeConfig(x, y, z)
    local file = fs.open(CONFIG_FILE, "w")
    file.writeLine(x)
    file.writeLine(y)
    file.writeLine(z)
    file.close()
end

-- Main
local coords = readConfig()
if coords then
    print("Loaded GPS coordinates from file:")
    print("X: " .. coords.x .. "  Y: " .. coords.y .. "  Z: " .. coords.z)
else
    print("gpsConfig not found, please enter coordinates.")
    write("Enter X coordinate: ")
    local x = tonumber(read())
    write("Enter Y coordinate: ")
    local y = tonumber(read())
    write("Enter Z coordinate: ")
    local z = tonumber(read())
    writeConfig(x, y, z)
    coords = {x = x, y = y, z = z}
    print("Saved new coordinates to gpsConfig.")
end

-- Start GPS host
print("Starting GPS host at:")
print("X: " .. coords.x .. "  Y: " .. coords.y .. "  Z: " .. coords.z)
print("Use Ctrl+T to stop.")
gps.host(coords.x, coords.y, coords.z)
