realtest.registered_fuels = {}
realtest.registered_cooking = {}
function realtest.register_fuel(FuelRef)
	if FuelRef.input and FuelRef.output then
		local fuel = {
			input = FuelRef.input,
			output = FuelRef.output,
			time = FuelRef.time or 10,
			max_temp = FuelRef.max_temp or 100,
			used_in_furnace = FuelRef.used_in_furnace or true,
			used_in_bonfire = FuelRef.used_in_bonfire or true,
		}
		realtest.registered_fuels[fuel.input] = fuel
	end
end
function realtest.register_cooking(CookingRef)
	if CookingRef.input and CookingRef.output then
		local cooking = {
			input = CookingRef.input,
			output = CookingRef.output,
			time = CookingRef.time or 10,
			temperature = CookingRef.temperature or 100,
		}
		realtest.registered_cooking[cooking.input] = cooking 
	end
end