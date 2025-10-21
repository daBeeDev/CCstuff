-- startup.lua (place in /startup to auto-run)

local CONFIG_FILE = "gpsConfig"

-- Function to read saved coordinates
local function readConfig()
    if not fs.exists(CONFIG_FILE) then return nil end
    local file = fs.open(CONFIG_FILE, "r")
    local x = tonumber(file.readLine())
    local y = tonumber(file.readLine())
    local z = tonumber(file.readLine())
    file.close()
    if x and y and z then
        return {x=x, y=y, z=z}
    end
end

-- Function to save coordinates
local function writeConfig(x, y, z)
    local file = fs.open(CONFIG_FILE, "w")
    file.writeLine(x)
    file.writeLine(y)
    file.writeLine(z)
    file.close()
end

-- Ask for coordinates if not saved
local coords = readConfig()
if not coords then
    print("Enter GPS coordinates for this host:")
    write("X: ") local x = tonumber(read())
    write("Y: ") local y = tonumber(read())
    write("Z: ") local z = tonumber(read())
    writeConfig(x, y, z)
    coords = {x=x, y=y, z=z}
end

-- Open top wireless modem
if peripheral.getType("top") == "modem" then
    rednet.open("top")
    print("Modem opened on top.")
else
    error("No wireless modem on top! Please attach a wireless modem.")
end

-- Start GPS host using shell command
print("Hosting GPS at X:"..coords.x.." Y:"..coords.y.." Z:"..coords.z)
shell.run("gps host "..coords.x.." "..coords.y.." "..coords.z)

-- Optional: broadcast network message so other computers know GPS is online
local hostID = os.getComputerID()
rednet.broadcast("GPS Host Online! ID: "..hostID.." at X:"..coords.x.." Y:"..coords.y.." Z:"..coords.z)
print("Broadcasted GPS host info to network.")

-- Keep script running
while true do
    sleep(1)
end
