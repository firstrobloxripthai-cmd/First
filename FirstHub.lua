-- ================================================
-- FIRST HUB - Electric Blue & Black Edition
-- Designed for Delta X & Universal Executors
-- Image Asset ID: 76108081490279
-- Custom Welcome Audio + Selective Click Sound System
-- ================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- ตัวแปร Asset ID
local LOGO_ID = "rbxassetid://76108081490279"
local CLICK_SOUND_ID = "rbxassetid://138567614125924" -- เสียงคลิก

-- ลิงก์เสียงยินดีต้อนรับจาก Discord Direct Link
local AUDIO_URL = "https://cdn.discordapp.com/attachments/1535496983278657646/1535531421597437992/Generated_Audio_August_05_2026_-_6_30PM.wav?ex=6a781a93&is=6a76c913&hm=3940e5db09d01d84694361bab6dbdc07010e99012e2a22e8d511a74dd47466c7&"
local AUDIO_FILENAME = "FirstHub_Welcome.wav"

-- ตัวแปรควบคุมสถานะล็อก UI
local isUILocked = false

-- 1. สร้าง ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FirstHub_UI"
ScreenGui.ResetOnSpawn = false

local parentTarget
if gethui then
    parentTarget = gethui()
elseif syn and syn.protect_gui then
    parentTarget = syn.protect_gui(ScreenGui)
elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    parentTarget = game:GetService("CoreGui")
else
    parentTarget = LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.Parent = parentTarget

-- ================================================
-- ระบบเสียง Sound Engine & Auto-Bind แบบยกเว้นปุ่ม
-- ================================================

-- 1) เสียงยินดีต้อนรับตอนดาวน์โหลดเสร็จ
local function playWelcomeSound()
    task.spawn(function()
        if not isfile(AUDIO_FILENAME) then
            pcall(function()
                writefile(AUDIO_FILENAME, game:HttpGet(AUDIO_URL))
            end)
        end
        
        if isfile(AUDIO_FILENAME) then
            local soundAsset = getcustomasset(AUDIO_FILENAME)
            if soundAsset then
                local sound = Instance.new("Sound")
                sound.Name = "FirstHub_WelcomeSound"
                sound.SoundId = soundAsset
                sound.Volume = 2
                sound.Parent = SoundService
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)
            end
        end
    end)
end

-- 2) เสียงคลิกเมื่อกดปุ่ม
local function playClickSound()
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.Name = "FirstHub_ClickSound"
        sound.SoundId = CLICK_SOUND_ID
        sound.Volume = 1.5
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end

-- Blur Effect ฉากหลัง
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

-- ฟังก์ชันทำให้ UI ลากได้แบบ Smooth
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if isUILocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isUILocked then return end
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- ================================================
-- 2. หน้าต่างโหลด (Animated Loading Screen)
-- ================================================
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 300, 0, 150)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 12)
LoadingCorner.Parent = LoadingFrame

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Thickness = 2
LoadingStroke.Color = Color3.fromRGB(0, 140, 255)
LoadingStroke.Parent = LoadingFrame

local LoadingLogo = Instance.new("ImageLabel")
LoadingLogo.Name = "LoadingLogo"
LoadingLogo.Size = UDim2.new(0, 50, 0, 50)
LoadingLogo.Position = UDim2.new(0.5, -25, 0, 12)
LoadingLogo.BackgroundTransparency = 1
LoadingLogo.Image = LOGO_ID
LoadingLogo.Parent = LoadingFrame

task.spawn(function()
    while LoadingFrame.Parent do
        TweenService:Create(LoadingLogo, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = 360}):Play()
        task.wait(2)
        LoadingLogo.Rotation = 0
    end
end)

local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "LoadingText"
LoadingText.Size = UDim2.new(1, 0, 0, 20)
LoadingText.Position = UDim2.new(0, 0, 0, 70)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading FIRST HUB..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 13
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Parent = LoadingFrame

