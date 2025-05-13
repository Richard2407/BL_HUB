--[[ 
    Módulo de Utilitários para o BL HUB
    Inclui função de criação de ESP (BillboardGui acima de partes)
]]

local Utils = {}

-- Cria um ESP visual acima de uma parte (ex: Head do inimigo)
-- @param part: Instance - a parte onde o ESP será colocado
-- @param text: string - o texto que será exibido
-- @param color: Color3 (opcional) - cor do texto, padrão: branco
function Utils.createESP(part, text, color)
    -- Verifica se já existe um ESP nessa parte
    if part:FindFirstChild("BLHUB_ESP") then return end

    -- Criando o BillboardGui
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "BLHUB_ESP"
    BillboardGui.Adornee = part
    BillboardGui.Size = UDim2.new(0, 100, 0, 40)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    BillboardGui.AlwaysOnTop = true

    -- Texto do ESP
    local TextLabel = Instance.new("TextLabel", BillboardGui)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = color or Color3.new(1, 1, 1)
    TextLabel.TextScaled = true
    TextLabel.Font = Enum.Font.SourceSansBold

    BillboardGui.Parent = part
end

return Utils
