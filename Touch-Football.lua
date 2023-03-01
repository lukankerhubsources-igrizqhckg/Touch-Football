-- Made by lukanker
-- v1.5

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Touch Football", "DarkTheme")
local CharacterTab = Window:NewTab("Character")
local CharacterSection = CharacterTab:NewSection("Change Hitbox")
local VisualTab = Window:NewTab("Visual")
local VisualMainSection = VisualTab:NewSection("Main")
local VisualSection = VisualTab:NewSection("Hitbox")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Hrp = Character:WaitForChild('HumanoidRootPart')

local Hitbox = Character:FindFirstChild('Hitbox')
local HitboxSize = nil

local Script = Character.BallHandler
local senv = getsenv(Script)

local touchDetect = senv.touchDetect

getgenv().VisualToggle = false

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
	Script = Character:WaitForChild('BallHandler')
	senv = getsenv(Script)
	touchDetect = senv.touchDetect
	if HitboxSize then
	        setconstant(touchDetect, 9, HitboxSize / 2)
	        createVisual(HitboxSize, Character)
	end
end)

Character.Humanoid.Died:Connect(function()
    Hitbox:Destroy()
    Hitbox = nil
end)

function createVisual(size, Character)
    Hrp = Character:WaitForChild('HumanoidRootPart')
    if not Hitbox then Hitbox = Instance.new('Part') end
    Hitbox.Shape = Enum.PartType.Cylinder
    Hitbox.Parent = Character
    Hitbox.Name = 'Hitbox'
    Hitbox.Size = Vector3.new(5,size,size)
    Hitbox.Position = Hrp.Position
    Hitbox.CanCollide = false
    Hitbox.Massless = true
    if getgenv().VisualToggle then
        Hitbox.Transparency = 0.8
    else
        Hitbox.Transparency = 1
    end
    Hitbox.Material = Enum.Material.Neon

    local Weld = Instance.new('Weld')
    Weld.Parent = Character
    Weld.Part0 = Hrp
    Weld.Part1 = Hitbox
    
    Hitbox.Orientation = Vector3.new(0, 0, 90)
    print('CREATED HITBOX')
end

CharacterSection:NewTextBox("Size", "Size in studs", function(txt)
    HitboxSize = tonumber(txt)
    setconstant(touchDetect, 9, HitboxSize / 2)
    createVisual(HitboxSize, Character)
end)

VisualSection:NewToggle("Show", "Toggle visual of hitbox", function(state)
    getgenv().VisualToggle = state
    if state and Hitbox then
        Hitbox.Transparency = 0.8
    else
        Hitbox.Transparency = 1
    end
end)

VisualMainSection:NewKeybind("Toggle Show", "Toggle the visibility of the GUI", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