local ProgressBarBackground = Instance.new("Frame")
ProgressBarBackground.Name = "ProgressBarBackground"
ProgressBarBackground.Size = UDim2.new(0, 240, 0, 8)
ProgressBarBackground.Position = UDim2.new(0.5, -120, 0, 105)
ProgressBarBackground.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
ProgressBarBackground.BorderSizePixel = 0
ProgressBarBackground.Parent = LoadingFrame

local ProgressBgCorner = Instance.new("UICorner")
ProgressBgCorner.CornerRadius = UDim.new(1, 0)
ProgressBgCorner.Parent = ProgressBarBackground

local ProgressBar = Instance.new("Frame")
ProgressBar.Name = "ProgressBar"
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = ProgressBarBackground

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(1, 0)
ProgressCorner.Parent = ProgressBar

-- ================================================
-- 3. ปุ่มลอย เปิด-ปิด UI (ไม่มีเสียง)
-- ================================================
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0.5, -355, 0.5, -190)
FloatingButton.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
FloatingButton.BorderSizePixel = 0
FloatingButton.Image = LOGO_ID
FloatingButton.Visible = false
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 12)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Thickness = 2
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Parent = FloatingButton

task.spawn(function()
    while true do
        TweenService:Create(FloatStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(0, 162, 255)}):Play()
        task.wait(0.8)
        TweenService:Create(FloatStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        task.wait(0.8)
    end
end)

makeDraggable(FloatingButton, FloatingButton)

-- ================================================
-- 4. Main Frame (หน้าต่างหลัก)
-- ================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 430)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.BackgroundTransparency = 1
MainFrame.Rotation = -5
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

makeDraggable(MainFrame, MainFrame)

-- Header Bar
local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.Size = UDim2.new(1, 0, 0, 48)
HeaderBar.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
HeaderBar.BorderSizePixel = 0
HeaderBar.Parent = MainFrame

local UILogo = Instance.new("ImageLabel")
UILogo.Name = "UILogo"
UILogo.Size = UDim2.new(0, 32, 0, 32)
UILogo.Position = UDim2.new(0, 10, 0, 8)
UILogo.BackgroundTransparency = 1
UILogo.Image = LOGO_ID
UILogo.Parent = HeaderBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 0, 22)
TitleLabel.Position = UDim2.new(0, 48, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FIRST HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = HeaderBar

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Name = "SubTitleLabel"
SubTitleLabel.Size = UDim2.new(0, 200, 0, 14)
SubTitleLabel.Position = UDim2.new(0, 48, 0, 26)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Text = "Be First. Be Legend."
SubTitleLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
SubTitleLabel.TextSize = 10
SubTitleLabel.Font = Enum.Font.GothamMedium
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Parent = HeaderBar

-- ปุ่มปิด ✕ (ไม่มีเสียง)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = HeaderBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- ปุ่มสลับภาษา (TH / EN)
local LangBtn = Instance.new("TextButton")
LangBtn.Name = "LangBtn"
LangBtn.Size = UDim2.new(0, 80, 0, 30)
LangBtn.Position = UDim2.new(1, -126, 0, 9)
LangBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
LangBtn.Text = "TH 🇹🇭"
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 12
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Parent = HeaderBar

local LangCorner = Instance.new("UICorner")
LangCorner.CornerRadius = UDim.new(0, 6)
LangCorner.Parent = LangBtn

local LangStroke = Instance.new("UIStroke")
LangStroke.Thickness = 1
LangStroke.Color = Color3.fromRGB(0, 150, 255)
LangStroke.Parent = LangBtn

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 165, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 48)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 18, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = Sidebar

-- ปุ่มเลือกหมวดหมู่ (ไม่มีเสียง)
local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Name = "MainTabBtn"
MainTabBtn.Size = UDim2.new(1, 0, 0, 38)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
MainTabBtn.Text = "  🏠 หลัก"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 13
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextXAlignment = Enum.TextXAlignment.Left
MainTabBtn.Parent = Sidebar

local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 8)
MainTabCorner.Parent = MainTabBtn

