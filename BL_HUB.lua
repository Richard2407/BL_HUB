
-- BL HUB - Script Completo para Blox Fruits

-- Carrega Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Funções auxiliares
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

-- Interface principal
local Window = Rayfield:CreateWindow({
   Name = "BL HUB",
   LoadingTitle = "BL HUB",
   LoadingSubtitle = "Script Personalizado",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BLHub",
      FileName = "Config"
   }
})

-- ==============================
-- TAB ESP
-- ==============================
local ESPTab = Window:CreateTab("ESP", 4483362458)
local espFrutas = false
local espBaus = false
local espPlayers = false
local espNpcs = false

ESPTab:CreateToggle({
   Name = "ESP Frutas",
   CurrentValue = false,
   Callback = function(val)
      espFrutas = val
   end
})

ESPTab:CreateToggle({
   Name = "ESP Baús",
   CurrentValue = false,
   Callback = function(val)
      espBaus = val
   end
})

ESPTab:CreateToggle({
   Name = "ESP Jogadores",
   CurrentValue = false,
   Callback = function(val)
      espPlayers = val
   end
})

ESPTab:CreateToggle({
   Name = "ESP NPCs",
   CurrentValue = false,
   Callback = function(val)
      espNpcs = val
   end
})

RunService.RenderStepped:Connect(function()
    clearESP()
    for _, v in pairs(Workspace:GetDescendants()) do
        if espFrutas and v:IsA("Tool") and v:FindFirstChild("Handle") then
            createESP(v.Handle, "Fruta", Color3.fromRGB(0, 255, 127))
        end
        if espBaus and v.Name:lower():find("chest") then
            createESP(v, "Baú", Color3.fromRGB(255, 255, 0))
        end
        if espPlayers and v:IsA("Model") and Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") then
            createESP(v.HumanoidRootPart, v.Name, Color3.fromRGB(0, 170, 255))
        end
        if espNpcs and v:IsA("Model") and not Players:GetPlayerFromCharacter(v) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") then
            createESP(v.HumanoidRootPart, "NPC", Color3.fromRGB(255, 85, 0))
        end
    end
end)

-- ==============================
-- TAB AIMBOT
-- ==============================
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local aimAtPlayers = false
local aimAtNPCs = false
local aimbotEnabled = false

AimbotTab:CreateToggle({
   Name = "Aimbot em Players",
   CurrentValue = false,
   Callback = function(v) aimAtPlayers = v end
})

AimbotTab:CreateToggle({
   Name = "Aimbot em NPCs",
   CurrentValue = false,
   Callback = function(v) aimAtNPCs = v end
})

AimbotTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Callback = function(v) aimbotEnabled = v end
})

local function getClosestTarget()
    local closest, dist = nil, math.huge
    for _, v in pairs(Workspace:GetDescendants()) do
        local hrp = v:FindFirstChild("HumanoidRootPart")
        if hrp and v:FindFirstChildOfClass("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(v) ~= nil
            if (aimAtPlayers and isPlayer) or (aimAtNPCs and not isPlayer) then
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
    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                LocalPlayer.Character.HumanoidRootPart.Position,
                Vector3.new(target.Position.X, target.Position.Y, target.Position.Z)
            )
        end
    end
end)

-- ==============================
-- TAB MISC
-- ==============================
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Desbugar
MiscTab:CreateButton({
   Name = "Desbugar Personagem",
   Callback = function()
      LocalPlayer.Character:BreakJoints()
   end,
})

-- Rejoin
MiscTab:CreateButton({
   Name = "Reentrar no Servidor",
   Callback = function()
      local ts = game:GetService("TeleportService")
      ts:Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- Velocidade
MiscTab:CreateSlider({
   Name = "Velocidade do Jogador",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Dash infinito
MiscTab:CreateToggle({
   Name = "Dash Infinito",
   CurrentValue = false,
   Callback = function(val)
      if val then
         local mt = getrawmetatable(game)
         setreadonly(mt, false)
         local old = mt.__namecall
         mt.__namecall = newcclosure(function(...)
            local args = {...}
            if getnamecallmethod() == "FireServer" and tostring(args[1]) == "Dash" then
               return nil -- Cancela o gasto de energia
            end
            return old(...)
         end)
      end
   end
})

-- Habilidades infinitas (sem cooldown)
MiscTab:CreateToggle({
   Name = "Habilidades Infinitas",
   CurrentValue = false,
   Callback = function(val)
      if val then
         for _, v in pairs(getgc(true)) do
            if type(v) == "function" and getinfo(v).name == "GetCooldown" then
               hookfunction(v, function(...) return 0 end)
            end
         end
      end
   end
})
