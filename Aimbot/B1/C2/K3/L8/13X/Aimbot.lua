--[[ 
Created by: @vzexg-2
Version: 1.1 Alpha
]]

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Loader",
    Text = "Aimbot Enabled [1.1 Alpha]",
    Duration = 5
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local closestPlayer
local shortestDistance = math.huge

local highlight = Instance.new("Highlight")
highlight.Name = "Highlight"

local function addHighlightToPlayer(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = highlight:Clone()
        highlightClone.Adornee = player.Character
        highlightClone.Parent = player.Character:FindFirstChild("HumanoidRootPart")
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function addHighlightsToAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addHighlightToPlayer(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait()
        addHighlightToPlayer(player)
    end)
end)

Players.PlayerRemoving:Connect(function(playerRemoved)
    if playerRemoved.Character and playerRemoved.Character:FindFirstChild("HumanoidRootPart") then
        local highlightInstance = playerRemoved.Character.HumanoidRootPart:FindFirstChild("Highlight")
        if highlightInstance then
            highlightInstance:Destroy()
        end
    end
end)

RunService.Heartbeat:Connect(function()
    addHighlightsToAllPlayers()
end)
local function isTargetVisible(target)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("Head") then return false end
    
    local ray = Ray.new(character.Head.Position, (target.Position - character.Head.Position).unit * 500)
    local part, position = workspace:FindPartOnRay(ray, character, false, true)
    
    return part and part:IsDescendantOf(target.Parent)
end

local aimbotEnabled = true
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        closestPlayer = nil
        shortestDistance = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = player.Character.HumanoidRootPart
                local distance = (humanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end

        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = closestPlayer.Character.HumanoidRootPart
            local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)

            if isTargetVisible(humanoidRootPart) then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, humanoidRootPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.1)
            end
        end
    end
end)

print("✅ Aimbot Enabled [1.1 Alpha]")
print("❗ Works only with FFA Mode.")
