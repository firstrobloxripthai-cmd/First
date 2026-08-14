-- FIRST HUB V1 - Professional Edition
-- Clean & Optimized Code for Public Distribution

local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- [1] ระบบเล่นเสียงตอนรัน (Configurable)
local function PlayExecutionSound(url)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.Name = "FIRST_HUB_Exec"
        sound.Volume = 1
        sound.Parent = SoundService
        
        -- ถ้าตัวรันรองรับการโหลดไฟล์ ให้โหลดไฟล์มาเล่น
        if getcustomasset and writefile and isfile then
            local path = "first_hub_intro.mp3"
            if not isfile(path) then
                local success, data = pcall(function() return game:HttpGet(url) end)
                if success then writefile(path, data) end
            end
            if isfile(path) then sound.SoundId = getcustomasset(path) end
        end
        
        -- ถ้าโหลดไม่ได้ หรือไม่มีฟังก์ชัน ให้ใช้ ID สำรอง (ถ้ามี)
        if sound.SoundId == "" then sound:Destroy() return end
        
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

-- ใส่ลิ้งค์เสียง MP3 ตรงๆ ที่นี่ (แนะนำ Catbox.moe หรือ GitHub Raw)
PlayExecutionSound("https://github.com/my-files/raw/main/intro.mp3")

-- [2] โหลด WindUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [3] การตั้งค่า Theme
WindUI:AddTheme({
    Name = "BlueWhiteBlack",
    Text = Color3.fromHex("00A2FF"), Title = Color3.fromHex("00A2FF"),
    Icon = Color3.fromHex("00A2FF"), Accent = Color3.fromHex("00A2FF"),
    ElementBackground = Color3.fromHex("0A0A0A"), ToggleBound = Color3.fromHex("00A2FF"),
    Background = Color3.fromHex("050505"), Outline = Color3.fromHex("FFFFFF"),
    DialogBackground = Color3.fromHex("0A0A0A"), DialogButtonCancel = Color3.fromHex("FFFFFF"),
    DialogButtonConfirm = Color3.fromHex("00A2FF"), DialogText = Color3.fromHex("FFFFFF")
})
WindUI:SetTheme("BlueWhiteBlack")

-- [4] ข้อมูลข้อความ (Localization Data)
local Text = {
    Welcome = {
        TH = "ยินดีต้อนรับสู่สคริปต์ FIRST HUB!\n\nผู้สร้าง: @First473000\nผู้สอน: @PISIT SCRIPT ✅️📜",
        EN = "Welcome to FIRST HUB Script!\n\nCreator: @First473000\nTutor: @PISIT SCRIPT ✅️📜"
    },
    LangBtn = {
        TH = "เลือกภาษา / Select Language",
        EN = "Select Language / เลือกภาษา"
    }
}

-- [5] สร้าง Window
local Window = WindUI:CreateWindow({
    Title = "FIRST HUB V1",
    Icon = "rbxassetid://94503891790642",
    Background = "rbxassetid://112440852959974",
    Author = "by .ftgs",
    OpenButton = {
        Title = "Open UI", Icon = "monitor", CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2, OnlyMobile = false, Enabled = true, Draggable = true
    }
})

-- [6] สร้าง UI Elements
local MainTab = Window:Tab({ Title = "Main", Icon = "bird" })
MainTab:Select()

local WelcomeLabel = MainTab:Paragraph({ Title = "FIRST HUB V1", Desc = Text.Welcome.TH })

local LangSelect = MainTab:Dropdown({
    Title = Text.LangBtn.TH,
    Values = {"ภาษาไทย (TH)", "English (EN)"},
    Value = "ภาษาไทย (TH)",
    Callback = function(val)
        local isTH = (val == "ภาษาไทย (TH)")
        WelcomeLabel:SetDesc(isTH and Text.Welcome.TH or Text.Welcome.EN)
        LangSelect:SetTitle(isTH and Text.LangBtn.TH or Text.LangBtn.EN)
    end
})

Window:SetUser({ Username = LocalPlayer.Name, DisplayName = LocalPlayer.DisplayName, UserId = LocalPlayer.UserId })

