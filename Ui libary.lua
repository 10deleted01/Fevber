local UI = {}
UI.__index = UI

-- Utility function for creating new objects
local function new(class, ...)
    local obj = setmetatable({}, class)
    obj:init(...)
    return obj
end

-- Create the base Window class
UI.Window = {}
UI.Window.__index = UI.Window

function UI.Window:init(title, width, height)
    self.title = title
    self.width = width or 400
    self.height = height or 300
    self.visible = true
    self.uiElements = {}
    self.createWindow()
    self.padding = 10  -- Space between elements
end

function UI.Window:createWindow()
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, self.width, 0, self.height)
    window.Position = UDim2.new(0.5, -self.width / 2, 0.5, -self.height / 2)
    window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    window.BorderSizePixel = 0
    window.Name = self.title

    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleBar.Text = self.title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.TextSize = 18
    titleBar.Parent = window

    window.Parent = game.CoreGui
    self.window = window
end

function UI.Window:addElement(element)
    table.insert(self.uiElements, element)
    self:updatePositions()
end

function UI.Window:updatePositions()
    local currentY = 30  -- Start below the title bar
    for _, element in ipairs(self.uiElements) do
        element:setPosition(10, currentY)
        currentY = currentY + element:getSize().Y.Offset + self.padding
    end
end

function UI.Window:toggleVisibility()
    self.visible = not self.visible
    self.window.Visible = self.visible
end

-- Create the Button class
UI.Button = {}
UI.Button.__index = UI.Button

function UI.Button:init(label, onClick)
    self.label = label
    self.onClick = onClick
    self:createButton()
end

function UI.Button:createButton()
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Text = self.label
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.TextSize = 20
    button.MouseButton1Click:Connect(self.onClick)

    button.Parent = game.CoreGui
    self.button = button
end

function UI.Button:setPosition(x, y)
    self.button.Position = UDim2.new(0, x, 0, y)
end

function UI.Button:getSize()
    return self.button.Size
end

-- Create the Slider class
UI.Slider = {}
UI.Slider.__index = UI.Slider

function UI.Slider:init(min, max, default, onChange)
    self.min = min
    self.max = max
    self.value = default
    self.onChange = onChange
    self:createSlider()
end

function UI.Slider:createSlider()
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 200, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 10, 0, 30)
    handle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    handle.Position = UDim2.new(0, 0, 0, 0)
    handle.Parent = slider

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            local newValue = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1) * (self.max - self.min) + self.min
            self.value = newValue
            self.onChange(self.value)
            handle.Position = UDim2.new(0, (newValue - self.min) / (self.max - self.min) * sliderSize, 0, 0)
        end
    end)

    slider.Parent = game.CoreGui
    self.slider = slider
end

function UI.Slider:setPosition(x, y)
    self.slider.Position = UDim2.new(0, x, 0, y)
end

function UI.Slider:getSize()
    return self.slider.Size
end

function UI.Slider:getValue()
    return self.value
end

-- Example usage
local window = new(UI.Window, "Test Window", 400, 300)
local button = new(UI.Button, "Click Me", function() print("Button Clicked!") end)
window:addElement(button)
local slider = new(UI.Slider, 0, 100, 50, function(val) print("Slider Value: " .. val) end)
window:addElement(slider)

return UI
