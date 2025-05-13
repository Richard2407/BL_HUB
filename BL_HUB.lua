-- BL HUB (Versão Otimizada)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players, RunService, Workspace, TeleportService = game:GetService("Players"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Utilitários
local function createESP(part, text, color)
    if part:FindFirstChild("BLHUB_ESP") then return end
    local esp = Instance.new("BillboardGui", part)
    esp.Name = "BLHUB_ESP"
    esp.Size = UDim2.new(0, 100, 0, 40)
    esp.AlwaysOnTop, esp.Adornee = true, part

    local label = Instance.new("TextLabel", esp)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency, label.TextScaled = 1, true
    label.Text, label.TextColor3 = text, color
end

local function clearESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        local gui = v:FindFirstChild("BLHUB_ESP")
        if gui then gui:Destroy() end
    end
end

-- Interface
local Window = Rayfield:CreateWindow({
    Name = "BL HUB",
    LoadingTitle = "BL HUB",
    LoadingSubtitle = "Script Personalizado",
    ConfigurationSaving = { Enabled = false }
})

-- ABA ESP
local ESPTab = Window:CreateTab("ESP", 4483362458)
local options = { frutas = false, baus = false, players = false, npcs = false }

for key, name in pairs({ frutas = "ESP Frutas", baus = "ESP Baús", players = "ESP Jogadores", npcs = "ESP NPCs" }) do
    ESPTab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Callback = function(val) options[key] = val end
    })
end

RunService.RenderStepped:Connect(function()
    clearESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local isTool, isModel = obj:IsA("Tool") and obj:FindFirstChild("Handle"), obj:IsA("Model")
        if options.frutas and isTool then
            createESP(obj.Handle, "Fruta", Color3.fromRGB(0, 255, 127))
        elseif options.baus and obj.Name:lower():find("chest") then
            createESP(obj, "Baú", Color3.fromRGB(255, 255, 0))
        elseif isModel then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                if options.players and Players:GetPlayerFromCharacter(obj) then
                    createESP(hrp, obj.Name, Color3.fromRGB(0, 170, 255))
                elseif options.npcs and obj:FindFirstChildOfClass("Humanoid") then
                    createESP(hrp, "NPC", Color3.fromRGB(255, 85, 0))
                end
            end
        end
    end
end)

-- ABA AIMBOT
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local aimSettings = { enabled = false, players = false, npcs = false }

for key, label in pairs({ enabled = "Ativar Aimbot", players = "Aimbot em Players", npcs = "Aimbot em NPCs" }) do
    AimbotTab:CreateToggle({
        Name = label,
        CurrentValue = false,
        Callback = function(val) aimSettings[key] = val end
    })
end

local function getTarget()
    local closest, shortest = nil, 100
    for _, v in ipairs(Workspace:GetDescendants()) do
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp and v:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
            if (aimSettings.players and isPlayer) or (aimSettings.npcs and not isPlayer) then
                local mag = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if mag < shortest then
                    shortest, closest = mag, hrp
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimSettings.enabled then
        local target = getTarget()
        if target then
            local cf = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end
end)

-- ABA MISC
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateButton({
    Name = "Desbugar Personagem",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})

MiscTab:CreateButton({
    Name = "Reentrar no Servidor",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:CreateSlider({
    Name = "Velocidade do Jogador",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end
})

MiscTab:CreateToggle({
    Name = "Dash Infinito",
    CurrentValue = false,
    Callback = function(val)
        if val then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and tostring(self) == "Dash" then return end
                return old(self, ...)
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Habilidades Infinitas",
    CurrentValue = false,
    Callback = function(val)
        if val then
            for _, f in ipairs(getgc(true)) do
                if typeof(f) == "function" and getinfo(f).name == "GetCooldown" then
                    hookfunction(f, function(...) return 0 end)
                end
            end
        end
    end
})
