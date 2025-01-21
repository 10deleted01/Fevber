local library = {}
local windowCount = 0
local sizes = {}
local listOffset = {}
local windows = {}
local pastSliders = {}
local dropdowns = {}
local dropdownSizes = {}
local destroyed
local colorPickers = {}

-- Ensure the library is clean before initializing
if game.CoreGui:FindFirstChild('TurtleUiLib') then
    game.CoreGui:FindFirstChild('TurtleUiLib'):Destroy()
    destroyed = true
end

-- Utility function for smooth transitions
local function Lerp(a, b, c)
    return a + ((b - a) * c)
end

local players = game:service('Players')
local player = players.LocalPlayer
local mouse = player:GetMouse()
local run = game:service('RunService')
local stepped = run.Stepped

-- Drag functionality for GUI elements
local function Dragify(obj)
    spawn(function()
        local initialPos
        local isDragging
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                initialPos = input.Position
                local con
                con = stepped:Connect(function()
                    if isDragging then
                        local delta = Vector3.new(mouse.X, mouse.Y, 0) - initialPos
                        obj.Position = UDim2.new(obj.Position.X.Scale, obj.Position.X.Offset + delta.X, obj.Position.Y.Scale, obj.Position.Y.Offset + delta.Y)
                    else
                        con:Disconnect()
                    end
                end)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)
    end)
end

-- Protect GUI based on execution environment
local function protect_gui(obj)
    if destroyed then
        obj.Parent = game.CoreGui
        return
    end
    if syn and syn.protect_gui then
        syn.protect_gui(obj)
    elseif PROTOSMASHER_LOADED then
        obj.Parent = get_hidden_gui()
    else
        obj.Parent = game.CoreGui
    end
end

-- Main GUI Library creation
local TurtleUiLib = Instance.new("ScreenGui")
TurtleUiLib.Name = "TurtleUiLib"
protect_gui(TurtleUiLib)

local xOffset = 20
local uis = game:GetService("UserInputService")
local keybindConnection

function library:Destroy()
    TurtleUiLib:Destroy()
    if keybindConnection then
        keybindConnection:Disconnect()
    end
end

function library:Hide()
    TurtleUiLib.Enabled = not TurtleUiLib.Enabled
end

function library:Keybind(key)
    if keybindConnection then keybindConnection:Disconnect() end
    keybindConnection = uis.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == Enum.KeyCode[key] then
            TurtleUiLib.Enabled = not TurtleUiLib.Enabled
        end
    end)
end

-- Window creation function
function library:Window(name)
    windowCount = windowCount + 1
    local winCount = windowCount
    local zindex = winCount * 7
    local UiWindow = Instance.new("Frame")

    UiWindow.Name = "UiWindow"
    UiWindow.Parent = TurtleUiLib
    UiWindow.BackgroundColor3 = Color3.fromRGB(0, 151, 230)
    UiWindow.BorderColor3 = Color3.fromRGB(0, 151, 230)
    UiWindow.Position = UDim2.new(0, xOffset, 0, 20)
    UiWindow.Size = UDim2.new(0, 207, 0, 33)
    UiWindow.ZIndex = 4 + zindex
    UiWindow.Active = true
    Dragify(UiWindow)

    xOffset = xOffset + 230

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = UiWindow
    Header.BackgroundColor3 = Color3.fromRGB(0, 168, 255)
    Header.BorderColor3 = Color3.fromRGB(0, 168, 255)
    Header.Position = UDim2.new(0, 0, -0.0202544238, 0)
    Header.Size = UDim2.new(0, 207, 0, 26)
    Header.ZIndex = 5 + zindex

    local HeaderText = Instance.new("TextLabel")
    HeaderText.Name = "HeaderText"
    HeaderText.Parent = Header
    HeaderText.BackgroundTransparency = 1.000
    HeaderText.Size = UDim2.new(0, 206, 0, 33)
    HeaderText.ZIndex = 6 + zindex
    HeaderText.Font = Enum.Font.SourceSans
    HeaderText.Text = name or "Window"
    HeaderText.TextColor3 = Color3.fromRGB(47, 54, 64)
    HeaderText.TextSize = 17.000

    -- Minimize Button Logic
    local Minimise = Instance.new("TextButton")
    Minimise.Name = "Minimise"
    Minimise.Parent = Header
    Minimise.BackgroundColor3 = Color3.fromRGB(0, 168, 255)
    Minimise.BorderColor3 = Color3.fromRGB(0, 168, 255)
    Minimise.Position = UDim2.new(0, 185, 0, 2)
    Minimise.Size = UDim2.new(0, 22, 0, 22)
    Minimise.ZIndex = 7 + zindex
    Minimise.Font = Enum.Font.SourceSansLight
    Minimise.Text = "_"
    Minimise.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimise.TextSize = 20.000
    Minimise.MouseButton1Up:connect(function()
        Window.Visible = not Window.Visible
        Minimise.Text = Window.Visible and "_" or "+"
    end)

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Parent = Header
    Window.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
    Window.BorderColor3 = Color3.fromRGB(47, 54, 64)
    Window.Position = UDim2.new(0, 0, 0, 0)
    Window.Size = UDim2.new(0, 207, 0, 33)
    Window.ZIndex = 1 + zindex

    local functions = {}
    functions.__index = functions
    functions.Ui = UiWindow

    sizes[winCount] = 33
    listOffset[winCount] = 10

    -- Destroy Window
    function functions:Destroy()
        self.Ui:Destroy()
    end

    -- Button Creation
    function functions:Button(name, callback)
        local callback = callback or function() end
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)

        local Button = Instance.new("TextButton")
        listOffset[winCount] = listOffset[winCount] + 32
        Button.Name = "Button"
        Button.Parent = Window
        Button.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
        Button.BorderColor3 = Color3.fromRGB(113, 128, 147)
        Button.Position = UDim2.new(0, 12, 0, listOffset[winCount])
        Button.Size = UDim2.new(0, 182, 0, 26)
        Button.ZIndex = 2 + zindex
        Button.Selected = true
        Button.Font = Enum.Font.SourceSans
        Button.TextColor3 = Color3.fromRGB(245, 246, 250)
        Button.TextSize = 16.000
        Button.TextStrokeTransparency = 123.000
        Button.TextWrapped = true
        Button.Text = name
        Button.MouseButton1Down:Connect(callback)

        pastSliders[winCount] = false
    end

    -- Label Creation
    function functions:Label(text, color)
        local color = color or Color3.fromRGB(220, 221, 225)
        sizes[winCount] = sizes[winCount] + 32
        Window.Size = UDim2.new(0, 207, 0, sizes[winCount] + 10)
        listOffset[winCount] = listOffset[winCount] + 32

        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = Window
        Label.BackgroundColor3 = Color3.fromRGB(220, 221, 225)
        Label.BackgroundTransparency = 1.000
        Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
        Label.Position = UDim2.new(0, 0, 0, listOffset[winCount])
        Label.Size = UDim2.new(0, 206, 0, 29)
        Label.Font = Enum.Font.SourceSans
        Label.Text = text or "Label"
        Label.TextSize = 16.000
        Label.ZIndex = 2 + zindex

        if type(color) == "boolean" and color then
            spawn(function()
                while wait() do
                    local hue = tick() % 5 / 5
                    Label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end)
        else
            Label.TextColor3 = color
        end
        pastSliders[winCount] = false
        return Label
    end

    -- Return the library functions for this window
    return functions
end

return library