-- ================================================
-- 5. หน้าหมวดหมู่หลัก (Main Tab Page)
-- ================================================
local MainTabPage = Instance.new("ScrollingFrame")
MainTabPage.Name = "MainTabPage"
MainTabPage.Size = UDim2.new(1, -177, 1, -58)
MainTabPage.Position = UDim2.new(0, 171, 0, 53)
MainTabPage.BackgroundTransparency = 1
MainTabPage.BorderSizePixel = 0
MainTabPage.ScrollBarThickness = 4
MainTabPage.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
MainTabPage.Parent = MainFrame

local PageListLayout = Instance.new("UIListLayout")
PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageListLayout.Padding = UDim.new(0, 10)
PageListLayout.Parent = MainTabPage

-- 5.1 การ์ดต้อนรับ
local WelcomeCard = Instance.new("Frame")
WelcomeCard.Name = "WelcomeCard"
WelcomeCard.Size = UDim2.new(1, -10, 0, 45)
WelcomeCard.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
WelcomeCard.BorderSizePixel = 0
WelcomeCard.Parent = MainTabPage

local WelcomeCorner = Instance.new("UICorner")
WelcomeCorner.CornerRadius = UDim.new(0, 8)
WelcomeCorner.Parent = WelcomeCard

local WelcomeStroke = Instance.new("UIStroke")
WelcomeStroke.Thickness = 1
WelcomeStroke.Color = Color3.fromRGB(0, 150, 255)
WelcomeStroke.Parent = WelcomeCard

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Name = "WelcomeLabel"
WelcomeLabel.Size = UDim2.new(1, -20, 1, 0)
WelcomeLabel.Position = UDim2.new(0, 10, 0, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "ยินดีต้อนรับสู่สคริปต์First HUB"
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.TextSize = 14
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.Parent = WelcomeCard

-- 5.2 รูปภาพขนาดใหญ่
local BigImageFrame = Instance.new("Frame")
BigImageFrame.Name = "BigImageFrame"
BigImageFrame.Size = UDim2.new(1, -10, 0, 190)
BigImageFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
BigImageFrame.BorderSizePixel = 0
BigImageFrame.Parent = MainTabPage

local BigImageCorner = Instance.new("UICorner")
BigImageCorner.CornerRadius = UDim.new(0, 8)
BigImageCorner.Parent = BigImageFrame

local BigImageStroke = Instance.new("UIStroke")
BigImageStroke.Thickness = 1
BigImageStroke.Color = Color3.fromRGB(0, 150, 255)
BigImageStroke.Parent = BigImageFrame

local BigLogo = Instance.new("ImageLabel")
BigLogo.Name = "BigLogo"
BigLogo.Size = UDim2.new(0, 175, 0, 175)
BigLogo.Position = UDim2.new(0.5, -87, 0.5, -87)
BigLogo.BackgroundTransparency = 1
BigLogo.Image = LOGO_ID
BigLogo.Parent = BigImageFrame

-- 5.3 การ์ดรายละเอียดผู้สร้าง
local InfoPanel = Instance.new("Frame")
InfoPanel.Name = "InfoPanel"
InfoPanel.Size = UDim2.new(1, -10, 0, 130)
InfoPanel.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
InfoPanel.BorderSizePixel = 0
InfoPanel.Parent = MainTabPage

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoPanel

local InfoStroke = Instance.new("UIStroke")
InfoStroke.Thickness = 1
InfoStroke.Color = Color3.fromRGB(0, 150, 255)
InfoStroke.Parent = InfoPanel

local CreatorText = Instance.new("TextLabel")
CreatorText.Name = "CreatorText"
CreatorText.Size = UDim2.new(1, -20, 0, 22)
CreatorText.Position = UDim2.new(0, 12, 0, 10)
CreatorText.BackgroundTransparency = 1
CreatorText.Text = "ผู้สร้างสคริปต์: Tiktok: @ First473000"
CreatorText.TextColor3 = Color3.fromRGB(255, 255, 255)
CreatorText.TextSize = 11
CreatorText.Font = Enum.Font.GothamMedium
CreatorText.TextXAlignment = Enum.TextXAlignment.Left
CreatorText.Parent = InfoPanel

local TeacherText = Instance.new("TextLabel")
TeacherText.Name = "TeacherText"
TeacherText.Size = UDim2.new(1, -20, 0, 22)
TeacherText.Position = UDim2.new(0, 12, 0, 38)
TeacherText.BackgroundTransparency = 1
TeacherText.Text = "ผู้สอน: Tiktok: @ PISIT SCRIPT✅️📜"
TeacherText.TextColor3 = Color3.fromRGB(220, 220, 220)
TeacherText.TextSize = 11
TeacherText.Font = Enum.Font.GothamMedium
TeacherText.TextXAlignment = Enum.TextXAlignment.Left
TeacherText.Parent = InfoPanel

local CampText = Instance.new("TextLabel")
CampText.Name = "CampText"
CampText.Size = UDim2.new(1, -20, 0, 22)
CampText.Position = UDim2.new(0, 12, 0, 66)
CampText.BackgroundTransparency = 1
CampText.Text = "ค่าย: Tiktok: @ ค่ายPISIT HUB❤️"
CampText.TextColor3 = Color3.fromRGB(220, 220, 220)
CampText.TextSize = 11
CampText.Font = Enum.Font.GothamMedium
CampText.TextXAlignment = Enum.TextXAlignment.Left
CampText.Parent = InfoPanel

local CampNameText = Instance.new("TextLabel")
CampNameText.Name = "CampNameText"
CampNameText.Size = UDim2.new(1, -20, 0, 22)
CampNameText.Position = UDim2.new(0, 12, 0, 94)
CampNameText.BackgroundTransparency = 1
CampNameText.Text = "ชื่อค่าย: PISIT HUB😇"
CampNameText.TextColor3 = Color3.fromRGB(0, 180, 255)
CampNameText.TextSize = 12
CampNameText.Font = Enum.Font.GothamBold
CampNameText.TextXAlignment = Enum.TextXAlignment.Left
CampNameText.Parent = InfoPanel

-- 5.4 ปุ่มฟังก์ชัน "ล็อก UI"
local LockToggleBtn = Instance.new("TextButton")
LockToggleBtn.Name = "LockToggleBtn"
LockToggleBtn.Size = UDim2.new(1, -10, 0, 42)
LockToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
LockToggleBtn.Text = "🔒 ล็อก UI: ปิด (ขยับได้)"
LockToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockToggleBtn.TextSize = 12
LockToggleBtn.Font = Enum.Font.GothamBold
LockToggleBtn.Parent = MainTabPage

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockToggleBtn

local LockStroke = Instance.new("UIStroke")
LockStroke.Thickness = 1
LockStroke.Color = Color3.fromRGB(0, 150, 255)
LockStroke.Parent = LockToggleBtn

-- 5.5 ปุ่มลบ UI
local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Name = "DestroyBtn"
DestroyBtn.Size = UDim2.new(1, -10, 0, 42)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
DestroyBtn.Text = "🗑️ ลบ UI ทิ้งอย่างถาวร"
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.TextSize = 12
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.Parent = MainTabPage

local DestroyCorner = Instance.new("UICorner")
DestroyCorner.CornerRadius = UDim.new(0, 8)
DestroyCorner.Parent = DestroyBtn

local DestroyStroke = Instance.new("UIStroke")
DestroyStroke.Thickness = 1
DestroyStroke.Color = Color3.fromRGB(255, 100, 100)
DestroyStroke.Parent = DestroyBtn

-- ================================================
-- 6. หน้าต่างยืนยันการลบ UI
-- ================================================
local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "ConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmOverlay.BackgroundTransparency = 0.6
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 10
ConfirmOverlay.Parent = MainFrame

local ConfirmBox = Instance.new("Frame")
ConfirmBox.Name = "ConfirmBox"
ConfirmBox.Size = UDim2.new(0, 320, 0, 140)
ConfirmBox.Position = UDim2.new(0.5, -160, 0.5, -70)
ConfirmBox.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
ConfirmBox.BorderSizePixel = 0
ConfirmBox.ZIndex = 11
ConfirmBox.Parent = ConfirmOverlay

local ConfirmCorner = Instance.new("UICorner")
ConfirmCorner.CornerRadius = UDim.new(0, 10)
ConfirmCorner.Parent = ConfirmBox

local ConfirmStroke = Instance.new("UIStroke")
ConfirmStroke.Thickness = 2
ConfirmStroke.Color = Color3.fromRGB(0, 150, 255)
ConfirmStroke.Parent = ConfirmBox

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Name = "ConfirmText"
ConfirmText.Size = UDim2.new(1, -20, 0, 50)
ConfirmText.Position = UDim2.new(0, 10, 0, 15)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Text = "คุณต้องการลบ UI ทิ้งอย่างถาวรใช่หรือไม่?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.TextSize = 14
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.TextWrapped = true
ConfirmText.TextXAlignment = Enum.TextXAlignment.Center
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmBox

local YesBtn = Instance.new("TextButton")
YesBtn.Name = "YesBtn"
YesBtn.Size = UDim2.new(0, 135, 0, 35)
YesBtn.Position = UDim2.new(0, 15, 0, 85)
YesBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
YesBtn.Text = "ยืนยัน (ใช่)"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextSize = 13
YesBtn.Font = Enum.Font.GothamBold
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmBox

local YesCorner = Instance.new("UICorner")
YesCorner.CornerRadius = UDim.new(0, 6)
YesCorner.Parent = YesBtn

local NoBtn = Instance.new("TextButton")
NoBtn.Name = "NoBtn"
NoBtn.Size = UDim2.new(0, 135, 0, 35)
NoBtn.Position = UDim2.new(1, -150, 0, 85)
NoBtn.BackgroundColor3 = Color3.fromRGB(35, 42, 55)
NoBtn.Text = "ยกเลิก"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.TextSize = 13
NoBtn.Font = Enum.Font.GothamBold
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmBox

local NoCorner = Instance.new("UICorner")
NoCorner.CornerRadius = UDim.new(0, 6)
NoCorner.Parent = NoBtn

-- ฟังก์ชันทำงานเมื่อกดปุ่ม "ล็อก UI"
LockToggleBtn.MouseButton1Click:Connect(function()
    isUILocked = not isUILocked

    if currentLang == "TH" then
        if isUILocked then
            LockToggleBtn.Text = "🔒 ล็อก UI: เปิด (ไม่ขยับ)"
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
        else
            LockToggleBtn.Text = "🔒 ล็อก UI: ปิด (ขยับได้)"
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
        end
    else
        if isUILocked then
            LockToggleBtn.Text = "🔒 Lock UI: ON (Locked)"
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 100)
        else
            LockToggleBtn.Text = "🔒 Lock UI: OFF (Draggable)"
            LockToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
        end
    end
end)

