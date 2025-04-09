-- SETTINGS
local FISH_STORAGE = game:GetService("ReplicatedStorage"):WaitForChild("FishAssets") -- or ServerStorage
local INVENTORY_FOLDER_NAME = "Inventory"

-- Function to get a random fish template from FishAssets
local function getRandomFishTemplate()
    local fishTemplates = FISH_STORAGE:GetChildren()
    if #fishTemplates == 0 then
        warn("No fish templates found in FishAssets!")
        return nil
    end
    return fishTemplates[math.random(1, #fishTemplates)]
end

-- Function to generate randomized fish from template
local function generateFishFromTemplate(template)
    if not template then return nil end

    -- Clone the fish model/folder
    local fish = template:Clone()
    fish.Name = template.Name

    -- Weight logic
    local minWeight = template:GetAttribute("MinWeight") or 0.5
    local maxWeight = template:GetAttribute("MaxWeight") or 10
    local weight = math.floor((math.random() * (maxWeight - minWeight) + minWeight) * 100) / 100
    fish:SetAttribute("Weight", weight)

    -- Mutation logic
    local mutations = template:GetAttribute("Mutations") -- comma-separated string
    local mutationChance = template:GetAttribute("MutationChance") or 0.05

    local mutation = "None"
    if mutations and math.random() < mutationChance then
        local mutationList = string.split(mutations, ",")
        mutation = mutationList[math.random(1, #mutationList)]
    end
    fish:SetAttribute("Mutation", mutation)
    fish:SetAttribute("CaughtAt", os.time())

    return fish
end

-- Function to grant fish to first available player (for testing/dev use)
local function grantToFirstPlayer()
    local Players = game:GetService("Players")
    local player = Players:GetPlayers()[1]
    if not player then
        warn("No players in server.")
        return
    end

    local inventory = player:FindFirstChild(INVENTORY_FOLDER_NAME)
    if not inventory then
        inventory = Instance.new("Folder")
        inventory.Name = INVENTORY_FOLDER_NAME
        inventory.Parent = player
    end

    local template = getRandomFishTemplate()
    local generatedFish = generateFishFromTemplate(template)

    if generatedFish then
        generatedFish.Parent = inventory
        print("Granted:", generatedFish.Name, "to", player.Name)
        print("Weight:", generatedFish:GetAttribute("Weight"), "kg")
        print("Mutation:", generatedFish:GetAttribute("Mutation"))
    end
end

-- 🟢 Execute immediately
grantToFirstPlayer()
