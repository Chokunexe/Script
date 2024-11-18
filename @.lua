local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Validator = Remotes:WaitForChild("Validator")
local CommF = Remotes:WaitForChild("CommF_")

local WorldOrigin = workspace:WaitForChild("_WorldOrigin")
local Characters = workspace:WaitForChild("Characters")
local Enemies = workspace:WaitForChild("Enemies")
local Map = workspace:WaitForChild("Map")

local EnemySpawns = WorldOrigin:WaitForChild("EnemySpawns")
local Locations = WorldOrigin:WaitForChild("Locations")

local RenderStepped = RunService.RenderStepped
local Heartbeat = RunService.Heartbeat
local Stepped = RunService.Stepped

local Player = Players.LocalPlayer

local CombatFramework = WaitChilds(Player, "PlayerScripts", "CombatFramework")
local RigControllerEvent = ReplicatedStorage:WaitForChild("RigControllerEvent")
local ReplicatedCombat = ReplicatedStorage:WaitForChild("CombatFramework")

local sethiddenproperty = sethiddenproperty or (function(...) return ... end)
local setupvalue = setupvalue or (debug and debug.setupvalue)
local getupvalue = getupvalue or (debug and debug.getupvalue)


local function GetQuests(NameQuest, LvQuest)
    local args = {
        [1] = "StartQuest",
        [2] = NameQuest,
        [3] = LvQuest
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))    
end

function CheckQuest()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
    if Lv >= 1 and Lv <= 9 then
        Mon = "Bandit [Lv. 5]"
        NameMon = "Bandit"
        LvQuest = 1
        NameQuest = "BanditQuest1"
        CFrameMon = CFrame.new(1038.2711, 24.5372, 1550.2586)
        CFrameQuest = CFrame.new(1059.8109, 16.3627, 1549.0882)
    elseif Lv >= 10 and Lv <= 14 then
        Mon = "Monkey [Lv. 14]"
        NameMon = "Monkey"
        LvQuest = 1
        NameQuest = "JungleQuest"
        CFrameMon = CFrame.new(-1443.7662, 61.8519, -47.5559)
        CFrameQuest = CFrame.new(-1599.8194, 36.8521, 153.0706)
    elseif Lv >= 15 and Lv <= 99 then
        Mon = "Gorilla [Lv. 20]"
        NameMon = "Gorilla"
        LvQuest = 2
        NameQuest = "JungleQuest"
        CFrameMon = CFrame.new(-1221.7644, 32.8519, -513.7896)
        CFrameQuest = CFrame.new(-1599.8194, 36.8521, 153.0706)
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("SHARK X | AUTO FARM", 5013109572)

local Main = venyx:addPage("Main", 5012544693)
local AutoFarm = Main:addSection("AutoFarm")
local WeaponSection = Main:addSection("Weapon")

Weapon = {}
for i, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(Weapon, v.Name)
    end
end

local WE = AutoFarm:AddDropdown("Select Weapon", Weapon, "Select Weapon", false, function(t)
    _G.SelectWeapon = t
end)

function Equip(ToolX)
    if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(ToolX) then
        getgenv().Tol = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(ToolX)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tol)
    end
end

function click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

function TP(P)
    local Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 300
    local tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, { CFrame = P })
    tween:Play()
end

AutoFarm:AddToggle("BringMob", false, function(t)
    _G.BringMob = t
end)

AutoFarm:AddToggle("AutoFarm", false, function(t)
    _G.AutoFarm = t
end)

spawn(function()
    while wait() do
        if _G.BringMob then
            pcall(function()
                CheckQuest()
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == Mon and v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        v.HumanoidRootPart.Transparency = 1
                        v.HumanoidRootPart.CanCollide = false
                        v.Humanoid.WalkSpeed = 0
                        v.Humanoid.JumpPower = 0
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
                if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    TP(CFrameQuest)
                    if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LvQuest)
                    end
                else
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == Mon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                wait()
                                Equip(_G.SelectWeapon)
                                click()
                                TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0))
                            until v.Humanoid.Health <= 0 or not _G.AutoFarm
                        end
                    end
                end
            end)
        end
    end
end)