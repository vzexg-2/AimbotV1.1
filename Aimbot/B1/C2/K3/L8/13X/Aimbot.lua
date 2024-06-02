--[[ 
___ _  _ _ ____ ___     ___  ____ ____ ___ _   _ 
 |  |__| | |__/ |  \    |__] |__| |__/  |   \_/  
 |  |  | | |  \ |__/    |    |  | |  \  |    |   
                                                 

-- Third-party software, vzexg-2
]]

local delay = 2
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Client",
    Text = "Third-party software [1.2 Alpha]",
    Duration = 5
})
wait(delay)
local ESPLib = {} -- Empty

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local closestPlayer
local shortestDistance = math.huge -- calculate the shortest distance player from your character 

local highlight = Instance.new("Highlight")
highlight.Name = "Highlight"

local function addHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character.HumanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = highlight:Clone()
        highlightClone.Adornee = player.Character
        highlightClone.Parent = player.Character:FindFirstChild("HumanoidRootPart")
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function addHighlightALL()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addHighlight(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait()
        addHighlight(player)
        ESPLib:CreateTracer(player)
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
    addHighlightALL()
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
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.2) -- Value
            end
        end
    end
end)

function ESPLib:CreateESPTracer(params)
    local player = params.player
    local Part = params.Part
    local TracerColor = params.TracerColor or Color3.new(255, 255, 255)

    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false

    local function updateESPTracer()
        if not Part or not Part:IsA("BasePart") or not Part.Parent then
            tracerLine:Remove()
            return
        end

        local playerPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if playerPosition then
            local headPosition = Part.Position + Vector3.new(0, Part.Size.Y / 2, 0)
            local screenPosition, onScreen = Camera:WorldToScreenPoint(headPosition)

            if onScreen then
                local tracerStart = Camera:WorldToViewportPoint(LocalPlayer.Character.Head.Position)
                local tracerEnd = Camera:WorldToViewportPoint(Part.Position)
                tracerLine.From = Vector2.new(tracerStart.X, tracerStart.Y)
                tracerLine.To = Vector2.new(tracerEnd.X, tracerEnd.Y)
                tracerLine.Color = TracerColor
                tracerLine.Thickness = 1
                tracerLine.Visible = true
            else
                tracerLine.Visible = false
            end
        else
            tracerLine.Visible = false
        end
    end

    RunService.RenderStepped:Connect(updateESPTracer)
end

function ESPLib:CreateTracer(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        local part = character:FindFirstChild("HumanoidRootPart")
        if part then
            ESPLib:CreateESPTracer({
                player = player,
                Part = part,
                TracerColor = Color3.new(255, 0, 0)
            })
        end
    end)
end
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        ESPLib:CreateTracer(player)
    end
end
print("ClientSide: Created Tracer to (player)")
print("ClientSide: Aimbot Enabled [1.2 Alpha] -- FFA")
