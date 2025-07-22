--// Services
local UIS = game:GetService("UserInputService")

--// Colors
local blue = Color3.fromRGB(0, 115, 255)
local darkBlue = Color3.fromRGB(10, 25, 50)
local darkerBlack = Color3.fromRGB(10, 10, 10) -- darker for TabPanel
local black = Color3.fromRGB(20, 20, 20)

--// Transparency Level (0 = solid, 1 = invisible)
local TRANSPARENCY = 0.3

--// Drag Function
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

--// Create Window Function (UI Library)
local Nexus = {}

function Nexus:CreateWindow(title)
	-- Main GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "NexusUI"
	gui.ResetOnSpawn = false
	gui.Parent = game.CoreGui

	-- Main Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 460, 0, 300)
	MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
	MainFrame.BackgroundColor3 = blue
	MainFrame.BackgroundTransparency = TRANSPARENCY
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = gui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

	-- Top Bar (Title Bar)
	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1, 0, 0, 35)
	TopBar.Position = UDim2.new(0, 0, 0, 0)
	TopBar.BackgroundColor3 = darkerBlack
	TopBar.BackgroundTransparency = TRANSPARENCY
	TopBar.Parent = MainFrame
	Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

	-- Title Label
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

	makeDraggable(TopBar)

	-- Tab Panel (Left)
	local TabPanel = Instance.new("Frame")
	TabPanel.Size = UDim2.new(0, 80, 1, -35)
	TabPanel.Position = UDim2.new(0, 0, 0, 35)
	TabPanel.BackgroundColor3 = darkerBlack
	TabPanel.BackgroundTransparency = TRANSPARENCY
	TabPanel.Parent = MainFrame
	Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)

	-- Content Panel (Right)
	local ContentPanel = Instance.new("Frame")
	ContentPanel.Size = UDim2.new(1, -80, 1, -35)
	ContentPanel.Position = UDim2.new(0, 80, 0, 35)
	ContentPanel.BackgroundColor3 = darkBlue
	ContentPanel.BackgroundTransparency = TRANSPARENCY
	ContentPanel.Parent = MainFrame
	Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 12)

	-- Close Button
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

	-- Return UI table to add content inside ContentPanel
	local UI = {}
	UI.MainFrame = MainFrame
	UI.TabPanel = TabPanel
	UI.Content = ContentPanel
	UI.TopBar = TopBar
	UI.TitleLabel = TitleLabel
	UI.CloseButton = Close

	return UI
end

return Nexus
