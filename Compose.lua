--!strict
--!native
--!optimize 2

--[=[
    A simple API for decorator pattern composition

    @examples - Can be found on the github repo, in examples section
    https://github.com/rT0mmy/Compose

    @class Composition<T>
]=]

export type CompositionFunction<T> = (T)->T
type CompositionFunctions<T> = {[number]: CompositionFunction<T>}

export type Composition<T> = {
	Value: T,
	Modifiers: CompositionFunctions<T>,
	
	SetValue: (self: Composition<T>, value: T)->(),
	GetValue: (self: Composition<T>)->T,
	
	Get: (self: Composition<T>)->T,
	
	Modifier: (self: Composition<T>, f:CompositionFunction<T>)->(),
}

local Compose = {}

--[=[
    Creates a new composition

    @param value any
    @return Composition<T>
]=]
Compose.new = function<T>(value: T): Composition<T>
	return {
		Value = value,
		Modifiers = {},

		SetValue = Compose.SetValue,
		GetValue = Compose.GetValue,

		Get = Compose.Get,

		Modifier = Compose.Modifier,
	}
end

--[=[
    Sets the base value to @value

    @param value any
    @return void
]=]
function Compose.SetValue<T>(self: Composition<T>, value: T)
	self.Value = value
end

--[=[
    Returns the value of type <T>

    @return T
]=]
function Compose.GetValue<T>(self: Composition<T>): T
	return self.Value
end

--[=[
    Adds a modifier to the composition modifier array

    @param f (T)->T
    @return void
]=]
--: <T>((...T -> ...T)[]) -> ...T -> T -- ???
function Compose.Modifier<T>(self: Composition<T>, f: CompositionFunction<T>)
	table.insert(self.Modifiers, f)
end

--[=[
    Returns the composed value

    @return T
]=]
function Compose.Get<T>(self: Composition<T>): T
	local v = self.Value

	for i, modifier in ipairs(self.Modifiers) do
		v = modifier(v)
	end

	return v
end

return Compose.new
