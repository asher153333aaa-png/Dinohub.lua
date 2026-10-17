if _G.dinoHub then pcall(function() _G.dinoHub:Destroy() end) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local _k1 = string.char(100, 105, 110, 111, 95)
local _k2 = string.char(49, 51, 53, 55, 57)
local VALID_KEY = _k1 .. _k2
local unlocked = false

local keyGui = Instance.new("ScreenGui")
keyGui.ResetOnSpawn = false
keyGui.Parent = (gethui and gethui()) or LP:WaitForChild("PlayerGui")
_G.dinoHub = keyGui

local kf = Instance.new("Frame", keyGui)
kf.Size = UDim2.new(0, 400, 0, 180)
kf.Position = UDim2.new(0.5, -200, 0.5, -90)
kf.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
kf.BorderSizePixel = 0
kf.Active = true
kf.Draggable = true
Instance.new("UICorner", kf).CornerRadius = UDim.new(0, 8)

local kt = Instance.new("TextLabel", kf)
kt.Size = UDim2.new(1, 0, 0, 32)
kt.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
kt.Text = "dino Hub - 인증"
kt.TextColor3 = Color3.fromRGB(255,255,255)
kt.TextSize = 14
kt.Font = Enum.Font.GothamBold
Instance.new("UICorner", kt).CornerRadius = UDim.new(0, 8)

local kb = Instance.new("TextBox", kf)
kb.Size = UDim2.new(1, -40, 0, 32)
kb.Position = UDim2.new(0, 20, 0, 50)
kb.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
kb.Text = ""
kb.PlaceholderText = "키 입력..."
kb.TextColor3 = Color3.fromRGB(240,240,240)
kb.PlaceholderColor3 = Color3.fromRGB(110,110,115)
kb.TextSize = 13
kb.Font = Enum.Font.Gotham
kb.ClearTextOnFocus = false
kb.BorderSizePixel = 0
Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 6)

local ks = Instance.new("TextLabel", kf)
ks.Size = UDim2.new(1, -40, 0, 16)
ks.Position = UDim2.new(0, 20, 0, 90)
ks.BackgroundTransparency = 1
ks.Text = ""
ks.TextColor3 = Color3.fromRGB(240, 80, 80)
ks.TextSize = 11
ks.Font = Enum.Font.Gotham
ks.TextXAlignment = Enum.TextXAlignment.Left

local kv = Instance.new("TextButton", kf)
kv.Size = UDim2.new(1, -40, 0, 34)
kv.Position = UDim2.new(0, 20, 0, 115)
kv.BackgroundColor3 = Color3.fromRGB(60, 110, 200)
kv.Text = "인증"
kv.TextColor3 = Color3.fromRGB(255,255,255)
kv.TextSize = 13
kv.Font = Enum.Font.GothamBold
kv.BorderSizePixel = 0
Instance.new("UICorner", kv).CornerRadius = UDim.new(0, 6)

local STATE = {
    ESP = true,
    SwordHitbox = false,
    HitboxSize = 20,
    Spin = false,
    SpinSpeed = 30,
    Noclip = false,
    InfJump = false,
    Speed = 16,
    JumpPower = 50,
    UseSpeed = false,
    UseJump = false,
    AllKill = false,
}

local espData = {}
local origData = {}
local visData = {}
local swingRunning = false
local ALL_SIZE = 1000000

