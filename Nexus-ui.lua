-- NexusUI.lua

local NexusUI = {}

local UIS = game:GetService("UserInputService")
local blue = Color3.fromRGB(0, 115, 255)
local darkBlue = Color3.fromRGB(10, 25, 50)
local darkerBlack = Color3.fromRGB(10, 10, 10)
local TRANSPARENCY = 0.3

function NexusUI:CreateWindow(title)
	local self = {}

	local gui = Instance.new("ScreenGui")
	gui.Name = "NexusUI_" .. (title or "Window")
	gui.ResetOnSpawn = false
	gui.Parent = game.CoreGui

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

	-- Main UI Frame
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 460, 0, 300)
	MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
	MainFrame.BackgroundColor3 = blue
	MainFrame.BackgroundTransparency = TRANSPARENCY
	MainFrame.Name = "MainFrame"
	MainFrame.Active = true
	MainFrame.Draggable = false
	MainFrame.Parent = gui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
	makeDraggable(MainFrame)

	-- Sidebar
	local TabPanel = Instance.new("Frame")
	TabPanel.Size = UDim2.new(0, 80, 1, 0)
	TabPanel.Position = UDim2.new(0, 0, 0, 0)
	TabPanel.BackgroundColor3 = darkerBlack
	TabPanel.BackgroundTransparency = TRANSPARENCY
	TabPanel.Parent = MainFrame
	Instance.new("UICorner", TabPanel).CornerRadius = UDim.new(0, 12)

	local Layout = Instance.new("UIListLayout", TabPanel)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, 4)

	-- Content Panel
	local ContentPanel = Instance.new("Frame")
	ContentPanel.Size = UDim2.new(1, -80, 1, 0)
	ContentPanel.Position = UDim2.new(0, 80, 0, 0)
	ContentPanel.BackgroundColor3 = darkBlue
	ContentPanel.BackgroundTransparency = TRANSPARENCY
	ContentPanel.Parent = MainFrame
	Instance.new("UICorner", ContentPanel).CornerRadius = UDim.new(0, 12)

	-- Close/Open
	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0, 24, 0, 24)
	Close.Position = UDim2.new(1, -28, 0, 4)
	Close.Text = "X"
	Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	Close.BackgroundTransparency = 0.2
	Close.TextColor3 = Color3.new(1, 1, 1)
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 14
	Close.Parent = MainFrame
	Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

	local SmallBtn = Instance.new("TextButton")
	SmallBtn.Size = UDim2.new(0, 100, 0, 30)
	SmallBtn.Position = UDim2.new(0.01, 0, 0.5, -15)
	SmallBtn.Text = "Open UI"
	SmallBtn.BackgroundColor3 = blue
	SmallBtn.BackgroundTransparency = TRANSPARENCY
	SmallBtn.TextColor3 = Color3.new(1, 1, 1)
	SmallBtn.Visible = false
	SmallBtn.Font = Enum.Font.Gotham
	SmallBtn.TextSize = 14
	SmallBtn.Parent = gui
	Instance.new("UICorner", SmallBtn).CornerRadius = UDim.new(0, 10)
	makeDraggable(SmallBtn)

	Close.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
		SmallBtn.Visible = true
	end)

	SmallBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = true
		SmallBtn.Visible = false
	end)

	-- Tab + Button Logic
	self.Tabs = {}

	function self:AddTab(name)
		local tab = {}

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, 0, 0, 30)
		tabBtn.Text = name
		tabBtn.BackgroundTransparency = 0.4
		tabBtn.BackgroundColor3 = darkerBlack
		tabBtn.TextColor3 = Color3.new(1, 1, 1)
		tabBtn.Font = Enum.Font.GothamBold
		tabBtn.TextSize = 13
		tabBtn.Parent = TabPanel

		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = ContentPanel

		tabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(self.Tabs) do
				t.Page.Visible = false
			end
			page.Visible = true
		end)

		local list = Instance.new("UIListLayout", page)
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 5)

		tab.Page = page
		self.Tabs[#self.Tabs + 1] = tab

		return tab
	end

	function self:AddButton(tab, text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Text = text
		btn.BackgroundColor3 = blue
		btn.BackgroundTransparency = TRANSPARENCY
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.Parent = tab.Page
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

		btn.MouseButton1Click:Connect(function()
			pcall(callback)
		end)
	end

	return self
end

return NexusUI
