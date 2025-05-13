-- Carregando Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Definindo variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Função para criar ESP
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

-- Função para limpar ESP
local function clearESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:FindFirstChild("BLHUB_ESP") then
            v.BLHUB_ESP:Destroy()
        end
    end
end

-- Criando janela com Rayfield
local Janela = Rayfield:CreateWindow({
    Name = "Redz Hub",
    LoadingTitle = "Redz Hub",
    LoadingSubtitle = "Script Otimizado por Richard2407",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RedzHub",
        FileName = "Config"
    }
})

-- =====================
-- ABA ESP
-- =====================
local espFrutas, espBaus, espPlayers, espNpcs = false, false, false, false
local ESPTab = Janela:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({Name = "ESP Frutas", CurrentValue = false, Callback = function(v) espFrutas = v end})
ESPTab:CreateToggle({Name = "ESP Baús", CurrentValue = false, Callback = function(v) espBaus = v end})
ESPTab:CreateToggle({Name = "ESP Jogadores", CurrentValue = false, Callback = function(v) espPlayers = v end})
ESPTab:CreateToggle({Name = "ESP NPCs", CurrentValue = false, Callback = function(v) espNpcs = v end})

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
        if espNpcs and v:IsA("Model") and not Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") then
            createESP(v.HumanoidRootPart, "NPC", Color3.fromRGB(255,85,0))
        end
    end
end)

-- =====================
-- ABA AIMBOT
-- =====================
local AimbotTab = Janela:CreateTab("Aimbot", 4483362458)
local aimPlayers, aimNPCs, aimbotOn = false, false, false

AimbotTab:CreateToggle({Name = "Aimbot em Players", CurrentValue = false, Callback = function(v) aimPlayers = v end})
AimbotTab:CreateToggle({Name = "Aimbot em NPCs", CurrentValue = false, Callback = function(v) aimNPCs = v end})
AimbotTab:CreateToggle({Name = "Ativar Aimbot", CurrentValue = false, Callback = function(v) aimbotOn = v end})

local function getAlvoMaisProximo()
    local alvo, menor = nil, math.huge
    for _, v in pairs(Workspace:GetDescendants()) do
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp and v:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
            if (aimPlayers and isPlayer) or (aimNPCs and not isPlayer) then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < menor and dist < 100 then
                    menor = dist
                    alvo = hrp
                end
            end
        end
    end
    return alvo
end

RunService.RenderStepped:Connect(function()
    if aimbotOn then
        local alvo = getAlvoMaisProximo()
        if alvo then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, alvo.Position)
        end
    end
end)

-- =====================
-- ABA CRÉDITOS
-- =====================
local CreditosTab = Janela:CreateTab("Créditos", 4483362458)
CreditosTab:CreateParagraph({Title = "Script feito por", Content = "Richard2407\nRedz Hub para Blox Fruits\nVersão otimizada com ESP, Aimbot e muito mais."})
