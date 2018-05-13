function OnMiko01SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)

	local effectIndex = ParticleManager:CreateParticle("particles/thd2/heroes/miko/ability_miko_01.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(effectIndex, 0, caster:GetOrigin()+Vector(0,0,64))
	ParticleManager:SetParticleControlForward(effectIndex , 0, caster:GetForwardVector())
	ParticleManager:DestroyParticleSystem(effectIndex,false)
	
	keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_miko_01_pose", {Duration = 1.5})
end

function OnMiko02SpellStart(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local target = keys.target

	if target:THTD_IsTower() and IsTempleOfGodTower(target) then
		if caster.thtd_miko_02_religious_count == nil then
			caster.thtd_miko_02_religious_count = 0
		end

		if caster.thtd_miko_02_religious_count >= 6000 then
			caster:RemoveModifierByName("modifier_miko_02_buff")
			keys.ability:ApplyDataDrivenModifier(caster, target, "modifier_miko_02_buff", {})
			caster.thtd_miko_02_religious_count = 0
		end
	end
end

function OnMiko02SpellThink(keys)
	local caster = EntIndexToHScript(keys.caster_entindex)
	local targets = THTD_FindFriendlyUnitsInRadius(caster,caster:GetOrigin(),1500)

	for k,v in pairs(targets) do
		if IsTempleOfGodTower(v) then
			if caster.thtd_miko_02_religious_count == nil then
				caster.thtd_miko_02_religious_count = 0
			end
			if caster.thtd_miko_02_religious_count < 6000 then
				caster.thtd_miko_02_religious_count = caster.thtd_miko_02_religious_count + 1
				SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, caster.thtd_miko_02_religious_count, caster:GetPlayerOwner() )
			else
				keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_miko_02_buff", {})
			end
		end
	end
end