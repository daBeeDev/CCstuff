-- saveCoords.lua
-- Usage: saveCoords <name>

local args = {...}
if #args < 1 then
    print("Usage: saveCoords <name>")
    return
end

local name = args[1]
local filename = name .. "XYZ"

-- Get GPS coordinates
local x, y, z = gps.locate()
if not x then
    print("GPS signal not found. Make sure you have GPS access.")
    return
end

-- Save coordinates to file
local file = fs.open(filename, "w")
file.writeLine(x)
file.writeLine(y)
file.writeLine(z)
file.close()

print("Coordinates saved to " .. filename)
print(string.format("X: %d, Y: %d, Z: %d", x, y, z))
