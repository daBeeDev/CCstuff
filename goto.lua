-- goToCoordsSimpleGPSStop.lua
-- Moves to target coordinates assuming a clear path
-- Stops if GPS after X or Z movement doesn't match expected
-- Coordinates can be passed as arguments or in a file (X,Y,Z each on a separate line)

-- Read coordinates from file
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
    if x and y and z then return x, y, z end
    return nil
end

-- Get target coordinates
local function getTargetCoords(args)
    if #args == 1 then
        return readCoordsFromFile(args[1])
    elseif #args >= 3 then
        return tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    else
        return nil
    end
end

-- Movement helpers
local function moveForward(steps)
    for i = 1, steps do
        turtle.forward()
    end
end

local function moveUp(steps)
    for i = 1, steps do
        turtle.up()
    end
end

local function moveDown(steps)
    for i = 1, steps do
        turtle.down()
    end
end

local function faceAxis(axis, delta)
    if axis == "X" then
        if delta > 0 then turtle.turnRight() turtle.turnRight() end -- +X
    elseif axis == "Z" then
        if delta > 0 then turtle.turnRight() else turtle.turnLeft() end
    end
end

-- Main
local args = {...}
local targetX, targetY, targetZ = getTargetCoords(args)
if not targetX then
    print("Usage: goToCoords x y z OR goToCoords file.txt")
    return
end

-- Get current coordinates
local startX, startY, startZ = gps.locate()
if not startX then
    print("GPS not found!")
    return
end

-- Calculate differences
local deltaX = targetX - startX
local deltaY = targetY - startY
local deltaZ = targetZ - startZ

-- Move X axis
if deltaX ~= 0 then
    faceAxis("X", deltaX)
    moveForward(math.abs(deltaX))
end

-- GPS check after X
local currentX, currentY, currentZ = gps.locate()
if currentX ~= targetX then
    print("Error: X coordinate mismatch! Expected:", targetX, "Got:", currentX)
    return
end

-- Move Z axis
if deltaZ ~= 0 then
    faceAxis("Z", deltaZ)
    moveForward(math.abs(deltaZ))
end

-- GPS check after Z
currentX, currentY, currentZ = gps.locate()
if currentZ ~= targetZ then
    print("Error: Z coordinate mismatch! Expected:", targetZ, "Got:", currentZ)
    return
end

-- Move Y axis last
if deltaY > 0 then
    moveUp(deltaY)
elseif deltaY < 0 then
    moveDown(-deltaY)
end

print("Arrived at:", targetX, targetY, targetZ)
