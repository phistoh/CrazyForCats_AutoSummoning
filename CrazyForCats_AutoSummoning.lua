local addonName, phis = ...

local disabled = false

local f = CreateFrame('Frame', 'phisCheckFrame', UIParent)
f:RegisterEvent('PLAYER_STARTED_MOVING')
f:RegisterEvent('UNIT_EXITED_VEHICLE')
f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('ZONE_CHANGED')
f:RegisterEvent('ZONE_CHANGED_INDOORS')
f:RegisterEvent('ZONE_CHANGED_NEW_AREA')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('PLAYER_UPDATE_RESTING')
f:RegisterEvent('PLAYER_ALIVE')
f:RegisterEvent('PLAYER_UNGHOST')

local function addonPrint(str)
	print('|cFFABD473'..addonName..':|r '..str)
end

f:SetScript('OnEvent', function(self, event)
	-- the addon is disabled
	if disabled then
		return
	-- don't overwrite the already summoned pet
	elseif C_PetJournal.GetSummonedPetGUID() ~= nil then
		return
	-- cannot summon a pet in combat
	elseif UnitAffectingCombat('player') then
		return
	-- don't interfere with grouped content
	elseif IsInInstance() then
		return
	-- don't waste global cooldown so emergency actions (flight form, glider, ...) are possible
	elseif IsFalling() then
		return
	-- summoning a pet removes stealth
	elseif IsStealthed() then
		return
	-- don't possibly dismount the player in the air
	elseif IsFlying() then
		return
	-- cannot summon a pet in pet battle
	elseif C_PetBattles.IsInBattle() then
		return
	-- cannot summon a pet on gryphon service
	elseif UnitOnTaxi('player') then
		return
	-- cannot summon a pet in vehicles
	elseif UnitInVehicle('player') then
		return
	-- needs CrazyForCats
	else
		CrazyForCatsGlobals.summonRandom()
	end
end)

-------------------------
--    SLASH COMMANDS   --
-------------------------

SLASH_CFCAUTO1 = '/crazyforcatsauto'
SLASH_CFCAUTO2 = '/cfcauto'

SlashCmdList['CFCAUTO'] = function(msg)
	disabled = not disabled
	addonPrint('Auto summoning now '..(disabled and 'disabled' or 'enabled')..'.')
end