local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local LocalPLR = game.Players.LocalPlayer

Username = getgenv().Username

local runScript = true
local copychat = false
local copychatUsername = ""
if LocalPLR.Name ~= Username then

    local logChat = getgenv().logChat
    webhook = getgenv().webhook

    Prefix = getgenv().Prefix

    local bots = getgenv().Bots

    local whitelist = {}
    local admins = {}

    local index
    function getIndex()

        for i, bot in ipairs(bots) do
            if LocalPLR.DisplayName == bot then
                index = i
                break
            end
        end

    end

    getIndex()

    function chat(msg)

        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        else
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end

    end

    chat("afgbot running")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Thank You",
        Text = "Thank you for using afgbot!",
        Time = 6
    })

    function showDefaultGui(enabled, text)

        if enabled == true then
            for _, child in pairs(game:GetService("CoreGui"):GetChildren()) do
                if child.Name == "bruhIDK" then
                    child:Destroy()
                end
            end

            screenGui = Instance.new("ScreenGui")
            screenGui.Name = "bruhIDK"
            screenGui.IgnoreGuiInset = true
            screenGui.Parent = game:GetService("CoreGui")

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(0, 205, 216)
            frame.Parent = screenGui

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = text
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.TextSize = 40
            textLabel.TextScaled = true
            textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            textLabel.Parent = frame
        elseif enabled == false then
            if screenGui then
                screenGui:Destroy()
            end
        end

    end

    function sendToWebhook(msg, username)
        if index ~= 1 then
            return
        end

        local data = {
            content = msg,
            username = username
        }

        local requestData = {
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
            },
            Body = HttpService:JSONEncode(data)
        }

        request(requestData)
    end

    function specifyBots(sub, callback)

        local botArgs = getArgs(sub)

        if next(botArgs) ~= nil then
            for _, arg in ipairs(botArgs) do
                if index == tonumber(arg) then
                    callback()
                end
            end
        else
            callback()
        end

    end

    function specifyBots2(argTable, tableStartIndex, callback)

        local botArgs = {}

        for i = tableStartIndex, #argTable do
            table.insert(botArgs, argTable[i])
        end

        if #botArgs == 0 then
            callback()
        else
            for _, botArg in ipairs(botArgs) do
                if index == tonumber(botArg) then
                    callback()
                end
            end
        end

    end

    function getArgs(command)

        local args = {}

        for arg in command:match("^%s*(.-)%s*$"):gmatch("%S+") do
            table.insert(args, arg)
        end

        return args

    end

    function isR15(returnValTrue, returnValFalse)

        if LocalPLR.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
            if returnValTrue then
                return returnValTrue
            else
                return true
            end
        elseif LocalPLR.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            if returnValFalse then
                return returnValFalse
            else
                return false
            end
        end

    end

    function isWhitelisted(name)

        if name == Username then
            return true
        end

        for _, adminUser in pairs(admins) do
            if name == adminUser then
                return true
            end
        end

        for _, whitelistedUser in pairs(whitelist) do
            if name == whitelistedUser then
                return true
            end
        end

        return false
    end

    function isAdmin(name)

        for _, adminUser in pairs(admins) do
            if name == adminUser then
                return true
            end
        end

        return false
    end

    -- RANDOM VARS:
    local normalGravity = 196.2

    function commands(player, message)
        local msg = message:lower()

        if not isWhitelisted(player.Name) then
            return
        end

        function getFullPlayerName(typedName)

            if typedName == "me" then
                return player.Name
            end

            for _, plr in pairs(game.Players:GetPlayers()) do
                if string.find(plr.Name, typedName) then
                    return plr.Name
                end
            end

        end

        -- WHITELIST:
        if msg:sub(1, 11) == Prefix .. "whitelist+" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetPLR = message:sub(13)

            if game.Players[targetPLR] then
                table.insert(whitelist, targetPLR)

                if index == 1 then
                    chat("Added Player To Whitelist!")
                end
            elseif index == 1 then
                chat("Player Could Not Be Found!")
            end
        end

        if msg:sub(1, 11) == Prefix .. "whitelist-" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetPLR = message:sub(13)

            for i, whitelistedUser in pairs(whitelist) do
                if whitelistedUser == targetPLR then
                    table.remove(whitelist, i)

                    if index == 1 then
                        chat("Removed Player From Whitelist!")
                    end

                end
            end
        end

        if msg:sub(1, 7) == Prefix .. "admin+" then

            if player.Name ~= Username then
                return
            end

            local targetPLR = message:sub(9)

            if game.Players[targetPLR] then
                table.insert(admins, targetPLR)

                if index == 1 then
                    chat("Added Player To Admins!")
                end
            elseif index == 1 then
                chat("Player Could Not Be Found!")
            end
        end

        if msg:sub(1, 7) == Prefix .. "admin-" then

            if player.Name ~= Username then
                return
            end

            local targetPLR = message:sub(9)

            for i, adminUser in pairs(admins) do
                if adminUser == targetPLR then
                    table.remove(admins, i)

                    if index == 1 then
                        chat("Removed Player From Admins!")
                    end

                end
            end
        end

        if msg:sub(1, 10) == Prefix .. "botremove" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local targetIndex = tonumber(msg:sub(12))
            if not targetIndex then
                if index == 1 then
                    chat("Please enter bot index to remove!")
                end

                return
            end

            table.remove(bots, targetIndex)
            if index == targetIndex then
                Username = ""
                whitelist = {}
                admins = {}

                script:Destroy()
            end

            getIndex()
            if index == 1 then
                chat("Bot " .. targetIndex .. " has been removed!")
            end
        end

        -- REJOIN:
        if msg:sub(1, 7) == Prefix .. 'rejoin' then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            function runCode()
                LocalPLR:Kick("REJOINING...")
                wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPLR)
            end

            specifyBots(msg:sub(9), runCode)

        end

        -- RESET:
        if msg:sub(1, 6) == Prefix .. "reset" then

            function runCode()
                LocalPLR.Character.Humanoid.Health = 0
            end

            specifyBots(msg:sub(8), runCode)

        end

        -- JUMP:
        if msg:sub(1, 5) == Prefix .. "jump" then

            function runCode()
                LocalPLR.Character.Humanoid.Jump = true
            end

            specifyBots(msg:sub(7), runCode)

        end

        -- BRING:
        if msg:sub(1, 6) == Prefix .. "bring" then

            function runCode()
                LocalPLR.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Players[player.Name].Character:FindFirstChild("HumanoidRootPart").CFrame
            end

            specifyBots(msg:sub(8), runCode)

        end

        -- LOGCHAT:
        if msg:sub(1, 8) == Prefix .. "logchat" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            local switch = msg:sub(10)

            if switch == "disable" then
                logChat = false

                if index == 1 then
                    chat("Logchat has been disabled!")
                end
            elseif switch == "enable" then
                logChat = true

                if index == 1 then
                    chat("Logchat has been enabled!")
                end
            end
        end

        -- COPYCHAT:
        if msg:sub(1, 9) == Prefix .. "copychat" then

            local args = getArgs(message:sub(11))
            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if game.Players[targetPLR] then
                    copychat = true
                    copychatUsername = targetPLR

                    if index == 1 then
                        chat("Copying " .. targetPLR .. "'s chat!")
                    end
                end
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 11) == Prefix .. "uncopychat" then

            function runCode()
                copychat = false
                copychatUsername = ""

                if index == 1 then
                    chat("Stopped copying chat!")
                end
            end

            specifyBots(msg:sub(13), runCode)

        end

        -- CHAT:
        if msg:sub(1, 5) == Prefix .. "chat" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            chat(message:sub(7))

        end

        -- SIT:
        if msg:sub(1, 4) == Prefix .. "sit" then

            function runCode()
                LocalPLR.Character.Humanoid.Sit = true
            end

            specifyBots(msg:sub(6), runCode)

        end

        -- SPEED:
        if msg:sub(1, 6) == Prefix .. "speed" then
            local args = getArgs(msg:sub(8))

            function runCode()
                LocalPLR.Character.Humanoid.WalkSpeed = args[1]
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 8) == Prefix .. "gravity" then
            local args = getArgs(msg:sub(10))

            function runCode()
                if tonumber(args[1]) then
                    workspace.Gravity = tonumber(args[1])
                end
            end

            specifyBots2(args, 2, runCode)

        end

        -- LINEUP:
        if msg:sub(1, 7) == Prefix .. "lineup" then

            local direction = msg:sub(9)
            local spacing = 3

            local targetHumanoidRootPart = game.Players[player.Name].Character.HumanoidRootPart

            local directionVector
            if direction == "front" then
                spacing = 3
                directionVector = targetHumanoidRootPart.CFrame.LookVector
            elseif direction == "back" then
                spacing = 3
                directionVector = -targetHumanoidRootPart.CFrame.LookVector
            elseif direction == "left" then
                spacing = 5
                directionVector = -targetHumanoidRootPart.CFrame.RightVector
            elseif direction == "right" then
                spacing = 5
                directionVector = targetHumanoidRootPart.CFrame.RightVector
            end

            local offset = directionVector * (spacing * index)
            LocalPLR.Character.HumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame + offset

        end

        -- 4K:
        if msg:sub(1, 3) == Prefix .. "4k" then
            local targetPLR = getFullPlayerName(message:sub(5))

            if game.Players[targetPLR] then

                local args = getArgs(message:sub(5))
                local targetPLR = getFullPlayerName(args[1])

                local player = game.Players[targetPLR].Character.HumanoidRootPart
                local lpr = LocalPLR.Character.HumanoidRootPart

                local speed = 8
                local radius = 8
                local spacing = 1
                local eclipse = 1

                local sin, cos = math.sin, math.cos
                local rotspeed = math.pi*2/speed
                eclipse = eclipse * radius

                local rot = 0

                rot = rot + rotspeed

                local offsetAngle = rot - (index * spacing)
                local offset = Vector3.new(sin(offsetAngle) * eclipse, 0, cos(offsetAngle) * radius)
                local newPosition = player.Position + offset

                lpr.CFrame = CFrame.new(newPosition, player.Position)

                chat("📸CAUGHT IN 4K📸")

            end
        end

        -- JORK(yep under 4k):
        if msg:sub(1, 5) == Prefix .. "jork" then
            local args = getArgs(msg:sub(7))
            local speed = tonumber(args[1]) or 1

            function runCode()
                jorkAnim = Instance.new("Animation")
                jorkAnim.AnimationId = "rbxassetid://99198989"

                animTrack = LocalPLR.Character.Humanoid:LoadAnimation(jorkAnim)
                animTrack.Looped = true
                animTrack:Play()
                animTrack:AdjustSpeed(speed)

                jorkAnim2 = Instance.new("Animation")
                jorkAnim2.AnimationId = "rbxassetid://168086975"

                animTrack2 = LocalPLR.Character.Humanoid:LoadAnimation(jorkAnim2)
                animTrack2.Looped = true
                animTrack2:Play()
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 7) == Prefix .. "unjork" then

            function runCode()
                if jorkAnim then
                    jorkAnim:Destroy()
                    animTrack:Stop()
                end

                if jorkAnim2 then
                    jorkAnim2:Destroy()
                    animTrack2:Stop()
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        -- ROCKET:
        if msg:sub(1, 7) == Prefix .. "rocket" then
            local args = getArgs(msg:sub(9))
            local studs = tonumber(args[1]) or 500

            if index == 1 then
                chat("Target Height: " .. studs .. " studs")
                wait()

                chat("Launching In: 3")
                wait(1)

                chat("Launching In: 2")
                wait(1)

                chat("Launching In: 1")
                wait(1)

                chat("Lifting Up!")
                wait(0.5)
            else
                wait()
                wait(3.5)
            end

            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "SpinningRocket"
            Spin.Parent = LocalPLR.Character.HumanoidRootPart
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0, 15 ,0)

            while LocalPLR.Character.HumanoidRootPart.Position.Y <= studs do
                wait()

                LocalPLR.Character.HumanoidRootPart.Position += Vector3.new(0, 1.5, 0)
            end

            LocalPLR.Character.Humanoid.Health = 0

        end

        -- GOTO:
        if msg:sub(1, 5) == Prefix .. "goto" then
            local args = getArgs(message:sub(7))

            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if game.Players[targetPLR] then
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame
                end
            end

            specifyBots2(args, 2, runCode)

        end

        -- FOLLOW:
        if msg:sub(1, 7) == Prefix .. "follow" then
            local args = getArgs(message:sub(9))

            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                followF = RunService.Heartbeat:Connect(function()
                    LocalPLR.Character:FindFirstChild("Humanoid"):MoveTo(game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart").Position)
                end)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 9) == Prefix .. "backflip" then

            function runCode()
                LocalPLR.Character.Humanoid:ChangeState("Jumping")
                wait()
                LocalPLR.Character.Humanoid.Sit = true
                for i = 1,360 do
                    delay(i/720,function()
                        LocalPLR.Character.Humanoid.Sit = true
                        LocalPLR.Character.HumanoidRootPart.CFrame = LocalPLR.Character.HumanoidRootPart.CFrame * CFrame.Angles(0.0174533, 0, 0)
                    end)
                end
                wait(0.55)
                LocalPLR.Character.Humanoid.Sit = false
            end

            specifyBots(msg:sub(11), runCode)

        end

        if msg:sub(1, 10) == Prefix .. "frontflip" then

            function runCode()
                LocalPLR.Character.Humanoid:ChangeState("Jumping")
                wait()
                LocalPLR.Character.Humanoid.Sit = true
                for i = 1,360 do
                    delay(i/720,function()
                        LocalPLR.Character.Humanoid.Sit = true
                        LocalPLR.Character.HumanoidRootPart.CFrame = LocalPLR.Character.HumanoidRootPart.CFrame * CFrame.Angles(-0.0174533, 0, 0)
                    end)
                end
                wait(0.55)
                LocalPLR.Character.Humanoid.Sit = false
            end

            specifyBots(msg:sub(12), runCode)

        end

        -- SPIN:
        if msg:sub(1, 5) == Prefix .. "spin" then
            local args = getArgs(msg:sub(7))

            local spinSpeed = tonumber(args[1]) or 10

            function runCode()
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = LocalPLR.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 7) == Prefix .. "unspin" then

            function runCode()
                for _, v in pairs(LocalPLR.Character.HumanoidRootPart:GetChildren()) do
                    if v.Name == "Spinning" then
                        v:Destroy()
                    end
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        -- BANG:
        if msg:sub(1, 5) == Prefix .. "bang" then

            local args = getArgs(message:sub(7))
            local targetPLR = getFullPlayerName(args[1])

            local bangSpeed = tonumber(args[2]) or 10

            function runCode()
                if game.Players[targetPLR] then

                    bangAnim = Instance.new('Animation')
                    bangAnim.AnimationId = "rbxassetid://" .. isR15(5918726674, 148840371)
                    plrHum = LocalPLR.Character.Humanoid

                    anim = plrHum:LoadAnimation(bangAnim)
                    anim:Play()
                    anim:AdjustSpeed(bangSpeed)

                    bangLoop = RunService.Stepped:Connect(function()
                        wait()
                        LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
                    end)
                end

            end

            specifyBots2(args, 3, runCode)

        end

        -- FACEBANG:
        if msg:sub(1, 9) == Prefix .. "facebang" then

            local args = getArgs(message:sub(11))
            local targetPLR = getFullPlayerName(args[1])

            local bangSpeed = tonumber(args[2]) or 10
            local bangOffet = CFrame.new(0, 2.3, -1.1)

            function runCode()
                if game.Players[targetPLR] then

                    bangAnim2 = Instance.new('Animation')
                    bangAnim2.AnimationId = "rbxassetid://" .. isR15(5918726674, 148840371)
                    plrHum = LocalPLR.Character.Humanoid

                    anim2 = plrHum:LoadAnimation(bangAnim2)
                    anim2:Play(0.1, 1, 1)
                    anim2:AdjustSpeed(bangSpeed)

                    facebangLoop = RunService.Stepped:Connect(function()
                        wait()

                        local targetRoot = LocalPLR.Character:FindFirstChild("HumanoidRootPart")
                        targetRoot.CFrame = game.Players[targetPLR].Character:FindFirstChild("HumanoidRootPart").CFrame * bangOffet * CFrame.Angles(0,3.15,0)
                        targetRoot.Velocity = Vector3.new(0,0,0)
                    end)

                end
            end

            specifyBots2(args, 3, runCode)

        end

        if msg:sub(1, 7) == Prefix .. "unbang" then

            function runCode()
                if anim then
                    anim:Stop()
                    bangAnim:Destroy()
                end
                if bangLoop then
                    bangLoop:Disconnect()
                end

                if anim3 then
                    anim3:Stop()
                    bangAnim3:Destroy()
                end
                if bangLoop2 then
                    bangLoop2:Disconnect()
                end
            end

            specifyBots(msg:sub(9), runCode)

        end

        if msg:sub(1, 4) == Prefix .. "riz" then

            local rizzlines = {
                "Can I be your snowflake? I promise to never melt away from your heart.",
                "Are you a Wi-Fi signal? Because I’m feeling a strong connection.",
                "Are you a heart? Because I'd never stop beating for you.",
                "I believe in following my dreams, so you lead the way.",
                "If being beautiful was a crime, you’d be on the most wanted list.",
                "Are you iron? Because I don’t get enough of you.",
                "You should be Jasmine without the 'Jas'.",
                "Are you a Disney ride? Because I'd wait forever for you.",
                "Hey, I’m sorry to bother you, but my phone must be broken because it doesn’t seem to have your number in it.",
                "Are you good at math? Me neither, the only number I care about is yours.",
                "Is your name Elsa? Because I can't let you go.",
                "Do you know the difference between history and you? History is the past and you are my future.",
                "Do you work for NASA? Because your beauty is out of this world.",
                "Math is so confusing. It's always talking about x and y and never you and I.",
                "Are you Christmas morning? Because I’ve been waiting all year for you to arrive.",
                "Are you from Tennessee? Because you're the only ten I see.",
                "Are you Nemo? Because I've been trying to find you.",
                "Are you a bank loan? Because you have my interest.",
                "I hope you know CPR, because you just took my breath away.",
                "Are you the sun? Because I could stare at you all day, and it’d be worth the risk.",
                "Are you a keyboard? Because you're just my type.",
                "My mom said sharing is caring but, no...you're all mine!",
                "It's time to pay up. It's the first of the month, and you've been living in my mind rent-free.",
                "Are you a light? Because you always make me feel bright.",
                "Do you have a bandaid? My knees hurt from falling for you.",
                "We may not be pants, but we'd make a great pair.",
                "You know what's beautiful? Repeat the first word.",
                "Your eyes remind me of Ikea: easy to get lost in.",
                "If you were a Transformer, you'd be Optimus Fine.",
                "I must be a time traveler, because I can't imagine my future without you.",
                "Are you a light switch? Because you turn me on.",
                "Are you a doctor? Because you instantly make me feel better.",
                "You must be a masterpiece, because I can't take my eyes off of you.",
                "Are you my favorite song? Because I can't get you out of my head.",
                "I'm no photographer, but I can picture us together."
            }

            local targetPLR = getFullPlayerName(message:sub(6))
            local randomrizzline = math.random(1, #rizzlines)
            local originalCFrame = LocalPLR.Character.HumanoidRootPart.CFrame

            if not game.Players[targetPLR] then
                return
            end

            wait(5 * (index - 1))

            rizzFollow = RunService.Heartbeat:Connect(function()
                LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
            end)
            chat(rizzlines[randomrizzline])

            wait(5)

            rizzFollow:Disconnect()
            LocalPLR.Character.HumanoidRootPart.CFrame = originalCFrame

        end

        -- WINGS (yep under riz):
        if msg:sub(1, 6) == Prefix .. "wings" then
            if #bots < 2 then
                if index == 1 then
                    chat("You need minimum of 2 bots to use this command!")
                end

                return
            end

            if index > 2 then
                return
            end

            local args = getArgs(message:sub(8))
            local targetPLR = getFullPlayerName(args[1])

            if game.Players[targetPLR] then
                workspace.Gravity = 0
                wingsF = RunService.Heartbeat:Connect(function(deltaTime)
                    if index == 1 then
                        LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position) * CFrame.new(1, 0, 0) * CFrame.Angles(0, 0, 65)
                    else
                        LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position) * CFrame.new(-1, 0, 0) * CFrame.Angles(0, 0, -65)
                    end
                end)
            end

        end

        if msg == Prefix .. "unwings" then
            if wingsF then
                wingsF:Disconnect()
            end

            workspace.Gravity = normalGravity
        end

        if msg:sub(1, 7) == Prefix .. "bridge" then

            local args = getArgs(message:sub(9))
            local targetPLR = getFullPlayerName(args[1])
            local botInfront

            for i, bot in pairs(bots) do
                if i == index - 1 then
                    botInfront = bot
                end
            end

            carpetAnim4 = Instance.new("Animation")
            carpetAnim4.AnimationId = "rbxassetid://282574440"
            carpet4 = LocalPLR.Character.Humanoid:LoadAnimation(carpetAnim4)
            carpet4:Play(0.1, 1, 1)

            workspace.Gravity = 0
            if index == 1 then
                LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)

                wait(0.5)
                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = true
                    end
                end
            else
                bridgeF = RunService.Heartbeat:Connect(function(deltaTime)
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[botInfront].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -(index + 1.5))
                end)
            end

        end

        if msg == Prefix .. "unbridge" then
            if index == 1 then
                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = false
                    end
                end
            end

            if carpetAnim4 then
                carpet4:Stop()
                carpetAnim4:Destroy()
            end

            if bridgeF then
                bridgeF:Disconnect()
            end

            workspace.Gravity = normalGravity
        end

        if msg:sub(1, 7) == Prefix .. "carpet" then

            local args = getArgs(message:sub(9))
            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                carpetAnim = Instance.new("Animation")
                carpetAnim.AnimationId = "rbxassetid://282574440"
                carpet = LocalPLR.Character.Humanoid:LoadAnimation(carpetAnim)
                carpet:Play(0.1, 1, 1)

                carpetF = RunService.Heartbeat:Connect(function()
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame
                end)
            end

            specifyBots2(args, 2, runCode)

        end

        if msg:sub(1, 9) == Prefix .. "uncarpet" then

            function runCode()
                carpetF:Disconnect()
                carpet:Stop()
                carpetAnim:Destroy()
            end

            specifyBots(msg:sub(11), runCode)

        end

        -- HUG:
        if msg:sub(1, 4) == Prefix .. "hug" then
            local args = getArgs(message:sub(6))
            local targetPLR = getFullPlayerName(args[1])

            function runCode()
                if not isR15() then
                    if game.Players[targetPLR] then

                        anim1 = Instance.new("Animation")
                        anim1.AnimationId = "rbxassetid://283545583"

                        anim1p = LocalPLR.Character.Humanoid:LoadAnimation(anim1)
                        anim1p:Play()

                        anim2 = Instance.new("Animation")
                        anim2.AnimationId = "rbxassetid://225975820"

                        anim2p = LocalPLR.Character.Humanoid:LoadAnimation(anim2)
                        anim2p:Play()

                        hugF = RunService.Heartbeat:Connect(function()
                            LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                        end)

                    end
                else
                    chat("Bot needs to be r6!")
                end
            end

            specifyBots2(args, 2, runCode)
        end

        if msg == Prefix .. "unhug" then

            function runCode()
                if anim1 and anim2 then
                    anim1:Destroy()
                    anim2:Destroy()
                end

                if anim1p and anim2p then
                    anim1p:Stop()
                    anim2p:Stop()
                end

                if hugF then
                    hugF:Disconnect()
                end
            end

            specifyBots(msg:sub(7), runCode)

        end

        if msg:sub(1, 8) == Prefix .. "fullbox" then
            if #bots < 4 then
                if index == 1 then
                    chat("You need minimum of 4 bots to use this command!")
                end

                return
            end

            if index > 6 then
                return
            end
            workspace.Gravity = 0

            local args = getArgs(message:sub(10))
            local targetPLR = getFullPlayerName(args[1])

            if index == 4 then
                carpetAnim2 = Instance.new("Animation")
                carpetAnim2.AnimationId = "rbxassetid://282574440"
                carpet2 = LocalPLR.Character.Humanoid:LoadAnimation(carpetAnim2)
                carpet2:Play(0.1, 1, 1)
            end

            if index == 3 then
                carpetAnim3 = Instance.new("Animation")
                carpetAnim3.AnimationId = "rbxassetid://282574440"
                carpet3 = LocalPLR.Character.Humanoid:LoadAnimation(carpetAnim3)
                carpet3:Play(0.1, 1, 1)
            end

            fullboxF = RunService.Heartbeat:Connect(function(deltaTime)
                if index == 1 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                end
                if index == 2 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
                end
                if index == 3 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
                end
                if index == 4 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                end
                if index == 5 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                end
                if index == 6 then
                    LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(-2, 0, 0)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)
                end
            end)
        end

        if msg:sub(1, 10) == Prefix .. "unfullbox" then
            if carpetAnim2 then
                carpet2:Stop()
                carpetAnim2:Destroy()
            end

            if carpetAnim3 then
                carpet3:Stop()
                carpetAnim3:Destroy()
            end

            if fullboxF then
                fullboxF:Disconnect()
            end

            workspace.Gravity = normalGravity
        end

        if msg:sub(1, 7) == Prefix .. "stairs" then

            local args = getArgs(message:sub(9))
            local targetPLR = getFullPlayerName(args[1])
            local botInfront

            for i, bot in pairs(bots) do
                if i == index - 1 then
                    botInfront = bot
                end
            end

            workspace.Gravity = 0
            LocalPLR.Character.Humanoid.Sit = true
            if index == 1 then
                LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.lookAt((game.Players[targetPLR].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)).Position, game.Players[targetPLR].Character.HumanoidRootPart.Position)

                wait(0.5)

                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = true
                    end
                end
            else
                stairsF = RunService.Heartbeat:Connect(function(deltaTime)
                    LocalPLR.Character.HumanoidRootPart.CFrame = CFrame.new((game.Players[botInfront].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)).Position, game.Players[botInfront].Character.HumanoidRootPart.Position) * CFrame.new(0, 2, 0)
                end)
            end
        end

        if msg == Prefix .. "unstairs" then
            if stairsF then
                stairsF:Disconnect()
            end

            if index == 1 then
                for _, child in pairs(LocalPLR.Character:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Anchored = false
                    end
                end
            end

            LocalPLR.Character.Humanoid.Sit = false
            workspace.Gravity = normalGravity
        end

        if msg:sub(1, 6) == Prefix .. "dance" then
            local args = getArgs(msg:sub(8))

            function runCode()
                if not args[1] then
                    if index == 1 then
                        chat("Pick emote or type " .. Prefix .. "dance list!")
                    end
                else
                    if args[1] == "1" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("dance1")
                    elseif args[1] == "2" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("dance2")
                    elseif args[1] == "3" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("dance3")
                    elseif args[1] == "wave" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("wave")
                    elseif args[1] == "cheer" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("cheer")
                    elseif args[1] == "laugh" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("laugh")
                    elseif args[1] == "point" then
                        LocalPLR.Character.Animate.PlayEmote:Invoke("point")
                    elseif args[1] == "list" then
                        if index == 1 then
                            chat("1, 2, 3, wave, cheer, laugh, point")
                        end
                    else
                        if index == 1 then
                            chat("Pick emote or type " .. Prefix .. "dance list!")
                        end
                    end
                end
            end

            specifyBots2(args, 2, runCode)

        end

        -- QUIT
        if msg:sub(1, 5) == Prefix .. "quit" then

            if player.Name ~= Username and not isAdmin(player.Name) then
                return
            end

            function runCode()
                chat("Quitting script on bot " .. index .. "!")

                Username = ""
                whitelist = {}
                admins = {}

                script:Destroy()
            end

            specifyBots(msg:sub(7), runCode)

        end

        -- CMDS:
        if msg:sub(1, 5) == Prefix .. "cmds" then
            local page = msg:sub(7)

            if index == 1 then
                if page == "1" then
                    chat("rejoin, jump, reset, sit, chat (message), shutdown, orbit (username) (speed)/unorbit, bang (username) (speed)/unbang, walkto (username), speed (number), bring, clearchat, privacymode (enable/disable)")

                    wait(0.2)
                    chat("spin (number)/unspin, lineup (direction), 3drender (enable/disable), dance (emote), fling (username)/unfling, follow (username)/unfollow, lookat (username)/unlookat, stack (username)/unstack, quit")

                    wait(0.2)
                    chat("goto (username), carpet (username)/uncarpet, linefollow (username)/unlinefollow, riz (username), facebang (username) (speed)/unfbang, announce (message), rocket (height), antibang, 2orbit (username)")
                elseif page == "2" then
                    chat("surround (username) (spacing), partsrain (username) (height)/unpartsrain, hug (username)/unhug, worm (username)/unworm, index, logchat (enable/disable), 4k (username), whitelist+ (username)/")
                    wait(0.2)

                    chat("whitelist- (username), admin+ (username)/admin- (username), jork (speed)/unjork, frontflip/backflip, freeze/unfreeze, antiafk (enable/disable), version, botremove (index), printcmds, scm, fpscap (num)")
                    wait(0.2)

                    chat("2stack (username)/unstack, 2bang (username)/unbang, fullbox (username)/unfullbox, stairs (username)/unstairs, gravity (number), 2facebang (username)/unfbang, wings (username)/unwings,bridge (username)")
                elseif page == "3" then
                    chat("unbridge, copychat (username)/uncopychat")
                else
                    chat("Please select a page 1, 2 or 3!")
                end
            end

        end

    end

    for _, player in pairs(game.Players:GetPlayers()) do
        player.Chatted:Connect(function(message)
            if not runScript then
                return
            end

            commands(player, message)

            if logChat then
                sendToWebhook("```" .. message .. "```", player.Name)
            end
            if copychat and player.Name == copychatUsername then
                chat(message)
            end
        end)
    end

    game.Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            if not runScript then
                return
            end

            commands(player, message)

            if logChat then
                sendToWebhook("```" .. message .. "```", player.Name)
            end
            if copychat and player.Name == copychatUsername then
                chat(message)
            end
        end)
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        if not runScript then
            return
        end

        for i, bot in pairs(bots) do
            if player.Name == bot then
                table.remove(bots, i)
                getIndex()

                if index == 1 then
                    chat("Bot " .. i .. " left the game!")
                end
            end
        end
    end)
end
