-- CONFIGURATION (easy to edit)
local FISH_NAME = "Scylla"
local MIN_WEIGHT = 100000  -- in kg
local MAX_WEIGHT = 100000
local MUTATION_CHANCE = 50  -- 50% chance

local MUTATIONS = {
    "Albino",
    "Glowing",
    "Radioactive",
    "Two-Headed",
    "None" -- optional fallback
}

-- Random helper functions
local function getRandomWeight(min, max)
    return math.floor((math.random() * (max - min) + min) * 100) / 100 -- 2 decimal places
end

local function rollMutation()
    if math.random() < MUTATION_CHANCE then
        return MUTATIONS[math.random(1, #MUTATIONS - 1)] -- skip "None"
    else
        return "None"
    end
end

-- Function to create a fish item
local function createFish()
    local fish = Instance.new("Folder")
    fish.Name = FISH_NAME
    fish:SetAttribute("Weight", getRandomWeight(MIN_WEIGHT, MAX_WEIGHT))
    fish:SetAttribute("Mutation", rollMutation())
    fish:SetAttribute("CaughtAt", os.time())
    return fish
end

-- Main logic: grant to player executing this
local Players = game:GetService("Players")

local function grantToFirstPlayer()
    local player = Players:GetPlayers()[1]
    if not player then
        warn("No players found.")
        return
    end

    -- Simulate an inventory folder (adjust if your system uses something else)
    local inventory = player:FindFirstChild("Inventory")
    if not inventory then
        inventory = Instance.new("Folder")
        inventory.Name = "Inventory"
        inventory.Parent = player
    end

    -- Create and give the fish
    local newFish = createFish()
    newFish.Parent = inventory

    print("Granted", newFish.Name, "to", player.Name)
    print("Weight:", newFish:GetAttribute("Weight"), "kg")
    print("Mutation:", newFish:GetAttribute("Mutation"))
end

-- 🔥 Execute on script run
grantToFirstPlayer()
