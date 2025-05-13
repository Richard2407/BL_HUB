-- BL HUB Otimizado | Blox Fruits

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Utils
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

-- Configs
local npcSelecionado = "Bandit"
local AutoFarmAtivo = false
local usarSkills = false

-- UI
local Janela = Rayfield:CreateWindow({
    Name = "BL HUB",
    LoadingTitle = "BL HUB",
    LoadingSubtitle = "Script Otimizado por Richard2407",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BLHub",
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
-- ABA AUTOFARM
-- =====================
local AutoTab = Janela:CreateTab("AutoFarm", 4483362458)
local npcList = {
    "Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Desert Bandit", "Desert Officer",
    "Snow Bandit", "Snowman", "Chief Petty Officer", "Sky Bandit", "Dark Master",
    "Toga Warrior", "Gladiator", "Military Soldier", "Fishman Warrior", "God's Guard"
}

AutoTab:CreateDropdown({
    Name = "Selecionar NPC",
    Options = npcList,
    CurrentOption = npcSelecionado,
    Callback = function(v) npcSelecionado = v end
})

AutoTab:CreateToggle({
    Name = "Ativar AutoFarm",
    CurrentValue = false,
    Callback = function(v) AutoFarmAtivo = v end
})

AutoTab:CreateToggle({
    Name = "Usar Skills (Z/X/C)",
    CurrentValue = false,
    Callback = function(v) usarSkills = v end
})

RunService.Heartbeat:Connect(function()
    if not AutoFarmAtivo then return end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == npcSelecionado and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = v.HumanoidRootPart
            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 3, 5)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) -- clique
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            if usarSkills then
                for _, key in pairs({"Z", "X", "C"}) do
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                end
            end
            break
        end
    end
end)

-- =====================
-- ABA TELEPORTES
-- =====================
local TeleportTab = Janela:CreateTab("Teleportes", 4483362458)
local locais = {
    ["Starter Island"] = CFrame.new(-260, 6, 268),
    ["Jungle"] = CFrame.new(-1617, 11, 157),
    ["Pirate Village"] = CFrame.new(-1145, 4, 3856),
    ["Desert"] = CFrame.new(932, 6, 4486),
    ["Sky Islands"] = CFrame.new(-4842, 717, -2622),
    ["Marine Fortress"] = CFrame.new(-4500, 20, 4260),
    ["Colosseum"] = CFrame.new(-1420, 7, -3015),
    ["Magma Village"] = CFrame.new(-5248, 8, 8460),
    ["Underwater City"] = CFrame.new(61163, 7, 1199)
}

TeleportTab:CreateDropdown({
    Name = "Selecionar Ilha",
    Options = table.pack(unpack((function() local r = {}; for k in pairs(locais) do table.insert(r, k); end; return r end)())),
    CurrentOption = "",
    Callback = function(op)
        if locais[op] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = locais[op]
        end
    end
})

-- =====================
-- ABA MISC
-- =====================
local MiscTab = Janela:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({Name = "Desbugar Personagem", Callback = function() LocalPlayer.Character:BreakJoints() end})
MiscTab:CreateButton({Name = "Reentrar no Servidor", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})

MiscTab:CreateSlider({
    Name = "Velocidade do Jogador",
    Range = {16, 100}, Increment = 1, CurrentValue = 16,
    Callback = function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

MiscTab:CreateToggle({
    Name = "Habilidades Infinitas",
    CurrentValue = false,
    Callback = function(val)
        if val then
            for _, v in pairs(getgc(true)) do
                if type(v) == "function" and getinfo(v).name == "GetCooldown" then
                    hookfunction(v, function() return 0 end)
                end
            end
        end
    end
})

-- =====================
-- Créditos
-- =====================
local CreditosTab = Janela:CreateTab("Créditos", 4483362458)
CreditosTab:CreateParagraph({Title = "Script feito por", Content = "Richard2407\nBL HUB para Blox Fruits\nVersão otimizada com ESP, Aimbot, AutoFarm e muito mais."})
