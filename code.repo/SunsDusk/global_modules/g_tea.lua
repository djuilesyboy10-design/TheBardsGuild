-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ Tea Refilling                                                            │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Teacup IDs that can be filled with tea
local teacupIds = {
	["misc_com_redware_cup"] = true,
	["misc_de_pot_redware_03"] = true,
	["ab_misc_deceramiccup_01"] = true,
	["ab_misc_deceramiccup_02"] = true,
	["ab_misc_deceramicflask_01"] = true,
}

-- Consume one ingredient from player inventory
local function teaConsumeIngredient(data)
	local player = data[1]
	local ingredientId = data[2]
	local inv = types.Actor.inventory(player)
	
	for _, item in ipairs(inv:getAll(types.Ingredient)) do
		if item:isValid() and item.count > 0 then
			local rec = types.Ingredient.record(item)
			if rec.id:lower() == ingredientId:lower() then
				item:remove(1)
				log(3, "[Tea] Consumed 1x " .. ingredientId)
				return
			end
		end
	end
end

-- Refill teacups with tea
local function teaRefillTeacups(data)
	local player = data[1]
	local teaType = data[2]
	local inv = types.Actor.inventory(player)
	local Misc = types.Miscellaneous
	local Potion = types.Potion
	
	local replaced = 0
	
	-- Refill empty teacups (Miscellaneous items)
	for _, item in ipairs(inv:getAll(Misc)) do
		if item:isValid() and item.count > 0 then
			local rec = Misc.record(item)
			local origId = lc(rec.id)
			
			if teacupIds[origId] then
				local fullId = ensurePotionFor(origId, resolveMaxQ(origId), teaType)
				
				if fullId then
					local count = item.count
					item:remove()
					world.createObject(fullId, count):moveInto(inv)
					replaced = replaced + count
				end
			end
		end
	end
	
	-- Refill partially filled teacups (Potions)
	for _, item in ipairs(inv:getAll(Potion)) do
		if item:isValid() and item.count > 0 then
			local rev = saveData.reverse[item.recordId:lower()]
			if rev and teacupIds[lc(rev.orig)] then
				local origId = lc(rev.orig)
				local maxQ = resolveMaxQ(origId)
				local fullId = ensurePotionFor(origId, maxQ, teaType)
				
				if maxQ and rev.q < maxQ and fullId then
					local count = item.count
					item:remove()
					world.createObject(fullId, count):moveInto(inv)
					replaced = replaced + count
				end
			end
		end
	end
	
	player:sendEvent("SunsDusk_Tea_teacupsRefilled", {replaced = replaced, teaType = teaType})
end

G_eventHandlers.SunsDusk_Tea_consumeIngredient				= teaConsumeIngredient
G_eventHandlers.SunsDusk_Tea_refillTeacups					= teaRefillTeacups