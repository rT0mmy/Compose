<div align="center">
	<h1 style="color:blue;text-align:center">Compose</h1>
	<p> Composition decorator pattern API </p>
  
  ![Luau](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
  <br><br>
  
  <img src="https://img.shields.io/github/forks/rT0mmy/Compose?style=for-the-badge">
  <img src="https://img.shields.io/github/stars/rT0mmy/Compose?style=for-the-badge">
  <img src="https://img.shields.io/github/issues/rT0mmy/Compose?style=for-the-badge">
  <img src="https://img.shields.io/github/issues-pr/rT0mmy/Compose?style=for-the-badge">
  <img src="https://img.shields.io/github/license/rT0mmy/Compose?style=for-the-badge">
</div>

<br><br><br><br>

## What is a decorator?
A decorator lets you add new features or 'decorations' to x without changing what it is at its core.

## API

```lua
local Compose = require(...)
```

<br><br>

> Creating a new ```Composition<T>```
```lua
Compose(T) -> Composition<T>
```
```lua
local ExampleNumericalComposition = Composition(24.0)
```
<br><br>
> Setting the base value of type ```T``` of a  ```Composition<T>```
```lua
Composition:SetValue(T) -> nil
```
```lua
ExampleNumericalComposition:SetValue(64.0)
```
<br><br>
> Getting the base value of type ```T``` of a  ```Composition<T>```
```lua
Composition:GetValue(T) -> T
```
```lua
local BaseValue = ExampleNumericalComposition:GetValue()
```
<br><br>
> Appending a modifier function ```(T)->T``` to a ```Composition<T>```
```lua
Composition:Modifier(f:(a0: T)->T) -> nil
```
```lua
ExampleNumericalComposition:Modifier(function(a0: number): number
	return a0 * 2.0
end)
```
<br><br>
> Getting the fully composed value ```T``` of a ```Composition<T>```
```lua
Composition:Get() -> T
```
```lua
local Mult = ExampleNumericalComposition:Get() -- 64 * 2.0 = 128
```

<br><br><br>

## API Examples

```lua
--!strict
--!native
--!optimize 2

local Compose = require(script.Parent:WaitForChild("Compose"))
local Camera = workspace.CurrentCamera

local BASE_FOV = 60.0
local ZOOM_FOV_MULT = 0.5
local BOOST_FOV_MULT = 1.2
local FOV_ALPHA = 0.5

local CameraFOVComposition = Compose(BASE_FOV)

local Boost = false
local function onBoost(fov: number)
	return fov * (Boost and BOOST_FOV_MULT or 1)
end

local Zoom = false
local function onZoom(fov: number)
	return fov * (Zoom and ZOOM_FOV_MULT or 1)
end

CameraFOVComposition:Modifier(onBoost)
CameraFOVComposition:Modifier(onZoom)
CameraFOVComposition:Modifier(function(fov: number): number  
	return fov + (math.sin(tick()) * 0.5 + 0.5) * 8
end)

game:GetService("UserInputService").InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)  
	if gameProcessedEvent then
		return
	end
	
	if input.KeyCode == Enum.KeyCode.Z then
		Zoom = true
	end
	
	if input.KeyCode == Enum.KeyCode.X then
		Boost = true
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)  
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.Z then
		Zoom = false
	end
	
	if input.KeyCode == Enum.KeyCode.X then
		Boost = false
	end 
end)

game:GetService("RunService").RenderStepped:Connect(function(deltaTime: number)  
	local FieldOfView = CameraFOVComposition:Get()
	Camera.FieldOfView = Camera.FieldOfView + (FieldOfView - Camera.FieldOfView) * FOV_ALPHA
end)
```

<br>

```lua
--!strict
--!native
--!optimize 2

local Compose = require(script.Parent:WaitForChild("Compose"))

local BASE_STRING = "Hello World!"
local MODIFIERS = {
	"Cheeseburger!!!",
	"Taco!!!",
	"Cookies??!",
	"Cakes!"
}

local Modifier = MODIFIERS[1]

local StringComposition = Compose("Hello world!")
StringComposition:Modifier(function(a0: string): string  
	return `{a0} {Modifier}`
end)

while task.wait(1.0) do
	Modifier = MODIFIERS[math.random(#MODIFIERS)]
	warn(StringComposition:Get())
end
```