-- ฟังก์ชันเปิดหน้าต่างยืนยันลบ
DestroyBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = true
end)

YesBtn.MouseButton1Click:Connect(function()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
    ScreenGui:Destroy()
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
end)

-- ================================================
-- 7. ระบบสลับภาษา (TH / EN)
-- ================================================
local currentLang = "TH"

LangBtn.MouseButton1Click:Connect(function()
    if currentLang == "TH" then
        currentLang = "EN"
        LangBtn.Text = "EN 🇺🇸"
        MainTabBtn.Text = "  🏠 Main"
        WelcomeLabel.Text = "Welcome to First HUB Script"
        CreatorText.Text = "Creator: Tiktok: @ First473000"
        TeacherText.Text = "Teacher: Tiktok: @ PISIT SCRIPT✅️📜"
        CampText.Text = "Camp: Tiktok: @ ค่ายPISIT HUB❤️"
        CampNameText.Text = "Camp Name: PISIT HUB😇"
        if isUILocked then
            LockToggleBtn.Text = "🔒 Lock UI: ON (Locked)"
        else
            LockToggleBtn.Text = "🔒 Lock UI: OFF (Draggable)"
        end
        DestroyBtn.Text = "🗑️ Destroy UI Permanently"
        ConfirmText.Text = "Are you sure you want to permanently delete the UI?"
        YesBtn.Text = "Confirm (Yes)"
        NoBtn.Text = "Cancel"
    else
        currentLang = "TH"
        LangBtn.Text = "TH 🇹🇭"
        MainTabBtn.Text = "  🏠 หลัก"
        WelcomeLabel.Text = "ยินดีต้อนรับสู่สคริปต์First HUB"
        CreatorText.Text = "ผู้สร้างสคริปต์: Tiktok: @ First473000"
        TeacherText.Text = "ผู้สอน: Tiktok: @ PISIT SCRIPT✅️📜"
        CampText.Text = "ค่าย: Tiktok: @ ค่ายPISIT HUB❤️"
        CampNameText.Text = "ชื่อค่าย: PISIT HUB😇"
        if isUILocked then
            LockToggleBtn.Text = "🔒 ล็อก UI: เปิด (ไม่ขยับ)"
        else
            LockToggleBtn.Text = "🔒 ล็อก UI: ปิด (ขยับได้)"
        end
        DestroyBtn.Text = "🗑️ ลบ UI ทิ้งอย่างถาวร"
        ConfirmText.Text = "คุณต้องการลบ UI ทิ้งอย่างถาวรใช่หรือไม่?"
        YesBtn.Text = "ยืนยัน (ใช่)"
        NoBtn.Text = "ยกเลิก"
    end
end)

