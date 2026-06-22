-- ADVANCED FRUIT FINDER V1.2 - KAVO MOBILE EDITION
local KavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoUi.CreateLib("Advanced Fruit Finder | V1.2", "BloodTheme")

-- AYARLAR
local Settings = {
    FruitEsp = false,
    FruitTracers = false,
    AutoTpEnabled = false,
    TpFilter = "Kapalı"
}

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- MEYVE TABLOSU
local FruitESPs = {}

local function GetFruitInfo(FruitName)
    local name = string.lower(FruitName)
    if string.find(name, "kitsune") or string.find(name, "dragon") or string.find(name, "leopard") or string.find(name, "dough") or string.find(name, "t-rex") or string.find(name, "spirit") or string.find(name, "venom") or string.find(name, "shadow") or string.find(name, "mammoth") then
        return "Mythical", Color3.fromRGB(255, 0, 50)
    elseif string.find(name, "blizzard") or string.find(name, "rumble") or string.find(name, "portal") or string.find(name, "phoenix") or string.find(name, "sound") or string.find(name, "spider") or string.find(name, "love") or string.find(name, "buddha") or string.find(name, "quake") then
        return "Legendary", Color3.fromRGB(160, 32, 240)
    elseif string.find(name, "magma") or string.find(name, "ghost") or string.find(name, "barrier") or string.find(name, "rubber") or string.find(name, "light") or string.find(name, "diamond") then
        return "Rare", Color3.fromRGB(0, 100, 255)
    elseif string.find(name, "sand") or string.find(name, "dark") or string.find(name, "ice") or string.find(name, "falcon") or string.find(name, "flame") then
        return "Uncommon", Color3.fromRGB(0, 255, 100)
    else
        return "Common", Color3.fromRGB(150, 150, 150)
    end
end

-- IŞINLANMA
local function TeleportToFruit(FruitModel)
    local Handle = FruitModel:FindFirstChild("Handle") or FruitModel:FindFirstChildWhichIsA("Part")
    if Handle then
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = Handle.CFrame + Vector3.new(0, 4, 0)
        end
    end
end

-- MEYVE TARAYICI (Model + Tool)
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

-- ESP RENDER DÖNGÜSÜ
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

-- OTO TOPLAMA DÖNGÜSÜ
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoTpEnabled and Settings.TpFilter ~= "Kapalı" then
            for fruit, _ in pairs(FruitESPs) do
                if fruit and fruit:Parent then
                    local Rarity = GetFruitInfo(fruit.Name)
                    local TargetFound = false
                    
                    if Settings.TpFilter == "Hepsini Topla" then
                        TargetFound = true
                    elseif Settings.TpFilter == "Legendary+" and (Rarity == "Legendary" or Rarity == "Mythical") then
                        TargetFound = true
                    elseif Settings.TpFilter == "Sadece Mythical" and Rarity == "Mythical" then
                        TargetFound = true
                    end
                    
                    if TargetFound then
                        TeleportToFruit(fruit)
                        task.wait(2)
                        break
                    end
                end
            end
        end
    end
end)

-- KAVO GUI MENÜSÜ
local MainTab = Window:NewTab("Meyve Radarı")
local MainSection = MainTab:NewSection("Görsel Ayarlar")

MainSection:NewToggle("Meyve ESP Aktif", "Meyvelerin etrafına kutu çizer.", function(v)
    Settings.FruitEsp = v
end)

MainSection:NewToggle("Meyve Çizgileri (Tracers)", "Ekranın altından meyveye çizgi çeker.", function(v)
    Settings.FruitTracers = v
end)

local TpTab = Window:NewTab("Işınlanma")
local TpSection = TpTab:NewSection("Işınlanma Kontrolleri")

TpSection:NewButton("En Yakındaki Meyveye Git", "Haritadaki en yakın meyveye ışınlar.", function()
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
        if ClosestFruit then TeleportToFruit(ClosestFruit) end
    end
end)

TpSection:NewToggle("Oto-Işınlanma Aktif", "Yeni meyve düşünce otomatik gider.", function(v)
    Settings.AutoTpEnabled = v
end)

TpSection:NewDropdown("Nadirlik Filtresi", "Hangi nadirlikteki meyveler toplansın?", {"Kapalı", "Sadece Mythical", "Legendary+", "Hepsini Topla"}, function(v)
    Settings.TpFilter = v
end)
