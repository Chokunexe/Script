function CheckQuest()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
    if Lv >= 1 and Lv <= 9 then
        Mon = "Bandit [Lv. 5]"
        NameMon = "Bandit"
        LvQuest = 1
        NameQuest = "BanditQuest1"
        CFrameMon = CFrame.new(1038.2711181640625, 24.537282943725586, 1550.2586669921875)
        CFrameQuest = CFrame.new(1059.8109130859375, 16.362747192382812, 1549.0882568359375)
    elseif Lv >= 10 and Lv <= 14 then
        Mon = "Monkey [Lv. 14]"
        NameMon = "Monkey"
        LvQuest = 1
        NameQuest = "JungleQuest"
        CFrameMon = CFrame.new(-1443.7662353515625, 61.851966857910156, -47.555946350097656)
        CFrameQuest = CFrame.new(-1599.8194580078125, 36.852149963378906, 153.0706024169922)
    elseif Lv >= 15 and Lv <= 29 then
        Mon = "Gorilla [Lv. 20]"
        NameMon = "Gorilla"
        LvQuest = 2
        NameQuest = "JungleQuest"
        CFrameMon = CFrame.new(-1443.7662353515625, 61.851966857910156, -47.555946350097656)
        CFrameQuest = CFrame.new(-1599.8194580078125, 36.852149963378906, 153.0706024169922)
    else
        print("Level not within quest range.")
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/naypramx/Ui__Project/Script/XeNonUi", true))()
library:CreateWatermark("NOOB HUB") -- Config แตกนะเดียวค่อยแก้รอเน็ตมาก่อน By MeowX#0001
local CenterHubNo1 = library:CreateWindow("NOOB HUB | BLOX FRUIT", Enum.KeyCode.RightControl)
local Tab = CenterHubNo1:CreateTab("Main")
local AutoFarm = Tab:CreateSector("AutoFarm", "Left")
AutoFarm:AddLabel("AutoFarm Lv")

Weapon = {}
for _, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(Weapon, v.Name)
    end
end

local WE = AutoFarm:AddDropdown("Select Weapon", Weapon, "Select Weapon", false, function(t)
    _G.SelectWeapon = t
end)

function Equip(ToolX)
    local player = game:GetService("Players").LocalPlayer
    if player.Backpack:FindFirstChild(ToolX) then
        local tool = player.Backpack:FindFirstChild(ToolX)
        player.Character.Humanoid:EquipTool(tool)
    end
end

function click()
    game:GetService('VirtualUser'):CaptureController()
    game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
end

function TP(P)
    local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300
    local tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, tweenInfo, { CFrame = P })
    tween:Play()
end

AutoFarm:AddButton("ReSet Weapon", function()
    table.clear(Weapon)
    for _, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            WE:Add(v.Name)
        end
    end
end)

AutoFarm:AddToggle("BringMob", false, function(t)
    _G.BringMob = t
end)

AutoFarm:AddToggle("AutoFarm", false, function(t)
    _G.AutoFarm = t
end)

local Stats = Tab:CreateSector("Stats", "Reft")
Stats:AddLabel("Stats")
Stats:AddToggle("Auto Melee", false, function(t)
    _G.Melee = t
    while _G.Melee do wait(.1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", Point)
        end)
    end
end)

Stats:AddToggle("Auto Defense", false, function(t)
    _G.Defense = t
    while _G.Defense do wait(.1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", Point)
        end)
    end
end)

Stats:AddToggle("Auto Sword", false, function(t)
    _G.Sword = t
    while _G.Sword do wait(.1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", Point)
        end)
    end
end)

Stats:AddToggle("Auto Gun", false, function(t)
    _G.Gun = t
    while _G.Gun do wait(.1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", Point)
        end)
    end
end)

Stats:AddToggle("Auto Blox Fruit", false, function(t)
    _G.Fruit = t
    while _G.Fruit do wait(.1)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", Point)
        end)
    end
end)

Stats:AddSlider("Point", 1, 1, 100, 1, function(x)
    Point = x
end)

spawn(function()
    while wait() do
        if _G.BringMob then
            pcall(function()
                CheckQuest()
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    for _, y in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == Mon then
                            if y.Name == Mon then
                                v.HumanoidRootPart.CFrame = y.HumanoidRootPart.CFrame
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                y.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.HumanoidRootPart.CanCollide = false
                                y.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                y.Humanoid.WalkSpeed = 0
                                v.Humanoid.JumpPower = 0
                                y.Humanoid.JumpPower = 0
                                if sethiddenproperty then
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                CheckQuest()
                local playerGui = game:GetService("Players").LocalPlayer.PlayerGui.Main
                if not playerGui.Quest.Visible then
                    TP(CFrameQuest)
                    if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        wait(.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LvQuest)
                    end
                elseif playerGui.Quest.Visible then
                    if string.find(playerGui.Quest.Container.QuestTitle.Title.Text, NameMon) then
                        for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == Mon and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                                if v.Humanoid.Health > 0 then
                                    repeat wait()
                                        click()
                                        Equip(_G.SelectWeapon)
                                        local HealthMin = v.Humanoid.MaxHealth * 0.9
                                        local Magma = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                        if Magma <= 230 then
                                            if v.Humanoid.Health > HealthMin then
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 14)
                                            else
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                                            end
                                        end

                                        if v.Humanoid.Health > HealthMin then
                                            local Distance = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.H
