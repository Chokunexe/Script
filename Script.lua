-- ตั้งค่าเริ่มต้น
_G.AutoFarm = true  -- เปิด/ปิดระบบฟาร์มอัตโนมัติ
_G.ESP = true  -- เปิด/ปิด ESP
_G.BladeCount = 5  -- จำนวนใบมีดเริ่มต้น
_G.FloatingHeight = 5  -- ความสูงที่ลอยเหนือไททัน
_G.SlashAnimation = nil  -- กำหนดตัวแปรอนิเมชั่นโจมตีแบบ slash

local HttpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1264868020266729502/2dt31-01VCzhBDj-yD7mbDo-5lR_lwAxcDVh0O08H9Qbo2RfbKPhglsUIckeZo2LhOKD"

-- ฟังก์ชันสำหรับส่งข้อมูลไปยัง Webhook
local function sendWebhook(message)
    local data = {
        content = message
    }
    local jsonData = HttpService:JSONEncode(data)

    local success, err = pcall(function()
        HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Error sending webhook: " .. err)
    end
end

-- ฟังก์ชันสำหรับสร้าง ESP บนไททัน
local function CreateESP(titan)
    if titan:FindFirstChild("HumanoidRootPart") and _G.ESP then
        -- สร้าง BillboardGUI สำหรับ ESP
        if not titan.HumanoidRootPart:FindFirstChild("ESP") then
            local esp = Instance.new("BillboardGui", titan.HumanoidRootPart)
            esp.Name = "ESP"
            esp.AlwaysOnTop = true
            esp.Size = UDim2.new(2, 0, 2, 0)
            esp.Adornee = titan.HumanoidRootPart

            -- สร้าง TextLabel สำหรับชื่อไททัน
            local nameLabel = Instance.new("TextLabel", esp)
            nameLabel.Text = "Titan"
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.TextColor3 = Color3.new(1, 0, 0)
            nameLabel.BackgroundTransparency = 1
        end
    end
end

-- ฟังก์ชันสำหรับล็อคที่ท้ายทอย
local function LockOnTitan(titan)
    return titan.HumanoidRootPart.Position + Vector3.new(0, _G.FloatingHeight, 0) -- ตำแหน่งที่ลอยเหนือไททัน
end

-- ฟังก์ชันสำหรับโจมตีไททัน
local function AttackTitan(character)
    if not _G.SlashAnimation then
        -- โหลดอนิเมชั่นโจมตีแบบ slash (กรุณาแทนที่ด้วย ID ของอนิเมชั่นที่คุณต้องการ)
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://YOUR_ANIMATION_ID_HERE"  -- ใส่ ID ของอนิเมชั่นที่ต้องการ
        _G.SlashAnimation = character.Humanoid:LoadAnimation(animation)
    end

    if _G.SlashAnimation then
        _G.SlashAnimation:Play()  -- เล่นอนิเมชั่นโจมตี
        sendWebhook("โจมตีไททันแล้ว! จำนวนใบมีดที่เหลือ: " .. _G.BladeCount)  -- ส่งข้อความไปยัง Webhook
    end
end

-- ฟังก์ชันสำหรับตรวจสอบว่าไททันกระโดดหรือไม่
local function IsTitanJumping(titan)
    local humanoid = titan:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid:GetState() == Enum.HumanoidStateType.Jumping
end

-- ฟังก์ชันสำหรับฟาร์มไททัน
local function AutoFarmTitan()
    while _G.AutoFarm do
        for _, titan in pairs(game.Workspace.Titans:GetChildren()) do
            if titan:IsA("Model") and titan:FindFirstChild("HumanoidRootPart") then
                -- สร้าง ESP ให้กับไททัน (ถ้ายังไม่มี)
                CreateESP(titan)

                -- เคลื่อนที่ไปที่ไททันเพื่อฟาร์ม
                local player = game.Players.LocalPlayer
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")

                if hrp then
                    -- ล็อคเป้าหมายที่ลอยเหนือหัวไททัน
                    local targetPosition = LockOnTitan(titan)

                    -- หากไททันกระโดด ให้เพิ่มความสูง
                    if IsTitanJumping(titan) then
                        targetPosition = targetPosition + Vector3.new(0, 5, 0)  -- เพิ่มความสูง 5
                    end

                    -- เคลื่อนย้ายผู้เล่นไปที่ตำแหน่งที่ล็อค
                    hrp.CFrame = CFrame.new(targetPosition)

                    -- เช็คจำนวนใบมีดก่อนโจมตี
                    if _G.BladeCount > 0 then
                        AttackTitan(char)  -- เรียกฟังก์ชันโจมตี
                        _G.BladeCount = _G.BladeCount - 1  -- ลดจำนวนใบมีดหลังจากโจมตี
                        print("ใบมีดที่เหลือ: " .. _G.BladeCount)
                    else
                        -- หากใบมีดหมด ให้เติมใบมีดและกลับมา
                        print("เติมใบมีด...")
                        refillBlades()  -- เรียกฟังก์ชันเติมใบมีด
                        wait(1)  -- รอ 1 วินาทีก่อนกลับไปฟาร์มต่อ
                        break  -- ออกจากลูป for เพื่อกลับไปเริ่มฟาร์มใหม่
                    end
                end

                wait(1)  -- รอ 1 วินาทีก่อนฟาร์มตัวถัดไป
            end
        end
        wait(2)  -- รอการเกิดใหม่ของไททัน
    end
end

-- ฟังก์ชันเติมใบมีด
local function refillBlades()
    wait(2)  -- สมมุติว่าใช้เวลาสองวินาทีในการเติมใบมีด
    _G.BladeCount = 5  -- รีเซ็ตจำนวนใบมีดกลับเป็น 5
    print("เติมใบมีดเรียบร้อยแล้ว")
end

-- เริ่มฟาร์มไททัน
AutoFarmTitan()

-- ปุ่มสำหรับเปิด/ปิดระบบฟาร์ม
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        _G.AutoFarm = not _G.AutoFarm  -- เปิด/ปิดฟาร์ม
        if _G.AutoFarm then
            AutoFarmTitan()  -- เริ่มฟาร์มใหม่
        end
    elseif input.KeyCode == Enum.KeyCode.E then
        _G.ESP = not _G.ESP  -- เปิด/ปิด ESP
    end
end)