local function makeESP(p)
    if p == LP then return end
    if espData[p] then pcall(function() espData[p]:Destroy() end) end
    local c = p.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    if not h or not r or h.Health <= 0 then return end

    local bb = Instance.new("BillboardGui", r)
    bb.Size = UDim2.new(0, 180, 0, 45)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.MaxDistance = math.huge
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false

    local nl = Instance.new("TextLabel", bb)
    nl.Size = UDim2.new(1, 0, 0, 16)
    nl.BackgroundTransparency = 1
    nl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nl.TextSize = 13
    nl.Font = Enum.Font.GothamBold
    nl.TextStrokeTransparency = 0.3
    nl.Text = p.Name

    local hb = Instance.new("Frame", bb)
    hb.Size = UDim2.new(0.8, 0, 0, 5)
    hb.Position = UDim2.new(0.1, 0, 0, 18)
    hb.BackgroundColor3 = Color3.fromRGB(30,30,30)
    hb.BorderSizePixel = 0

    local hf = Instance.new("Frame", hb)
    hf.Size = UDim2.new(1, 0, 1, 0)
    hf.BackgroundColor3 = Color3.fromRGB(0,255,0)
    hf.BorderSizePixel = 0

    local ht = Instance.new("TextLabel", bb)
    ht.Size = UDim2.new(1, 0, 0, 14)
    ht.Position = UDim2.new(0, 0, 0, 26)
    ht.BackgroundTransparency = 1
    ht.TextColor3 = Color3.fromRGB(220,220,220)
    ht.TextSize = 11
    ht.Font = Enum.Font.Gotham
    ht.TextStrokeTransparency = 0.5

    espData[p] = bb

    local function upd()
        if not bb.Parent then return end
        if not c.Parent or h.Health <= 0 then
            bb:Destroy(); espData[p] = nil; return
        end
        local hp, mp = math.floor(h.Health), math.floor(h.MaxHealth)
        local per = hp/mp
        ht.Text = hp .. " / " .. mp
        hf.Size = UDim2.new(math.max(0, per), 0, 1, 0)
        hf.BackgroundColor3 = per > 0.5 and Color3.fromRGB(0,255,0) or (per > 0.25 and Color3.fromRGB(255,200,0) or Color3.fromRGB(255,0,0))
    end
    h.HealthChanged:Connect(upd)
    upd()
end

local function applyESP()
    if STATE.ESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then makeESP(p) end
        end
    else
        for p, g in pairs(espData) do pcall(function() g:Destroy() end) end
        espData = {}
    end
end

local function cleanTool(t)
    if visData[t] then pcall(function() visData[t]:Destroy() end) visData[t] = nil end
    if origData[t] then
        local h = t:FindFirstChild("Handle")
        if h then
            local o = origData[t]
            h.Size = o.Size
            h.Transparency = o.Transparency
            h.CanCollide = o.CanCollide
            h.Massless = o.Massless
            for _, m in ipairs(o.Meshes) do
                if m.obj and m.obj.Parent then
                    m.obj.Scale = m.scale
                    m.obj.Offset = m.offset
                end
            end
        end
        origData[t] = nil
    end
end

local function applyTool(t)
    if not t:IsA("Tool") then return end
    local h = t:FindFirstChild("Handle")
    if not h then return end

    if not origData[t] then
        local meshes = {}
        for _, c in ipairs(h:GetDescendants()) do
            if c:IsA("DataModelMesh") then
                table.insert(meshes, {obj=c, scale=c.Scale, offset=c.Offset})
            end
        end
        origData[t] = {Size=h.Size, Transparency=h.Transparency, CanCollide=h.CanCollide, Massless=h.Massless, Meshes=meshes}
    end

    local sz
    if STATE.AllKill then sz = ALL_SIZE
    elseif STATE.SwordHitbox then sz = STATE.HitboxSize
    else cleanTool(t) return end

    local ts = Vector3.new(sz, sz, sz)
    local o = origData[t]

    h.Size = ts
    h.Transparency = 1
    h.CanCollide = false
    h.Massless = true
    h.CanTouch = true
    h.CanQuery = true

    for _, m in ipairs(o.Meshes) do
        if m.obj and m.obj.Parent then
            m.obj.Scale = Vector3.new(
                (o.Size.X*m.scale.X)/ts.X,
                (o.Size.Y*m.scale.Y)/ts.Y,
                (o.Size.Z*m.scale.Z)/ts.Z
            )
        end
    end

    if STATE.SwordHitbox and not STATE.AllKill then
        if not visData[t] then
            local v = Instance.new("Part")
            v.Shape = Enum.PartType.Block
            v.Size = ts
            v.Transparency = 0.8
            v.Color = Color3.fromRGB(0,100,0)
            v.Material = Enum.Material.Neon
            v.CanCollide = false
            v.CanTouch = false
            v.CanQuery = false
            v.Massless = true
            v.Anchored = true
            v.CastShadow = false
            v.CFrame = h.CFrame
            v.Parent = Workspace
            visData[t] = v
        else
            visData[t].Size = ts
        end
    else
        if visData[t] then pcall(function() visData[t]:Destroy() end) visData[t] = nil end
    end
