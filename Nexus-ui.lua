local Library = {}

local theme = "Light"

function Library:SetTheme(t)
    theme = t
end

function Library:CreateWindow(opts)
    local self = {}
    self.Tabs = {}

    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = opts.Title or "NovUI"

    local main = Instance.new("Frame", screenGui)
    main.Size = opts.Size or UDim2.fromOffset(500, 350)
    main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
    main.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(25,25,25) or Color3.fromRGB(240,240,240)
    main.BorderSizePixel = 0
    main.Name = "MainUI"
    main.Active = true
    main.Draggable = true

    local side = Instance.new("Frame", main)
    side.Size = UDim2.new(0, opts.SideBarWidth or 100, 1, 0)
    side.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(15,15,15) or Color3.fromRGB(220,220,220)
    side.BorderSizePixel = 0

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -side.Size.X.Offset, 1, 0)
    content.Position = UDim2.new(0, side.Size.X.Offset, 0, 0)
    content.BackgroundColor3 = theme == "Dark" and Color3.fromRGB(30,30,30) or Color3.fromRGB(255,255,255)
    content.BorderSizePixel = 0

    function self:Tab(data)
        local tabButton = Instance.new("TextButton", side)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Text = data.Title
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BackgroundTransparency = 0
        tabButton.TextColor3 = Color3.fromRGB(255,255,255)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = true

        local tabFrame = Instance.new("Frame", content)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = #self.Tabs == 0

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(content:GetChildren()) do
                if t:IsA("Frame") then t.Visible = false end
            end
            tabFrame.Visible = true
        end)

        table.insert(self.Tabs, {Frame = tabFrame, Button = tabButton})
        return tabFrame
    end

    return self
end

return Library
