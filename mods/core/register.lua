realtest.registered_fuels = {}
realtest.registered_cooking = {}
function realtest.register_fuel(FuelRef)
	if FuelRef.input and FuelRef.output then
		local fuel = {
			input = FuelRef.input,
			total_heat = FuelRef.total_heat or 100,
			burn_time = FuelRef.burn_time or 10,
			max_temp = FuelRef.max_temp or 100,
		}
		if FuelRef.used_in_furnace == nil then
			fuel.used_in_furnace = false
		else
			fuel.used_in_furnace = FuelRef.used_in_furnace
		end
		if FuelRef.used_in_bonfire == nil then
			fuel.used_in_bonfire = false
		else
			fuel.used_in_bonfire = FuelRef.used_in_bonfire
		end
		realtest.registered_fuels[fuel.input] = fuel
	end
end
function realtest.register_cooking(CookingRef)
	if CookingRef.input and CookingRef.output then
		local cooking = {
			input = CookingRef.input,
			output = CookingRef.output,
			specific_heat = CookingRef.specific_heat or 10,
			melting_point = CookingRef.melting_point or 100,
		}
		realtest.registered_cooking[cooking.input] = cooking 
	end
end