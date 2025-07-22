local Library = {}

local UserInputService = game:GetService("UserInputService")

local theme = "Light"

function Library:SetTheme(t)
    theme = t
end

function Library:CreateWindow(opts)
    local self = {}
    self.Tabs = {}

    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = opts.Title or "NovUI"
    screenGui.ResetOnSpawn = false

    local main = Instance.new("Frame", screenGui)
    main.Size = opts.Size or UDim2.fromOffset(500, 350)
    main.Position = UDim2.new(0.5, - (opts.Size and opts.Size.X.Offset or 500) / 2, 0.5, - (opts.Size and opts.Size.Y.Offset or 350) / 2)
    main.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25,25,25) or Color3.fromRGB(240,240,240)
    main.BorderSizePixel = 0
    main.Name = "MainUI"
    main.Active = true
    -- Remove deprecated Draggable property

    -- Manual drag implementation
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y

        -- Clamp so window stays in screen bounds
        local viewport = workspace.CurrentCamera.ViewportSize
        newX = math.clamp(newX, 0, viewport.X - main.AbsoluteSize.X)
        newY = math.clamp(newY, 0, viewport.Y - main.AbsoluteSize.Y)

        main.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Sidebar for tabs
    local side = Instance.new("Frame", main)
    side.Size = UDim2.new(0, opts.SideBarWidth or 100, 1, 0)
    side.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(15,15,15) or Color3.fromRGB(220,220,220)
    side.BorderSizePixel = 0

    -- Content holder
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -side.Size.X.Offset, 1, 0)
    content.Position = UDim2.new(0, side.Size.X.Offset, 0, 0)
    content.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30,30,30) or Color3.fromRGB(255,255,255)
    content.BorderSizePixel = 0

    -- Tab creation
    function self:Tab(data)
        local tabButton = Instance.new("TextButton", side)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Text = data.Title
        tabButton.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(200, 200, 200)
        tabButton.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = true

        local tabFrame = Instance.new("Frame", content)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = (#self.Tabs == 0)

        -- Tab click handler
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, t in pairs(content:GetChildren()) do
                if t:IsA("Frame") then
                    t.Visible = false
                end
            end
            tabFrame.Visible = true

            -- Reset all tab buttons to default color
            for _, btn in pairs(side:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(200, 200, 200)
                    btn.TextColor3 = theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
                end
            end
            -- Highlight selected tab
            tabButton.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(75, 135, 255) or Color3.fromRGB(100, 150, 255)
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(self.Tabs, {Frame = tabFrame, Button = tabButton})
        return tabFrame
    end

    return self
end

return Library
