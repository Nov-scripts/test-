local Nexus = {}

local UIS = game:GetService("UserInputService")

local blue = Color3.fromRGB(0, 115, 255)
local darkerBlack = Color3.fromRGB(10, 10, 10)

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

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 460, 0, 300)
	MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
	MainFrame.BackgroundColor3 = blue
	MainFrame.BackgroundTransparency = 0
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = gui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.Position = UDim2.new(0, 0, 0, 0)
	TopBar.BackgroundColor3 = darkerBlack
	TopBar.BackgroundTransparency = 0
	TopBar.Parent = MainFrame
	Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -10, 1, 0)
	TitleLabel.Position = UDim2.new(0, 10, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title or "Nexus UI"
	TitleLabel.TextColor3 = Color3.new(1, 1, 1)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 18
	TitleLabel.Parent = TopBar

	local TabPanel = Instance.new("Frame")
	TabPanel.Size = UDim2.new(0, 120, 1, -35)  -- wider tab panel
	TabPanel.Position = UDim2.new(0, 0, 0, 35)
	TabPanel.BackgroundColor3 = darkerBlack
	TabPanel.BackgroundTransparency = 0.6  -- transparent but visible
	TabPanel.Parent = MainFrame
	Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)

	local ContentPanel = Instance.new("Frame")
	ContentPanel.Size = UDim2.new(1, -120, 1, -35)
	ContentPanel.Position = UDim2.new(0, 120, 0, 35)
	ContentPanel.BackgroundColor3 = darkerBlack
	ContentPanel.BackgroundTransparency = 0
	ContentPanel.Parent = MainFrame
	Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 12)

	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0, 24, 0, 24)
	Close.Position = UDim2.new(1, -28, 0, 6)
	Close.Text = "X"
	Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	Close.BackgroundTransparency = 0.2
	Close.TextColor3 = Color3.new(1, 1, 1)
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 14
	Close.Parent = MainFrame
	Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

	Close.MouseButton1Click:Connect(function()
		gui.Enabled = false
	end)

	-- Make dragging work on whole MainFrame (better UX)
	makeDraggable(MainFrame)

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
