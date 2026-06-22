-- G&G AFF Kesin Teşhis Sistemi
local repoUrl = "https://raw.githubusercontent.com/Gokalpgokcee/AdvencedFruitFinder/main/AdvencedFruitFinder.lua"
local success, content = pcall(game.HttpGet, game, repoUrl)

local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 10
    })
end

if not success then
    notify("AFF HATA", "GitHub baglantisi Delta tarafindan engellendi!")
elseif content == "404: Not Found" then
    notify("AFF HATA", "404 Hatasi! Repo hala PRIVATE (Gizli) veya dosya adi hatali!")
elseif string.len(content) < 10 then
    notify("AFF HATA", "Kod indirilmedi, dosya ici bos görünüyor!")
else
    notify("AFF BAŞARILI", "Kod cekildi! Simdi calistirmayi deniyorum...")
    task.wait(1)
    
    local func, err = loadstring(content)
    if not func then
        notify("LUA HATASI", "Kodda yazim hatasi var!")
        print("Yazim Hatasi detayi: ", err)
    else
        local runSuccess, runError = pcall(func)
        if not runSuccess then
            notify("KÜTÜPHANE HATASI", "Orion kütüphanesi Delta'da cöktü!")
            print("Cökme detayi: ", runError)
        end
    end
end
