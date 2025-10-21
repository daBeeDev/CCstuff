local t = turtle

-- ==== CONFIG ====
local torchSlot = 1
local chestSlot = 2
local digSlot = 16
local torchInterval = 10
local chestInterval = 10

local deny = {
  ["minecraft:stone"] = true,
  ["minecraft:andesite"] = true,
  ["minecraft:diorite"] = true,
  ["minecraft:granite"] = true,
  ["minecraft:dirt"] = true,
  ["minecraft:gravel"] = true,
  ["minecraft:sand"] = true,
  ["minecraft:stone_bricks"] = true,
}

-- ==== PROMPTS ====
print("Enter excavation width:")
local width = tonumber(read())
print("Enter excavation length:")
local length = tonumber(read())
print("Enter excavation depth:")
local depth = tonumber(read())

-- ==== MOVEMENT HELPERS ====
local function forward() while not t.forward() do t.dig() sleep(0.2) end end
local function back() t.turnLeft(); t.turnLeft(); forward(); t.turnLeft(); t.turnLeft() end
local function up() while not t.up() do t.digUp() sleep(0.2) end end
local function down() while not t.down() do t.digDown() sleep(0.2) end end

-- ==== SAFE GPS LOCATE ====
local function getGPS()
  local ok, x, y, z = pcall(function() return gps.locate() end)
  if ok and x then return x, y, z end
  return nil
end

-- ==== FILE SAVE / RESUME ====
local function saveProgress(x, y, z)
  local f = fs.open("excavate_resume", "w")
  f.writeLine(x) f.writeLine(y) f.writeLine(z)
  f.close()
end

local function loadProgress()
  if not fs.exists("excavate_resume") then return nil end
  local f = fs.open("excavate_resume", "r")
  local x = tonumber(f.readLine())
  local y = tonumber(f.readLine())
  local z = tonumber(f.readLine())
  f.close()
  return x, y, z
end

-- ==== INVENTORY ====
local function depositChest()
  for s = 1, 16 do
    if s ~= torchSlot and s ~= chestSlot then
      t.select(s)
      t.dropDown()
    end
  end
end

local function refillTorches()
  if t.getItemCount(torchSlot) < 5 then
    t.select(torchSlot)
    t.suckDown()
  end
end

-- ==== ORE LOGGING ====
local function logPerimeterOres()
  local x, y, z = getGPS()
  if not x then return end
  for side = 1, 4 do
    local ok, data = t.inspect()
    if ok and not deny[data.name] then
      local f = fs.open("ores_found.txt", "a")
      f.writeLine(data.name .. " at " .. math.floor(x) .. ":" .. math.floor(y) .. ":" .. math.floor(z))
      f.close()
    end
    t.turnRight()
  end
end

-- ==== TORCH + CHEST PLACEMENT ====
local function placeTorchesAndChest(layer)
  print("Setting torch & chest layer:", layer)
  t.select(torchSlot)
  t.placeDown()
  t.select(chestSlot)
  t.turnLeft(); forward(); t.placeDown(); back(); t.turnRight()
  depositChest()
  refillTorches()
end

-- ==== PROGRESS BAR ====
local startTime = os.clock()
local function showProgress(done)
  local progress = done / depth
  local barLen = 30
  local filled = math.floor(progress * barLen)
  local empty = barLen - filled
  local elapsed = os.clock() - startTime
  local eta = (elapsed / progress) - elapsed
  io.write(string.format("\r[%s%s] %.1f%% | ETA %.1fs", string.rep("█", filled), string.rep(" ", empty), progress*100, eta))
  io.flush()
end

-- ==== CUBOID DIGGING ====
local function digLayer()
  for z = 1, length do
    for x = 1, width - 1 do
      t.digDown()
      forward()
    end
    if z < length then
      if z % 2 == 1 then t.turnRight(); forward(); t.turnRight()
      else t.turnLeft(); forward(); t.turnLeft() end
    end
  end
  if length % 2 == 1 then
    t.turnLeft(); t.turnLeft()
    for i = 1, width - 1 do forward() end
    t.turnLeft(); t.turnLeft()
  end
end

-- ==== MAIN LOOP ====
print("Starting excavation...")
local resumeX, resumeY, resumeZ = loadProgress()
if resumeX then print("Resuming from saved position...") end

for d = 1, depth do
  digLayer()
  logPerimeterOres()
  showProgress(d)
  if d % chestInterval == 0 then
    placeTorchesAndChest(d)
  end
  saveProgress(getGPS())
  down()
end

fs.delete("excavate_resume")
print("\nExcavation complete!")
