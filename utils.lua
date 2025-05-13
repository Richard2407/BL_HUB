
-- Utilitários (ESP, Otimizações)
local Utils = {}

function Utils.createESP(part, text, color)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Adornee = part
    BillboardGui.Size = UDim2.new(0, 100, 0, 40)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    BillboardGui.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel", BillboardGui)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = color or Color3.new(1, 1, 1)
    TextLabel.TextScaled = true

    BillboardGui.Parent = part
end

return Utils