-- ================================================
-- 8. ระบบ Super Animation เปิด-ปิด UI
-- ================================================
local uiVisible = false
local isAnimating = false

local function ToggleUI()
    if isAnimating then return end
    isAnimating = true

    if not uiVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 200, 0, 120)
        MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
        MainFrame.BackgroundTransparency = 1
        MainFrame.Rotation = -12
        
        TweenService:Create(BlurEffect, TweenInfo.new(0.4), {Size = 16}):Play()

        local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 620, 0, 430),
            Position = UDim2.new(0.5, -310, 0.5, -215),
            BackgroundTransparency = 0,
            Rotation = 0
        })
        openTween:Play()
        openTween.Completed:Wait()
        
        uiVisible = true
        isAnimating = false
    else
        ConfirmOverlay.Visible = false
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()

        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 180, 0, 100),
            Position = UDim2.new(0.5, -90, 0.5, -50),
            BackgroundTransparency = 1,
            Rotation = 10
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        
        MainFrame.Visible = false
        uiVisible = false
        isAnimating = false
    end
end

FloatingButton.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(ToggleUI)

local function setupHover(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {Size = button.Size + UDim2.new(0, 4, 0, 2)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {Size = button.Size - UDim2.new(0, 4, 0, 2)}):Play()
    end)