end

local function applyAllTools()
    local c = LP.Character
    if not c then return end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then applyTool(t) end
    end
end

local function resetTools()
    for t, _ in pairs(origData) do if t then cleanTool(t) end end
    for t, _ in pairs(visData) do if t then cleanTool(t) end end
    origData = {}
    visData = {}
end

local function startSwing()
    if swingRunning then return end
    swingRunning = true
    task.spawn(function()
        while STATE.AllKill do
            local c = LP.Character
            if c then
                local t = c:FindFirstChildOfClass("Tool")
                if t then pcall(function() t:Activate() end) end
            end
            task.wait(0.05)
        end
        swingRunning = false
    end)
end

local function isSword(o)
    if not o or not o:IsA("Tool") then return false end
    local n = string.lower(o.Name)
    return string.find(n, "sword") or string.find(n, "classic") or string.find(n, "linked")
end

local function held(o)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and o:IsDescendantOf(p.Character) then return true end
    end
    return false
end

local function inBP(o)
    for _, p in ipairs(Players:GetPlayers()) do
        local b = p:FindFirstChild("Backpack")
        if b and o:IsDescendantOf(b) then return true end
    end
    return false
end

local grabbing = false
local function bpCount()
    local b = LP:FindFirstChild("Backpack")
    if not b then return 0 end
    local c = 0
    for _, t in ipairs(b:GetChildren()) do
        if t:IsA("Tool") then c = c + 1 end
    end
    return c
end

local function findSword()
    local c = LP.Character
    if not c then return nil end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return nil end
    local best, bd = nil, math.huge
    for _, o in ipairs(Workspace:GetChildren()) do
        if isSword(o) and not held(o) and not inBP(o) then
            local h = o:FindFirstChild("Handle")
            if h then
                local d = (h.Position - r.Position).Magnitude
                if d < bd then bd = d; best = h end
            end
        end
    end
    return best
end

local function grabSword()
    if grabbing then return false end
    local c = LP.Character
    if not c then return false end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    local h = findSword()
    if not h then return false end

    grabbing = true
    local ocf = r.CFrame
    local ov = r.AssemblyLinearVelocity
    local tp = h.Position

    task.spawn(function()
        local before = bpCount()
        for _, off in ipairs({Vector3.new(0,0,0), Vector3.new(0,0.4,0), Vector3.new(0.4,0.2,0), Vector3.new(-0.4,0.2,0)}) do
            pcall(function()
                r.CFrame = CFrame.new(tp + off)
                r.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end)
            RunService.Heartbeat:Wait()
            if bpCount() > before then break end
        end
        pcall(function()
            r.CFrame = ocf
            r.AssemblyLinearVelocity = ov
        end)
        grabbing = false
    end)
    return true
end

local function tpTo(p)
    if p == LP then return end
    local mc = LP.Character
    if not mc then return end
    local mr = mc:FindFirstChild("HumanoidRootPart")
    if not mr then return end
    local tc = p.Character
    if not tc then return end
    local tr = tc:FindFirstChild("HumanoidRootPart")
    if not tr then return end
    pcall(function() mr.CFrame = tr.CFrame * CFrame.new(0, 0, 3) end)
end

