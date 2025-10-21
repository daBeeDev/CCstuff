-- goToCoords.lua
-- Usage:
--   goToCoords x y z
--   goToCoords coords.txt  (file containing X, Y, Z on separate lines)

-- Function to read coordinates from a file (each on its own line)
local function readCoordsFromFile(filename)
    if not fs.exists(filename) then
        print("File not found: "..filename)
        return nil
    end
    local file = fs.open(filename, "r")
    local x = tonumber(file.readLine())
    local y = tonumber(file.readLine())
    local z = tonumber(file.readLine())
    file.close()
    if x and y and z then
        return x, y, z
    end
    return nil
end

-- Function to get coordinates from arguments
local function getTargetCoords(args)
    if #args == 1 then
        return readCoordsFromFile(args[1])
    elseif #args >= 3 then
        return tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    else
        return nil
    end
end

-- Movement functions
local function moveForward(steps)
    for i = 1, steps do
        while not turtle.forward() do
            turtle.dig()
            sleep(0.5)
        end
    end
end

local function moveUp(steps)
    for i = 1, steps do
        while not turtle.up() do
            turtle.digUp()
            sleep(0.5)
        end
    end
end

local function moveDown(steps)
    for i = 1, steps do
        while not turtle.down() do
            turtle.digDown()
            sleep(0.5)
        end
    end
end

-- Main function
local args = {...}
local targetX, targetY, targetZ = getTargetCoords(args)

if not targetX then
    print("Usage: goToCoords x y z OR goToCoords filename.txt")
    return
end

-- Get current position
local startX, startY, startZ = gps.locate()
if not startX then
    print("GPS not found! Make sure a GPS network is available.")
    return
end

-- Move vertically first
if targetY > startY then
    moveUp(targetY - startY)
elseif targetY < startY then
    moveDown(startY - targetY)
end

-- Move X axis
if targetX ~= startX then
    if targetX > startX then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    moveForward(math.abs(targetX - startX))
end

-- Move Z axis
if targetZ ~= startZ then
    if targetZ > startZ then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    moveForward(math.abs(targetZ - startZ))
end

print("Arrived at coordinates:", targetX, targetY, targetZ)
