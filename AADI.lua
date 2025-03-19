-- Place this LocalScript in StarterPlayer -> StarterCharacterScripts

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Reference to the FishData ModuleScript
local FishData = require(ReplicatedStorage:WaitForChild("FishData"))

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.5, 0)
frame.Position = UDim2.new(0.25, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local fishListBox = Instance.new("TextButton")
fishListBox.Size = UDim2.new(1, 0, 0.8, 0)
fishListBox.Position = UDim2.new(0, 0, 0.1, 0)
fishListBox.Text = "View Available Fish"
fishListBox.TextColor3 = Color3.fromRGB(255, 255, 255)
fishListBox.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
fishListBox.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0.2, 0)
infoLabel.Position = UDim2.new(0, 0, 0.9, 0)
infoLabel.Text = ""
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 18
infoLabel.BackgroundTransparency = 1
infoLabel.Parent = frame

-- Function to display fish details in the TextButton
local function displayFishDetails()
    local fishText = "Fish Available in the Game:\n\n"
    
    for _, fish in ipairs(FishData.List) do
        fishText = fishText .. string.format("%d: %s (Rarity: %s, Price: $%d)\n", fish.ID, fish.Name, fish.Rarity, fish.Price)
    end
    
    fishListBox.Text = fishText
end

-- Function to retrieve fish by ID
local function getFishByID(fishID)
    for _, fish in ipairs(FishData.List) do
        if fish.ID == fishID then
            return fish
        end
    end
    return nil
end

-- When the player clicks on the "View Available Fish" button
fishListBox.MouseButton1Click:Connect(function()
    -- Display all available fish
    displayFishDetails()
    
    -- Update text to prompt the user to choose a fish
    infoLabel.Text = "Enter the Fish ID in the chat to get a fish!"
    
    -- Wait for the player to input a fish ID in the chat
    local function onPlayerChat(message)
        local fishID = tonumber(message)
        if fishID then
            local fish = getFishByID(fishID)
            if fish then
                infoLabel.Text = string.format("You got a %s! (Rarity: %s, Price: $%d)", fish.Name, fish.Rarity, fish.Price)
            else
                infoLabel.Text = "Fish ID not found!"
            end
        else
            infoLabel.Text = "Please enter a valid Fish ID!"
        end
    end

    -- Connect the player chat event
    Player.Chatted:Connect(onPlayerChat)
end)
