local Nexus = {}

local UIS = game:GetService("UserInputService")

local blue = Color3.fromRGB(0, 115, 255)
local dark = Color3.fromRGB(20, 20, 20)
local lightDark = Color3.fromRGB(40, 40, 40)

-- Dragging function that moves a frame (and anything inside it)
local function makeDraggable(frame)
	local dragging = false
	local dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					conn:Disconnect()
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function Nexus:CreateWindow(title)
	local gui = Instance.new("ScreenGui")
	gui.Name = "NexusUI"
	gui.ResetOnSpawn = false
	gui.Parent = game.CoreGui

	local totalWidth = 440
	local tabWidth = 120 -- wide enough for "Settings" and more
	local mainWidth = totalWidth - tabWidth
	local height = 300

	-- Container frame that holds tab panel + main UI together
	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(0, totalWidth, 0, height)
	Container.Position = UDim2.new(0.3, 0, 0.3, 0)
	Container.BackgroundTransparency = 1 -- invisible container
	Container.Parent = gui

	-- Tab panel (left side)
	local TabPanel = Instance.new("Frame")
	TabPanel.Size = UDim2.new(0, tabWidth, 1, 0)
	TabPanel.Position = UDim2.new(0, 0, 0, 0)
	TabPanel.BackgroundColor3 = lightDark
	TabPanel.Name = "TabPanel"
	TabPanel.Parent = Container
	Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)

	-- Title label on Tab Panel
	local TabTitle = Instance.new("TextLabel")
	TabTitle.Size = UDim2.new(1, 0, 0, 40)
	TabTitle.Position = UDim2.new(0, 0, 0, 10)
	TabTitle.BackgroundTransparency = 1
	TabTitle.Text = title or "Settings"
	TabTitle.TextColor3 = Color3.new(1, 1, 1)
	TabTitle.Font = Enum.Font.GothamBold
	TabTitle.TextSize = 20
	TabTitle.TextXAlignment = Enum.TextXAlignment.Center
	TabTitle.Parent = TabPanel

	-- Main UI Frame (right side)
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, mainWidth, 1, 0)
	MainFrame.Position = UDim2.new(0, tabWidth, 0, 0)
	MainFrame.BackgroundColor3 = blue
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Container
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

	-- TopBar inside main UI (title + close button)
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.Position = UDim2.new(0, 0, 0, 0)
	TopBar.BackgroundColor3 = dark
	TopBar.Parent = MainFrame
	Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

	-- Title label inside top bar (optional, here for extra clarity, or hide it)
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title or "Settings"
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.Parent = TopBar

	-- Close button on top right
	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0, 24, 0, 24)
	Close.Position = UDim2.new(1, -28, 0, 6)
	Close.Text = "X"
	Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	Close.BackgroundTransparency = 0.2
	Close.TextColor3 = Color3.new(1, 1, 1)
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 14
	Close.Parent = TopBar
	Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

	Close.MouseButton1Click:Connect(function()
		Container.Visible = false
	end)

	-- Content Panel inside main frame below top bar
	local ContentPanel = Instance.new("Frame")
	ContentPanel.Size = UDim2.new(1, 0, 1, -35)
	ContentPanel.Position = UDim2.new(0, 0, 0, 35)
	ContentPanel.BackgroundColor3 = dark
	ContentPanel.Parent = MainFrame
	Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 12)

	-- Drag whole container (tab + main UI) as one
	makeDraggable(Container)

	-- Toggle UI visibility when clicking tab panel
	TabPanel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Container.Visible = not Container.Visible
		end
	end)

	return {
		Container = Container,
		TabPanel = TabPanel,
		MainFrame = MainFrame,
		TopBar = TopBar,
		TitleLabel = TitleLabel,
		CloseButton = Close,
		Content = ContentPanel,
		TabTitle = TabTitle,
	}
end

return Nexus
