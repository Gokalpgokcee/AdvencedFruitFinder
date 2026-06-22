local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Advanced Fruit Finder (AFF) | V1.0",
   LoadingTitle = "AFF Project Initializing",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

-- AYARLAR
local Settings = {
    FruitEsp = false,
    FruitTracers = false,
    AutoTpEnabled = false,
    TpFilter = "Kapalı" -- "Kapalı", "Sadece Mythical", "Legendary+", "Hepsini Topla"
}

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- MEYVE TABLOSU VE NADİRLİK/RENK BELİRLEYİCİ
local FruitESPs = {}

local function GetFruitInfo(FruitName)
    local name = string.lower(FruitName)
    if string.find(name, "kitsune") or string.find(name, "dragon") or string.find(name, "leopard") or string.find(name, "dough") or string.find(name, "t-rex") or string.find(name, "spirit") or string.find(name, "venom") or string.find(name, "shadow") or string.find(name, "mammoth") then
        return "Mythical", Color3.fromRGB(255, 0, 50) -- Parlak Kırmızı
    elseif string.find(name, "blizzard") or string.find(name, "rumble") or string.find(name, "portal") or string.find(name, "phoenix") or string.find(name, "sound") or string.find(name, "spider") or string.find(name, "love") or string.find(name, "buddha") or string.find(name, "quake") then
        return "Legendary", Color3.fromRGB(160, 32, 240) -- Mor
    elseif string.find(name, "magma") or string.find(name, "ghost") or string.find(name, "barrier") or string.find(name, "rubber") or string.find(name, "light") or string.find(name, "diamond") then
        return "Rare", Color3.fromRGB(0, 100, 255) -- Mavi
    elseif string.find(name, "sand") or string.find(name, "dark") or string.find(name, "ice") or string.find(name, "falcon") or string.find(name, "flame") then
        return "Uncommon", Color3.fromRGB(0, 255, 100) -- Yeşil
    else
        return "Common", Color3.fromRGB(150, 150, 150) -- Gri
    end
end

-- IŞINLANMA FONKSİYONU
local function TeleportToFruit(FruitModel)
    if FruitModel and FruitModel:FindFirstChild("Handle") then
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = FruitModel.Handle.CFrame + Vector3.new(0, 3, 0)
        end
    end
end

-- MEYVE TARAMA VE ESP DÖNGÜSÜ
task.spawn(function()
    while true do
        for _, v in pairs(workspace:GetChildren()) do
            -- Blox Fruits'te meyveler genelde direkt workspace altında "Fruit" ismiyle veya adıyla model olarak bulunur
            if v:IsA("Model") and string.find(string.lower(v.Name), "fruit") and not FruitESPs[v] then
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

-- RENDER GÜNCELLEME (ESP ÇİZİMİ)
RS.RenderStepped:Connect(function()
    for fruit, drawings in pairs(FruitESPs) do
        if not fruit or not fruit:Parent or not fruit:FindFirstChild("Handle") then
            -- Meyve yenmiş veya silinmişse çizimleri temizle
            drawings.Box:Remove()
            drawings.Text:Remove()
            drawings.Tracer:Remove()
            FruitESPs[fruit] = nil
        else
            if Settings.FruitEsp then
                local Handle = fruit.Handle
                local Pos, OnScreen = Camera:WorldToViewportPoint(Handle.Position)
                
                if OnScreen then
                    local Rarity, Color = GetFruitInfo(fruit.Name)
                    
                    -- Kutu Çizimi
                    drawings.Box.Visible = true
                    drawings.Box.Position = Vector2.new(Pos.X - 15, Pos.Y - 15)
                    drawings.Box.Size = Vector2.new(30, 30)
                    drawings.Box.Color = Color
                    
                    -- İsim ve Nadirlik Metni
                    drawings.Text.Visible = true
                    drawings.Text.Text = fruit.Name .. " [" .. Rarity .. "]"
                    drawings.Text.Position = Vector2.new(Pos.X, Pos.Y - 35)
                    drawings.Text.Color = Color
                    
                    -- Tracer Çizimi
                    if Settings.FruitTracers then
                        drawings.Tracer.Visible = true
                        drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        drawings.Tracer.To = Vector2.new(Pos.X, Pos.Y)
                        drawings.Tracer.Color = Color
                    else
                        drawings.Tracer.Visible = false
                    end
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

-- OTO IŞINLANMA DÖNGÜSÜ
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoTpEnabled and Settings.TpFilter ~= "Kapalı" then
            for fruit, _ in pairs(FruitESPs) do
                if fruit and fruit:FindFirstChild("Handle") then
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
                        Rayfield:Notify({Title = "Meyve Bulundu!", Content = fruit.Name .. " konumuna ışınlanılıyor..."})
                        TeleportToFruit(fruit)
                        task.wait(2) -- Anti-cheat tetiklememek için kısa bekleme süresi
                        break
                    end
                end
            end
        end
    end
end)

-- GUI SEKMELERİ
local MainTab = Window:CreateTab("Meyve Radarı")
local TpTab = Window:CreateTab("Işınlanma")

MainTab:CreateSection("Görsel Ayarlar")
MainTab:CreateToggle({Name = "Meyve ESP Aktif", CurrentValue = false, Callback = function(v) Settings.FruitEsp = v end})
MainTab:CreateToggle({Name = "Meyve Çizgileri (Tracers)", CurrentValue = false, Callback = function(v) Settings.FruitTracers = v end})

TpTab:CreateSection("Manuel Işınlanma")
TpTab:CreateButton({
    Name = "En Yakındaki Meyveye Git",
    Callback = function()
        local ClosestFruit = nil
        local ShortestDist = math.huge
        local MyRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if MyRoot then
            for fruit, _ in pairs(FruitESPs) do
                if fruit and fruit:FindFirstChild("Handle") then
                    local Dist = (MyRoot.Position - fruit.Handle.Position).Magnitude
                    if Dist < ShortestDist then
                        ShortestDist = Dist
                        ClosestFruit = fruit
                    end
                end
            end
            
            if ClosestFruit then
                TeleportToFruit(ClosestFruit)
            else
                Rayfield:Notify({Title = "Hata", Content = "Haritada şu an hiç meyve bulunamadı!"})
            end
        end
    end
})

TpTab:CreateSection("Otomatik Toplama")
TpTab:CreateToggle({Name = "Oto-Işınlanma Aktif", CurrentValue = false, Callback = function(v) Settings.AutoTpEnabled = v end})
TpTab:CreateDropdown({
   Name = "Nadirlik Filtresi",
   Options = {"Kapalı", "Sadece Mythical", "Legendary+", "Hepsini Topla"},
   CurrentOption = "Kapalı",
   Callback = function(Option) Settings.TpFilter = Option end,
})

Rayfield:Notify({Title = "AFF Başlatıldı", Content = "Meyve avı sistemi hazır, bol şans!"})
