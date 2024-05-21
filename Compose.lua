--!strict
--!native
--!optimize 2

--[=[
	Returns a function that calls the argument functions in left-right order on an input, passing
	the return of the previous function as argument(s) to the next.
		
	@example
		local function fry(item)
			return "fried " .. item
		end
		
		local function cheesify(item)
			return "cheesy " .. item
		end

		local prepare = compose(fry, cheesify)
		prepare("nachos") --> "cheesy fried nachos"
]=]

export type CompositionFunction<T> = (T)->T
type CompositionFunctions<T> = {[number]: CompositionFunction<T>}

export type Composition<T> = {
    Value: T,
    Modifiers: CompositionFunctions<T>
}

local Compose = {}

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

function Compose.SetValue<T>(self: Composition<T>, value: T)
	self.Value = value
end

function Compose.GetValue<T>(self: Composition<T>)
	return self.Value
end

--: <T>((...T -> ...T)[]) -> ...T -> T
function Compose.Modifier<T>(self: Composition<T>, f: CompositionFunction<T>)
	table.insert(self.Modifiers, f)
end

function Compose.Get<T>(self: Composition<T>)
    local v = self.Value

    for i, modifier in ipairs(self.Modifiers) do
        v = modifier(v)
    end

    return v
end

return Compose.new