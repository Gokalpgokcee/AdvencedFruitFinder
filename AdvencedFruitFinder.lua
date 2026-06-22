-- ADVANCED FRUIT FINDER - SADECE GUI TESTİ (SIFIRDAN)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AFF Projesi | GUI Testi",
   LoadingTitle = "Advanced Fruit Finder",
   LoadingSubtitle = "by Gokalp Engineering",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

-- TEST SEKMESİ
local TestTab = Window:CreateTab("Görsel Test", nil)
TestTab:CreateSection("Arayüz Durumu")

TestTab:CreateLabel("Eğer bu menüyü ve yazıyı görüyorsan Rayfield aktif!")

Rayfield:Notify({
   Title = "AFF Sistem Notu",
   Content = "Arayüz yükleme testi başarılı!",
   Duration = 5
})
