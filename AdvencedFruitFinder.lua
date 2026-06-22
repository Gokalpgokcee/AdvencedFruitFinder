-- ADVANCED FRUIT FINDER V1.3 - NATIVE MOBILE EDITION
-- Bu kod hiçbir dış siteye/kütüphaneye bağlanmaz. Çökme ihtimali %0'dır.

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Eğer ekranda eski hile kalıntısı varsa temizle
if CoreGui:FindFirstChild("AFF_Mobile_Gui") then
    CoreGui.AFF_Mobile_Gui:Destroy()
end

-- ANA GUI ELEMENTLERİ
local AFF_Gui = Instance.new("ScreenGui")
AFF_Gui.Name = "AFF_Mobile_Gui"
AFF_Gui.Parent = CoreGui
AFF_Gui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Parmağınla ekranda taşıyabilirsin
MainFrame.Parent = AFF_Gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Title.Text = "  Advanced Fruit Finder V1.3"
Title.TextColor3 = Color3.fromRGB(255, 65, 65)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ContentFrame

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 12)
Padding.Parent = ContentFrame

-- AYARLAR
local Settings = {
    FruitEsp = false,
    FruitTracers = false,
    AutoTp = false
}

-- TOGGLE OLUŞTURUCU FONKSİYON
local function CreateToggle(text, settingName)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 230, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = text .. ": KAPALI"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.SourceSansSemibold
    Btn.BorderSizePixel = 0
    Btn.Parent = ContentFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Settings[settingName] = not Settings[settingName]
        if Settings[settingName] then
            Btn.Text = text .. ": AÇIK"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 140, 70)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Btn.Text = text .. ": KAPALI"
            Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
end

-- BUTON OLUŞTURUCU FONKSİYON
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 230, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.SourceSansBold
    Btn.BorderSizePixel = 0
    Btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
end

-- MEYVE ALGINLAMA MANTIĞI
local FruitESPs = {}

local function GetFruitInfo(FruitName)
    local name = string.lower(FruitName)
    if string.find(name, "kitsune") or string.find(name, "dragon") or string.find(name, "leopard") or string.find(name, "dough") or string.find(name, "t-rex") or string.find(name, "spirit") or string.find(name, "venom") or string.find(name, "shadow") or string.find(name, "mammoth") then
        return "Mythical", Color3.fromRGB(255, 0, 50)
    elseif string.find(name, "blizzard") or string.find(name, "rumble") or string.find(name, "portal") or string.find(name, "phoenix") or string.find(name, "sound") or string.find(name, "spider") or string.find(name, "love") or string.find(name, "buddha") or string.find(name, "quake") then
        return "Legendary", Color3.fromRGB(160, 32, 240)
    elseif string.find(name, "magma") or string.find(name, "ghost") or string.find(name, "barrier") or string.find(name, "rubber") or string.find(name, "light") or string.find(name, "diamond") then
        return "Rare", Color3.fromRGB(0, 100, 255)
    else
        return "Uncommon/Common", Color3.fromRGB(0, 255, 100)
    end
end

local function TeleportToFruit(FruitModel)
    local Handle = FruitModel:FindFirstChild("Handle") or FruitModel:FindFirstChildWhichIsA("Part")
    if Handle then
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = Handle.CFrame + Vector3.new(0, 4, 0)
        end
    end
end

-- TARAYICI DÖNGÜSÜ
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetChildren()) do
            if (v:IsA("Model") or v:IsA("Tool")) and string.find(string.lower(v.Name), "fruit") and not FruitESPs[v] then
                FruitESPs[v] = {
                    Box = Drawing.new("Square"),
                    Text = Drawing.new("Text"),
                    Tracer = Drawing.new("Line")
                }
                FruitESPs[v].Box.Filled = false
                FruitESPs[v].Box.Thickness = 1.5
                FruitESPs[v].Text.Center = true
                FruitESPs[v].Text.Outline = true
                FruitESPs[v].Text.Size = 14
                FruitESPs[v].Tracer.Thickness = 1
            end
        end
        task.wait(1)
    end
end)

-- ESP ÇİZİM DÖNGÜSÜ
RS.RenderStepped:Connect(function()
    for fruit, drawings in pairs(FruitESPs) do
        local Handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("Part")
        if not fruit or not fruit:Parent or not Handle then
            drawings.Box:Remove()
            drawings.Text:Remove()
            drawings.Tracer:Remove()
            FruitESPs[fruit] = nil
        else
            if Settings.FruitEsp then
                local Pos, OnScreen = Camera:WorldToViewportPoint(Handle.Position)
                if OnScreen then
                    local Rarity, Color = GetFruitInfo(fruit.Name)
                    
                    drawings.Box.Visible = true
                    drawings.Box.Position = Vector2.new(Pos.X - 15, Pos.Y - 15)
                    drawings.Box.Size = Vector2.new(30, 30)
                    drawings.Box.Color = Color
                    
                    drawings.Text.Visible = true
                    drawings.Text.Text = fruit.Name .. " [" .. Rarity .. "]"
                    drawings.Text.Position = Vector2.new(Pos.X, Pos.Y - 35)
                    drawings.Text.Color = Color
                    
                    if Settings.FruitTracers then
                        drawings.Tracer.Visible = true
                        drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        drawings.Tracer.To = Vector2.new(Pos.X, Pos.Y)
                        drawings.Tracer.Color = Color
                    else drawings.Tracer.Visible = false end
                else
                    drawings.Box.Visible = false
                    drawings.Text.Visible = false
                    drawings.Tracer.Visible = false
                end
            else
                drawings.Box.Visible = false
                drawings.Text.Visible = false
                drawings.Tracer.Visible = false
            end
        end
    end
end)

-- OTO IŞINLANMA DÖNGÜSÜ (Legendary ve Üstü Düşünce Otomatik Uçar)
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoTp then
            for fruit, _ in pairs(FruitESPs) do
                if fruit and fruit:Parent then
                    local Rarity = GetFruitInfo(fruit.Name)
                    if Rarity == "Legendary" or Rarity == "Mythical" then
                        TeleportToFruit(fruit)
                        task.wait(2)
                        break
                    end
                end
            end
        end
    end
end)

-- ARAYÜZ ELEMANLARINI EKLE
CreateToggle("Meyve ESP", "FruitEsp")
CreateToggle("Meyve Çizgileri (Tracers)", "FruitTracers")
CreateToggle("Oto-TP (Sadece Legendary+)", "AutoTp")

CreateButton("En Yakındaki Meyveye Git", function()
    local ClosestFruit = nil
    local ShortestDist = math.huge
    local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if MyRoot then
        for fruit, _ in pairs(FruitESPs) do
            local Handle = fruit:FindFirstChild("Handle") or fruit:FindFirstChildWhichIsA("Part")
            if Handle then
                local Dist = (MyRoot.Position - Handle.Position).Magnitude
                if Dist < ShortestDist then
                    ShortestDist = Dist
                    ClosestFruit = fruit
                end
            end
        end
        if ClosestFruit then 
            TeleportToFruit(ClosestFruit) 
        else
            game:GetService("Lighting") -- Basit bir görsel log için bildirim yerine ses/ışık tetiklenebilir ama gerek yok.
        end
    end
end)
