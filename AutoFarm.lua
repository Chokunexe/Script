local Player = game:GetService("Players").LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
local CombatFrameworkR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)

local function ChackQ()
    local Lv = Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Level")
    if Lv and Lv.Value then
        if Lv.Value >= 1 and Lv.Value <= 9 then
            return {
                ["Mon"] = 'Bandit',
                ["NumQ"] = 1,
                ["NameQ"] = 'BanditQuest1',
                ["CFrameQ"] = CFrame.new(1059.37195, 15.4495068, 1550.4231),
                ["CFrameMon"] = CFrame.new(1196.172, 11.8689699, 1616.95923)
            }
        elseif Lv.Value >= 10 and Lv.Value < 29 then
            return {
                ["Mon"] = 'Monkey',
                ["NumQ"] = 1,
                ["NameQ"] = 'JungleQuest',
                ["CFrameQ"] = CFrame.new(-1598.08911, 35.5501175, 153.377838),
                ["CFrameMon"] = CFrame.new(-1619.10632, 21.7005882, 142.148117)
            }
        elseif Lv.Value >= 30 and Lv.Value <= 39 then
            return {
                ["Mon"] = 'Pirate',
                ["NumQ"] = 1,
                ["NameQ"] = 'BuggyQuest1',
                ["CFrameQ"] = CFrame.new(-1140.762939453125, 5.277381896972656, 3830.43017578125),
                ["CFrameMon"] = CFrame.new(-1180.4862060546875, 4.877380847930908, 3948.302978515625)
            }
        elseif Lv.Value >= 40 and Lv.Value <= 59 then
            return {
                ["Mon"] = 'Brute',
                ["NumQ"] = 2,
                ["NameQ"] = 'BuggyQuest1',
                ["CFrameQ"] = CFrame.new(-1140.762939453125, 5.277381896972656, 3830.43017578125),
                ["CFrameMon"] = CFrame.new(-1145.1796875, 14.935205459594727, 4315.4931640625)
            }
        elseif Lv.Value >= 60 and Lv.Value < 69 then
            return {
                ["Mon"] = 'Desert Bandit',
                ["NumQ"] = 1,
                ["NameQ"] = 'DesertQuest',
                ["CFrameQ"] = CFrame.new(893.2763671875, 6.563793659210205, 4393.5732421875),
                ["CFrameMon"] = CFrame.new(922.5709228515625, 6.574110507965088, 4476.7412109375)
            }
        elseif Lv.Value >= 70 and Lv.Value <= 79 then
            return {
                ["Mon"] = 'Desert Officer',
                ["NumQ"] = 2,
                ["NameQ"] = 'DesertQuest',
                ["CFrameQ"] = CFrame.new(893.2763671875, 6.563793659210205, 4393.5732421875),
                ["CFrameMon"] = CFrame.new(1606.2596435546875, 1.7362850904464722, 4362.77783203125)
            }
        end
    end
    return nil
end

local function GetQuests(N, NB)
    local args = {
        [1] = "StartQuest",
        [2] = N or "BanditQuest1",
        [3] = NB or 1
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))    
end

local function TW(...)
    local CFrame = {...}
    pcall(function()
        if not _G.StopTween and Char and Char:FindFirstChild("HumanoidRootPart") then
            local Distance = (CFrame[1].Position - Char.HumanoidRootPart.Position).Magnitude
            Tween = game:GetService("TweenService"):Create(Char.HumanoidRootPart, TweenInfo.new(Distance/300, Enum.EasingStyle.Cubic), {CFrame = CFrame[1]})
            if _G.StopTween then 
                Tween:Cancel()
            elseif Char.Humanoid.Health > 0 then 
                Tween:Play() 
            end
            if not Char.HumanoidRootPart:FindFirstChild("OMG Hub") then
                local Noclip = Instance.new("BodyVelocity")
                Noclip.Name = "OMG Hub"
                Noclip.Parent = Char.HumanoidRootPart
                Noclip.MaxForce = Vector3.new(9e99, 9e99, 9e99)
                Noclip.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function ClearQ()
    local currentQuest = Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    local questData = ChackQ()
    if questData and not string.find(currentQuest, questData.Mon) then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
    end
end

getgenv().FastAttack = true
local plr = game.Players.LocalPlayer

local CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
local CbFw2 = CbFw[2]

function GetCurrentBlade() 
    local y = CbFw2.activeController
    local ret = y.blades[1]
    if not ret then return end
    while ret.Parent ~= game.Players.LocalPlayer.Character do ret = ret.Parent end
    return ret
end

spawn(function()
    while wait(0.4) do
        if getgenv().FastAttack then
            pcall(function()
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", nil, nil, "")
            end)
        end
    end
end)

local CameraShaker = require(game.ReplicatedStorage.Util.CameraShaker)
CombatFrameworkR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local y = debug.getupvalues(CombatFrameworkR)[2]

spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if getgenv().FastAttack then
            if typeof(y) == "table" then
                pcall(function()
                    CameraShaker:Stop()
                    y.activeController.timeToNextAttack = 0
                    y.activeController.hitboxMagnitude = 2048
                    y.activeController.active = false
                    y.activeController.timeToNextBlock = 0
                    y.activeController.focusStart = 0
                    y.activeController.increment = 1
                    y.activeController.blocking = false
                    y.activeController.attacking = false
                    y.activeController.humanoid.AutoRotate = true
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange", tostring(GetCurrentBlade()))
                end)
            end
        end
    end)
end)

spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoFarm then
                local UIQ = Player.PlayerGui.Main.Quest
                ClearQ()
                local questData = ChackQ()
                if questData then
                    if not UIQ.Visible or UIQ.Visible == false then
                        TW(questData.CFrameQ)
                        if (questData.CFrameQ.Position - Char.HumanoidRootPart.Position).Magnitude <= 15 then
                            wait(.2)
                            GetQuests(questData.NameQ, questData.NumQ)
                        end
                    else
                        for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if enemy.Name == questData.Mon and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                                enemy.HumanoidRootPart.CFrame = Char.HumanoidRootPart.CFrame
                                enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                enemy.HumanoidRootPart.Transparency = 1
                                enemy.HumanoidRootPart.CanCollide = false
                                enemy.Humanoid.WalkSpeed = 0
                                enemy.Humanoid.JumpPower = 0
                                if sethiddenproperty then
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                end
                                TW(enemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 30, 0))
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            end
                        end
                    end
                end
            end
        end)
    end
end)