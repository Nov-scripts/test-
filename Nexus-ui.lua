local Nexus = {}

local UIS = game:GetService("UserInputService")

local tabWidth = 140 -- wide enough for tab text
local totalWidth = 440
local height = 300
local colorTab = Color3.fromRGB(40,40,40)
local colorMain = Color3.fromRGB(0,115,255)
local colorClose = Color3.fromRGB(255,50,50)

local function makeDraggable(frame)
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			frame.Position = UDim2.new(
				framePos.X.Scale,
				framePos.X.Offset + delta.X,
				framePos.Y.Scale,
				framePos.Y.Offset + delta.Y
			)
		end
	end)
end

function Nexus:CreateWindow(title)
	local gui = Instance.new("ScreenGui")
	gui.Name = "NexusUI"
	gui.ResetOnSpawn = false
	gui.Parent = game.CoreGui

	local container = Instance.new("Frame")
	container.Name = "MainContainer"
	container.Size = UDim2.new(0, totalWidth, 0, height)
	container.Position = UDim2.new(0.3, 0, 0.3, 0)
	container.BackgroundColor3 = Color3.fromRGB(20,20,20)
	container.BorderSizePixel = 0
	container.Parent = gui
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 12)

	-- Tabs area on left
	local tabsFrame = Instance.new("Frame")
	tabsFrame.Name = "Tabs"
	tabsFrame.Size = UDim2.new(0, tabWidth, 1, 0)
	tabsFrame.Position = UDim2.new(0, 0, 0, 0)
	tabsFrame.BackgroundColor3 = colorTab
	tabsFrame.Parent = container
	Instance.new("UICorner", tabsFrame).CornerRadius = UDim.new(0, 12)

	-- Title label inside tabs area
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.Position = UDim2.new(0, 0, 0, 10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "Tabs"
	titleLabel.TextColor3 = Color3.new(1,1,1)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Parent = tabsFrame

	-- Content area (right side)
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(0, totalWidth - tabWidth, 1, 0)
	contentFrame.Position = UDim2.new(0, tabWidth, 0, 0)
	contentFrame.BackgroundColor3 = colorMain
	contentFrame.Parent = container
	Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 12)

	-- Close button top right inside content area
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseBtn"
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -30, 0, 6)
	closeBtn.BackgroundColor3 = colorClose
	closeBtn.Text = "X"
	closeBtn.TextColor3 = Color3.new(1,1,1)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.Parent = contentFrame
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

	closeBtn.MouseButton1Click:Connect(function()
		container.Visible = false
	end)

	makeDraggable(container)

	return {
		Container = container,
		Tabs = tabsFrame,
		Title = titleLabel,
		Content = contentFrame,
		CloseButton = closeBtn
	}
end

return Nexus
