local Nexus = {}

local UIS = game:GetService("UserInputService")

local blue = Color3.fromRGB(0, 115, 255)
local dark = Color3.fromRGB(20, 20, 20)
local lightDark = Color3.fromRGB(40, 40, 40)

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

	-- Tab panel (always visible)
	local TabPanel = Instance.new("Frame")
	TabPanel.Size = UDim2.new(0, 40, 0, 300)
	TabPanel.Position = UDim2.new(0.3, -40, 0.3, 0) -- positioned just left of main frame
	TabPanel.BackgroundColor3 = lightDark
	TabPanel.Name = "TabPanel"
	TabPanel.Parent = gui
	Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)

	local TabLabel = Instance.new("TextLabel")
	TabLabel.Text = "Nov"
	TabLabel.Size = UDim2.new(1, 0, 0, 40)
	TabLabel.Position = UDim2.new(0, 0, 0, 10)
	TabLabel.BackgroundTransparency = 1
	TabLabel.TextColor3 = Color3.new(1, 1, 1)
	TabLabel.Font = Enum.Font.GothamBold
	TabLabel.TextSize = 20
	TabLabel.Parent = TabPanel

	-- Main UI Frame (starts visible)
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 420, 0, 300)
	MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
	MainFrame.BackgroundColor3 = blue
	MainFrame.BackgroundTransparency = 0
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = gui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

	-- TopBar with title and close button
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.Position = UDim2.new(0, 0, 0, 0)
	TopBar.BackgroundColor3 = dark
	TopBar.Parent = MainFrame
	Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title or "Nexus UI"
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.Parent = TopBar

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
		MainFrame.Visible = false
	end)

	-- Content Panel
	local ContentPanel = Instance.new("Frame")
	ContentPanel.Size = UDim2.new(1, 0, 1, -35)
	ContentPanel.Position = UDim2.new(0, 0, 0, 35)
	ContentPanel.BackgroundColor3 = dark
	ContentPanel.Parent = MainFrame
	Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 12)

	-- Dragging the main UI frame only
	makeDraggable(MainFrame)

	-- Toggle main UI visibility when tab panel clicked
	TabPanel.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	return {
		MainFrame = MainFrame,
		TabPanel = TabPanel,
		Content = ContentPanel,
		TopBar = TopBar,
		TitleLabel = TitleLabel,
		CloseButton = Close,
	}
end

return Nexus
