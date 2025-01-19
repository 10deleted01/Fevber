local library = {}
local windowCount = 0
local windowOffset = 20
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

if game.CoreGui:FindFirstChild("Advanced UI Library") then
    game.CoreGui:FindFirstChild("Advanced UI Library"):Destroy()
end

local function protectGui(obj)
    if syn and syn.protect_gui then
        syn.protect_gui(obj)
    end
    obj.Parent = game.CoreGui
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "Advanced UI Library"
protectGui(mainGui)

local function tween(object, properties, duration)
    game:GetService("TweenService"):Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function createUICorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = object
end

local function createUIGradient(object, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(color1, color2)
    gradient.Rotation = 90
    gradient.Parent = object
end

local function showLoadingScreen(creditsText, displayTime)
    local loadingScreen = Instance.new("Frame")
    loadingScreen.Size = UDim2.new(1, 0, 1, 0)
    loadingScreen.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    loadingScreen.Parent = mainGui

    createUIGradient(
        loadingScreen,
        Color3.fromRGB(45, 45, 45),
        Color3.fromRGB(20, 20, 20)
    )

    local creditLabel = Instance.new("TextLabel")
    creditLabel.Text = creditsText or "Powered by Advanced UI Library"
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.TextSize = 24
    creditLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
    creditLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
    creditLabel.Parent = loadingScreen

    -- Tween to fade out and remove the loading screen
    task.delay(displayTime or 3, function()
        tween(loadingScreen, {BackgroundTransparency = 1}, 1)
        tween(creditLabel, {TextTransparency = 1}, 1)
        task.wait(1)
        loadingScreen:Destroy()
    end)
end

-- Call the loading screen on initialization
showLoadingScreen("Welcome to Fevber Hub", 3)

-- Functionality for creating windows
function library:CreateWindow(title)
    windowCount += 1

    local window = Instance.new("Frame")
    window.Name = "Window" .. windowCount
    window.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    window.Size = UDim2.new(0, 350, 0, 40)
    window.Position = UDim2.new(0, windowOffset, 0, 20)
    window.Parent = mainGui
    createUICorner(window, 16)
    createUIGradient(window, Color3.fromRGB(45, 45, 45), Color3.fromRGB(30, 30, 30))
    windowOffset += 370

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    header.Parent = window
    createUICorner(header, 16)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "Window"
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(0.7, -40, 1, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Parent = header

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 22
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    minimizeButton.Size = UDim2.new(0, 40, 0, 40)
    minimizeButton.Position = UDim2.new(1, -50, 0, 0)
    minimizeButton.Parent = header
    createUICorner(minimizeButton, 12)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    content.Parent = window
    createUICorner(content, 16)
    createUIGradient(content, Color3.fromRGB(50, 50, 50), Color3.fromRGB(35, 35, 35))
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 10

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 12)
    layout.Parent = content

    minimizeButton.MouseButton1Click:Connect(function()
        content.Visible = not content.Visible
        minimizeButton.Text = content.Visible and "-" or "+"
        tween(window, {Size = content.Visible and UDim2.new(0, 350, 0, 300) or UDim2.new(0, 350, 0, 40)}, 0.2)
    end)

    local windowFunctions = {}

    function windowFunctions:AddButton(buttonText, callback)
        local button = Instance.new("TextButton")
        button.Text = buttonText or "Button"
        button.Size = UDim2.new(1, -20, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
        button.Font = Enum.Font.Gotham
        button.TextSize = 18
        button.TextColor3 = Color3.fromRGB(240, 240, 240)
        button.Parent = content
        createUICorner(button, 12)
        createUIGradient(button, Color3.fromRGB(80, 80, 80), Color3.fromRGB(50, 50, 50))

        button.MouseButton1Click:Connect(callback or function() end)

        button.MouseEnter:Connect(function()
            tween(button, {BackgroundColor3 = Color3.fromRGB(85, 85, 85)}, 0.1)
        end)

        button.MouseLeave:Connect(function()
            tween(button, {BackgroundColor3 = Color3.fromRGB(66, 66, 66)}, 0.1)
        end)
    end

