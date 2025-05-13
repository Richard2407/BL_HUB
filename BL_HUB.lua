-- BL HUB - ESP + Aimbot Somente | Otimizado

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- UI leve (Kavo)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("BL HUB | ESP & Aimbot", "Ocean")

-- ===== Funções ESP =====
local function createESP(part, text, color)
    if part:FindFirstChild("BLHUB_ESP") then return end
    local bill = Instance.new("BillboardGui", part)
    bill.Name = "BLHUB_ESP"
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 100, 0, 40)
    bill.Adornee = part

    local label = Instance.new("TextLabel", bill)
    label.Text = text
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextScaled = true
end

local function clearESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:FindFirstChild("BLHUB_ESP") then
            v.BLHUB_ESP:Destroy()
        end
    end
end

-- ===== Aba ESP =====
local ESPTab = Window:CreateTab("ESP", 4483362458)
local espFrutas, espBaus, espPlayers, espNpcs = false, false, false, false

ESPTab:CreateToggle("ESP Frutas", false, function(v) espFrutas = v end)
ESPTab:CreateToggle("ESP Baús", false, function(v) espBaus = v end)
ESPTab:CreateToggle("ESP Jogadores", false, function(v) espPlayers = v end)
ESPTab:CreateToggle("ESP NPCs", false, function(v) espNpcs = v end)

RunService.RenderStepped:Connect(function()
    clearESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if espFrutas and v:IsA("Tool") and v:FindFirstChild("Handle") then
            createESP(v.Handle, "Fruta", Color3.fromRGB(0,255,127))
        end
        if espBaus and v.Name:lower():find("chest") then
            createESP(v, "Baú", Color3.fromRGB(255,255,0))
        end
        if espPlayers and v:IsA("Model") and Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") then
            createESP(v.HumanoidRootPart, v.Name, Color3.fromRGB(0,170,255))
        end
        if espNpcs and v:IsA("Model") and not Players:GetPlayerFromCharacter(v)
           and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") then
            createESP(v.HumanoidRootPart, "NPC", Color3.fromRGB(255,85,0))
        end
    end
end)

-- ===== Aba Aimbot =====
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local aimPlayers, aimNPCs, aimbotOn = false, false, false

AimbotTab:CreateToggle("Aimbot em Players", false, function(v) aimPlayers = v end)
AimbotTab:CreateToggle("Aimbot em NPCs", false, function(v) aimNPCs = v end)
AimbotTab:CreateToggle("Ativar Aimbot", false, function(v) aimbotOn = v end)

local function getClosestTarget()
    local closest, dist = nil, math.huge
    for _, v in pairs(Workspace:GetDescendants()) do
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp and v:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
            if (aimPlayers and isPlayer) or (aimNPCs and not isPlayer) then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if mag < dist and mag < 100 then
                    dist = mag
                    closest = hrp
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local target = getClosestTarget()
        if target then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                LocalPlayer.Character.HumanoidRootPart.Position,
                target.Position
            )
        end
    end
end)
