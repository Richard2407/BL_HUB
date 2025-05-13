
-- BL HUB V3 (Leve + Detecção Automática de Sea)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

-- UI Leve
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("BL HUB", "Ocean")

-- Detectar Sea
local PlaceId = game.PlaceId
local Sea = "Desconhecido"
local npcList = {}
local teleportList = {}

if PlaceId == 2753915549 then
    Sea = "First Sea"
    npcList = {
        "Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Desert Bandit",
        "Desert Officer", "Snow Bandit", "Snowman", "Sky Bandit",
        "Dark Master", "Gladiator", "Toga Warrior"
    }
    teleportList = {
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
elseif PlaceId == 4442272183 then
    Sea = "Second Sea"
    npcList = {
        "Raider", "Mercenary", "Swan Pirate", "Factory Staff", "Marine Captain",
        "Zombie", "Vampire", "Snow Trooper", "Winter Warrior", "Lab Subordinate",
        "Test Subject", "Arctic Warrior", "Devil", "Sea Soldier", "Water Fighter"
    }
    teleportList = {
        ["Kingdom of Rose"] = CFrame.new(-395, 73, 278),
        ["Green Zone"] = CFrame.new(-2344, 73, -3216),
        ["Graveyard"] = CFrame.new(-5416, 7, -720),
        ["Dark Arena"] = CFrame.new(3280, 73, -210),
        ["Snow Mountain"] = CFrame.new(1407, 449, -1295),
        ["Hot and Cold"] = CFrame.new(-611, 15, -14466),
        ["Cursed Ship"] = CFrame.new(902, 125, 32885),
        ["Ice Castle"] = CFrame.new(5437, 28, -6204),
        ["Forgotten Island"] = CFrame.new(-3052, 238, -10191)
    }
elseif PlaceId == 7449423635 then
    Sea = "Third Sea"
    npcList = {"Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer", "Elite Pirate"} -- exemplo
    teleportList = {
        ["Port Town"] = CFrame.new(-294, 78, 5468),
        ["Hydra Island"] = CFrame.new(5747, 610, -492),
        ["Great Tree"] = CFrame.new(2300, 25, -6500),
        ["Castle on the Sea"] = CFrame.new(-5072, 314, -3155)
    }
end

-- Título
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateLabel("Você está no: " .. Sea)

-- AutoFarm
local AutoFarmTab = Window:CreateTab("AutoFarm", 4483362458)
local selectedNPC = npcList[1]
local autofarmEnabled, useSkills = false, false

AutoFarmTab:CreateDropdown("Selecionar NPC", npcList, function(option) selectedNPC = option end)
AutoFarmTab:CreateToggle("Ativar AutoFarm", false, function(v) autofarmEnabled = v end)
AutoFarmTab:CreateToggle("Usar Skills (Z/X/C)", false, function(v) useSkills = v end)

RunService.Heartbeat:Connect(function()
    if not autofarmEnabled then return end
    for _, npc in pairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name == selectedNPC and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") and npc:FindFirstChildOfClass("Humanoid").Health > 0 then
            local hrp = npc.HumanoidRootPart
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 3, 5)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                if useSkills then
                    for _, key in ipairs({"Z", "X", "C"}) do
                        VirtualInputManager:SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, key, false, game)
                    end
                end
            end
            break
        end
    end
end)

-- Teleporte
local TeleportTab = Window:CreateTab("Teleportes", 4483362458)
local ilhas = {}; for nome in pairs(teleportList) do table.insert(ilhas, nome) end

TeleportTab:CreateDropdown("Selecionar Ilha", ilhas, function(option)
    local cf = teleportList[option]
    if cf and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = cf
    end
end)

-- Misc
local MiscTab = Window:CreateTab("Misc", 4483362458)
local velocidadeDesejada = 16

MiscTab:CreateSlider("Velocidade", 16, 100, function(val)
    velocidadeDesejada = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = velocidadeDesejada
    end
end)

MiscTab:CreateToggle("Habilidades sem cooldown", false, function(val)
    if val then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getinfo(v).name == "GetCooldown" then
                hookfunction(v, function(...) return 0 end)
            end
        end
    end
end)

MiscTab:CreateButton("Reentrar Servidor", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MiscTab:CreateButton("Desbugar Personagem", function()
    LocalPlayer.Character:BreakJoints()
end)
