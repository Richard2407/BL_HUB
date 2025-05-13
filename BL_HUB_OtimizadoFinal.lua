local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Carregando utilitários do repositório
local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/Richard2407/BL_HUB/main/utils.lua"))()

-- Função auxiliar para obter chaves da tabela
local function tableKeys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

-- Loop de renderização com ESP básico
RunService.RenderStepped:Connect(function()
    local enemy = workspace:FindFirstChild("Dummy")
    if enemy and enemy:IsA("Model") and enemy:FindFirstChild("Head") then
        if not enemy.Head:FindFirstChildOfClass("BillboardGui") then
            Utils.createESP(enemy.Head, "Inimigo", Color3.new(1, 0, 0))
        end
    end
end)

-- Interface do BL HUB
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = library.CreateLib("BL HUB", "Ocean")

-- Aba Misc
local miscTab = Window:CreateTab("Misc", 4483362458)

miscTab:CreateButton({
    Name = "Velocidade Máxima",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 500
        end
    end
})

-- Teleportes
local Teleports = {
    ["Starter Island"] = CFrame.new(-260, 6, 268),
    ["Jungle"] = CFrame.new(-1617, 11, 157),
    ["Pirate Village"] = CFrame.new(-1145, 4, 3856),
    ["Desert"] = CFrame.new(932, 6, 4486),
    ["Middle Island"] = CFrame.new(-531, 7, 473),
    ["Sky Islands"] = CFrame.new(-4842, 717, -2622),
    ["Marine Fortress"] = CFrame.new(-4500, 20, 4260),
    ["Colosseum"] = CFrame.new(-1420, 7, -3015),
    ["Magma Village"] = CFrame.new(-5248, 8, 8460),
    ["Underwater City"] = CFrame.new(61163, 7, 1199)
}

local teleportTab = Window:CreateTab("Teleportes", 4483362458)

teleportTab:CreateDropdown({
    Name = "Selecionar Ilha",
    Options = tableKeys(Teleports),
    CurrentOption = "",
    Callback = function(option)
        local cf = Teleports[option]
        if cf and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end
})