local function onVerified()
    if unlocked then return end
    unlocked = true
    keyGui:Destroy()

    local function setupP(p)
        if p == LP then return end
        p.CharacterAdded:Connect(function()
            task.wait(0.5)
            if STATE.ESP then makeESP(p) end
        end)
        if p.Character and STATE.ESP then makeESP(p) end
    end

    for _, p in ipairs(Players:GetPlayers()) do setupP(p) end
    Players.PlayerAdded:Connect(setupP)
    Players.PlayerRemoving:Connect(function(p)
        if espData[p] then pcall(function() espData[p]:Destroy() end) espData[p] = nil end
    end)

    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if STATE.ESP then applyESP() end
    end)

    UserInputService.JumpRequest:Connect(function()
        if STATE.InfJump then
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
            end
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        if STATE.ESP then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not espData[p] then
                    local h = p.Character:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then makeESP(p) end
                end
            end
        end

        if STATE.Noclip then
            local c = LP.Character
            if c then
                for _, pt in ipairs(c:GetDescendants()) do
                    if pt:IsA("BasePart") and pt.CanCollide then pt.CanCollide = false end
                end
            end
        end

        local c = LP.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and not grabbing then
                if STATE.UseSpeed and h.WalkSpeed ~= STATE.Speed then h.WalkSpeed = STATE.Speed end
                if STATE.UseJump and h.UseJumpPower and h.JumpPower ~= STATE.JumpPower then h.JumpPower = STATE.JumpPower end
            end
        end

        if STATE.SwordHitbox or STATE.AllKill then
            local c2 = LP.Character
            if c2 then
                local ts
                if STATE.AllKill then ts = Vector3.new(ALL_SIZE, ALL_SIZE, ALL_SIZE)
                else ts = Vector3.new(STATE.HitboxSize, STATE.HitboxSize, STATE.HitboxSize) end
                for _, t in ipairs(c2:GetChildren()) do
                    if t:IsA("Tool") then
                        local h = t:FindFirstChild("Handle")
                        if h then
                            local o = origData[t]
                            if not o then applyTool(t)
                            else
                                if h.Size ~= ts then
                                    h.Size = ts
                                    for _, m in ipairs(o.Meshes) do
                                        if m.obj and m.obj.Parent then
                                            m.obj.Scale = Vector3.new(
                                                (o.Size.X*m.scale.X)/ts.X,
                                                (o.Size.Y*m.scale.Y)/ts.Y,
                                                (o.Size.Z*m.scale.Z)/ts.Z
                                            )
                                        end
                                    end
                                end
                                if h.Transparency ~= 1 then h.Transparency = 1 end
                                if h.CanCollide then h.CanCollide = false end
                                if not h.Massless then h.Massless = true end
                                if not h.CanTouch then h.CanTouch = true end
                                if not h.CanQuery then h.CanQuery = true end
                                if STATE.SwordHitbox and not STATE.AllKill then
                                    local v = visData[t]
                                    if v and v.Parent then
                                        if v.Size ~= ts then v.Size = ts end
                                        v.CFrame = h.CFrame
                                    elseif not v then
                                        local nv = Instance.new("Part")
                                        nv.Shape = Enum.PartType.Block
                                        nv.Size = ts
                                        nv.Transparency = 0.8
                                        nv.Color = Color3.fromRGB(0,100,0)
                                        nv.Material = Enum.Material.Neon
                                        nv.CanCollide = false
                                        nv.CanTouch = false
                                        nv.CanQuery = false
                                        nv.Massless = true
                                        nv.Anchored = true
                                        nv.CastShadow = false
                                        nv.CFrame = h.CFrame
                                        nv.Parent = Workspace
                                        visData[t] = nv
                                    end
                                elseif visData[t] then
                                    pcall(function() visData[t]:Destroy() end)
                                    visData[t] = nil
                                end
                            end
                        end
                    end
                end
            end
        end

        if STATE.Spin and not grabbing then
            local c3 = LP.Character
            if c3 then
                local r = c3:FindFirstChild("HumanoidRootPart")
                local h = c3:FindFirstChildOfClass("Humanoid")
                if r and h then
                    if h.AutoRotate then h.AutoRotate = false end
                    r.CFrame = CFrame.new(r.Position) * CFrame.Angles(0, math.rad(STATE.SpinSpeed * dt * 60), 0)
                end
            end
        end
    end)

    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local IM = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local W = Fluent:CreateWindow({
        Title = "dino Hub", SubTitle = "", TabWidth = 130,
        Size = UDim2.fromOffset(480, 320), Acrylic = false, Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightShift
    })

    local T = {
        V = W:AddTab({ Title = "비주얼", Icon = "eye" }),
        S = W:AddTab({ Title = "칼", Icon = "sword" }),
        G = W:AddTab({ Title = "줍기", Icon = "hand" }),
        M = W:AddTab({ Title = "이동", Icon = "move" }),
        Sp = W:AddTab({ Title = "스핀", Icon = "refresh-cw" }),
        Sv = W:AddTab({ Title = "서버 인원", Icon = "users" }),
        St = W:AddTab({ Title = "설정", Icon = "settings" })
    }

    local vs = T.V:AddSection("ESP")
    vs:AddToggle("esp", { Title = "ESP (이름 + 체력)", Default = true, Callback = function(v) STATE.ESP = v; applyESP() end })

    local ss = T.S:AddSection("칼 히트박스")
    ss:AddToggle("sh", { Title = "칼 히트박스 켜기", Default = false, Callback = function(v)
        STATE.SwordHitbox = v
        if v then applyAllTools() else resetTools() end
    end })
    ss:AddInput("ss", { Title = "히트박스 크기", Default = "20", Placeholder = "20", Numeric = true, Finished = true, Callback = function(v)
        local n = tonumber(v); if n and n >= 1 then STATE.HitboxSize = n end
    end })

    local ks = T.S:AddSection("올킬")
    ks:AddToggle("ak", { Title = "올킬 켜기", Description = "리치 무한 + 자동 스윙 (맵 전체 딜)", Default = false, Callback = function(v)
        STATE.AllKill = v
        if v then
            applyAllTools()
            startSwing()
        else
            swingRunning = false
            resetTools()
        end
    end })

    local ms = T.M:AddSection("Movement")
    ms:AddToggle("nc", { Title = "Noclip", Default = false, Callback = function(v)
        STATE.Noclip = v
        if not v then
            local c = LP.Character
            if c then
                for _, pt in ipairs(c:GetDescendants()) do
                    if pt:IsA("BasePart") then pt.CanCollide = true end
                end
            end
        end
    end })
    ms:AddToggle("ij", { Title = "Infinite Jump", Default = false, Callback = function(v) STATE.InfJump = v end })
    ms:AddInput("sp", { Title = "Speed (1~1000)", Default = "16", Placeholder = "16", Numeric = true, Finished = true, Callback = function(v)
        local n = tonumber(v)
        if n and n >= 1 and n <= 1000 then
            STATE.Speed = n; STATE.UseSpeed = true
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = n end
            end
        end
    end })
    ms:AddInput("jp", { Title = "Jump Power (1~1000)", Default = "50", Placeholder = "50", Numeric = true, Finished = true, Callback = function(v)
        local n = tonumber(v)
        if n and n >= 1 and n <= 1000 then
            STATE.JumpPower = n; STATE.UseJump = true
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h.UseJumpPower = true; h.JumpPower = n end
            end
        end
    end })

    local gs = T.G:AddSection("Classic Sword")
    gs:AddButton({ Title = "칼 줍기 (초고속)", Callback = function()
        local ok = grabSword()
        Fluent:Notify({Title = "dino Hub", Content = ok and "칼 획득!" or "칼 없음", Duration = 1})
    end })

    local sps = T.Sp:AddSection("스핀")
    sps:AddToggle("spin", { Title = "스핀 켜기", Default = false, Callback = function(v) STATE.Spin = v end })
    sps:AddInput("sps", { Title = "스핀 속도", Default = "30", Placeholder = "30", Numeric = true, Finished = true, Callback = function(v)
        local n = tonumber(v); if n and n >= 1 then STATE.SpinSpeed = n end
    end })

    local svs = T.Sv:AddSection("플레이어 목록")
    local svRows = {}

    local function attachSv(row, p)
        task.spawn(function()
            task.wait(0.15)
            local btn = typeof(row) == "Instance" and row or (row.Object or row.Instance or row.Frame)
            if not btn then return end
            for _, ch in ipairs(btn:GetDescendants()) do
                if ch:IsA("ImageLabel") then ch.Visible = false end
            end
            if btn:FindFirstChild("DinoToBtn") then return end

            local toBtn = Instance.new("TextButton", btn)
            toBtn.Name = "DinoToBtn"
            toBtn.Size = UDim2.new(0, 34, 0, 22)
            toBtn.Position = UDim2.new(1, -80, 0.5, -11)
            toBtn.BackgroundColor3 = Color3.fromRGB(60, 110, 200)
            toBtn.Text = "to"
            toBtn.TextColor3 = Color3.fromRGB(255,255,255)
            toBtn.TextSize = 12
            toBtn.Font = Enum.Font.GothamBold
            toBtn.BorderSizePixel = 0
            toBtn.ZIndex = 100
            Instance.new("UICorner", toBtn).CornerRadius = UDim.new(0, 4)
            toBtn.MouseButton1Click:Connect(function() tpTo(p) end)

            local c = Instance.new("TextButton", btn)
            c.Size = UDim2.new(0, 50, 0, 22)
            c.Position = UDim2.new(1, -140, 0.5, -11)
            c.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
            c.Text = "시점"
            c.TextColor3 = Color3.fromRGB(255,255,255)
            c.TextSize = 11
            c.Font = Enum.Font.GothamBold
            c.BorderSizePixel = 0
            c.ZIndex = 100
            Instance.new("UICorner", c).CornerRadius = UDim.new(0, 4)
            c.MouseButton1Click:Connect(function()
                local ch = p.Character
                if ch then
                    local h = ch:FindFirstChildOfClass("Humanoid")
                    if h then
                        local cam = Workspace.CurrentCamera
                        if cam.CameraSubject == h then
                            local mh = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                            if mh then cam.CameraSubject = mh end
                        else
                            cam.CameraSubject = h
                        end
                    end
                end
            end)

            svRows[p] = btn
        end)
    end

    local function refreshSv()
        for _, b in pairs(svRows) do
            pcall(function() if b and b.Parent then b:Destroy() end end)
        end
        svRows = {}
        local list = Players:GetPlayers()
        table.sort(list, function(a,b) return a.DisplayName:lower() < b.DisplayName:lower() end)
        for _, p in ipairs(list) do
            if p ~= LP then
                local row = svs:AddButton({
                    Title = p.DisplayName,
                    Description = "@" .. p.Name,
                    Callback = function() end
                })
                attachSv(row, p)
            end
        end
    end

    refreshSv()
    Players.PlayerAdded:Connect(function() task.wait(0.5); refreshSv() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshSv() end)

    local sts = T.St:AddSection("서버")
    sts:AddButton({ Title = "재접속", Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end })
    sts:AddButton({ Title = "UI 닫기", Callback = function()
        W:Destroy()
        if _G.dinoHub then _G.dinoHub:Destroy() _G.dinoHub = nil end
    end })

    IM:SetLibrary(Fluent)
    SaveManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    IM:SetFolder("dinoHub")
    SaveManager:SetFolder("dinoHub")
    SaveManager:BuildConfigSection(T.St)
    IM:ApplyToTab(T.St)

    W:SelectTab(1)
    applyESP()

    Fluent:Notify({Title = "dino Hub", Content = "로드 완료!", Duration = 2})
end

kv.MouseButton1Click:Connect(function()
    if unlocked then return end
    local inp = kb.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if inp == VALID_KEY then
        ks.Text = "인증 성공!"
        ks.TextColor3 = Color3.fromRGB(80, 220, 80)
        task.wait(0.3)
        onVerified()
    else
        ks.Text = "잘못된 키입니다."
        ks.TextColor3 = Color3.fromRGB(240, 80, 80)
    end
end)
kb.FocusLost:Connect(function(e)
    if e and not unlocked then
        local inp = kb.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if inp == VALID_KEY then
            ks.Text = "인증 성공!"
            ks.TextColor3 = Color3.fromRGB(80, 220, 80)
            task.wait(0.3)
            onVerified()
        else
            ks.Text = "잘못된 키입니다."
            ks.TextColor3 = Color3.fromRGB(240, 80, 80)
        end
    end
end)