end

setupHover(CloseBtn)
setupHover(LangBtn)
setupHover(LockToggleBtn)
setupHover(DestroyBtn)

-- ================================================
-- ระบบผูกเสียงคลิกอัตโนมัติ (ยกเว้นปุ่มเปิด/ปิด และปุ่มหมวดหมู่)
-- ================================================
local function bindButtonSound(btn)
    if btn:IsA("TextButton") or btn:IsA("ImageButton") then
        -- รายชื่อปุ่มที่ไม่ต้องการให้มีเสียงคลิก
        if btn.Name ~= "FloatingButton" and btn.Name ~= "CloseBtn" and btn.Name ~= "MainTabBtn" then
            btn.MouseButton1Click:Connect(function()
                playClickSound()
            end)
        end
    end
end

for _, descendant in ipairs(ScreenGui:GetDescendants()) do
    bindButtonSound(descendant)
end

ScreenGui.DescendantAdded:Connect(function(descendant)
    bindButtonSound(descendant)
end)

-- ================================================
-- 9. สคริปต์ดาวน์โหลด + เล่นเสียงยินดีต้อนรับเมื่อโหลดเสร็จ
-- ================================================
task.spawn(function()
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    
    task.wait(3)
    
    LoadingText.Text = "Ready!"
    playWelcomeSound()
    task.wait(0.3)
    
    LoadingFrame:Destroy()
    FloatingButton.Visible = true
    
    ToggleUI()
    print("FIRST HUB Loaded Successfully!")
end)

