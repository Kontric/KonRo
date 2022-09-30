ConRO.Rogue = {};
ConRO.Rogue.CheckTalents = function()
end
ConRO.Rogue.CheckPvPTalents = function()
end
local ConRO_Rogue, ids = ...;

function ConRO:EnableRotationModule(mode)
	mode = mode or 0;
	self.ModuleOnEnable = ConRO.Rogue.CheckTalents;
	self.ModuleOnEnable = ConRO.Rogue.CheckPvPTalents;	
	if mode == 0 then
		self.Description = "Rogue [No Specialization Under 10]";
		self.NextSpell = ConRO.Rogue.Under10;
		self.ToggleHealer();
	end;
    if mode == 1 then
	    self.Description = 'Rogue [Assassination]';
		if ConRO.db.profile._Spec_1_Enabled then 
			self.NextSpell = ConRO.Rogue.Assassination;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Rogue.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);		
		end
    end;
    if mode == 2 then
	    self.Description = 'Rogue [Outlaw]';
		if ConRO.db.profile._Spec_2_Enabled then
			self.NextSpell = ConRO.Rogue.Outlaw;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Rogue.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);		
		end
    end;
    if mode == 3 then
	    self.Description = 'Rogue [Sublety]';
		if ConRO.db.profile._Spec_3_Enabled then
			self.NextSpell = ConRO.Rogue.Subtlety;
			self.ToggleDamage();
			ConROWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
			ConRODefenseWindow:SetAlpha(ConRO.db.profile.transparencyWindow);
		else
			self.NextSpell = ConRO.Rogue.Disabled;
			self.ToggleHealer();
			ConROWindow:SetAlpha(0);
			ConRODefenseWindow:SetAlpha(0);		
		end
    end;
	self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	self.lastSpellId = 0;
end

function ConRO:UNIT_SPELLCAST_SUCCEEDED(event, unitID, lineID, spellID)
	if unitID == 'player' then
		self.lastSpellId = spellID;
	end
end

function ConRO.Rogue.Disabled(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
	return nil;
end

function ConRO.Rogue.Under10(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
--Info
	local _Player_Level																					= UnitLevel("player");
	local _Player_Percent_Health 																		= ConRO:PercentHealth('player');
	local _is_PvP																						= ConRO:IsPvP();
	local _in_combat 																					= UnitAffectingCombat('player');
	local _party_size																					= GetNumGroupMembers();
	
	local _is_PC																						= UnitPlayerControlled("target");
	local _is_Enemy 																					= ConRO:TarHostile();
	local _Target_Health 																				= UnitHealth('target');
	local _Target_Percent_Health 																		= ConRO:PercentHealth('target');

--Resources

--Racials
	local _AncestralCall, _AncestralCall_RDY															= ConRO:AbilityReady(ids.Racial.AncestralCall, timeShift);
	local _ArcanePulse, _ArcanePulse_RDY																= ConRO:AbilityReady(ids.Racial.ArcanePulse, timeShift);
	local _Berserking, _Berserking_RDY																	= ConRO:AbilityReady(ids.Racial.Berserking, timeShift);
	local _ArcaneTorrent, _ArcaneTorrent_RDY															= ConRO:AbilityReady(ids.Racial.ArcaneTorrent, timeShift);

--Abilities

--Conditions
	local _enemies_in_melee, _target_in_melee															= ConRO:Targets("Melee");
	local _target_in_10yrds 																			= CheckInteractDistance("target", 3);
	
--Warnings

--Rotations	
	
return nil;
end

function ConRO.Rogue.Assassination(_, timeShift, currentSpell, gcd, tChosen, pvpChosen)
--Info
	local _Player_Level																					= UnitLevel("player");
	local _Player_Percent_Health 																		= ConRO:PercentHealth('player');
	local _is_PvP																						= ConRO:IsPvP();
	local _in_combat 																					= UnitAffectingCombat('player');
	local _party_size																					= GetNumGroupMembers();
	
	local _is_PC																						= UnitPlayerControlled("target");
	local _is_Enemy 																					= ConRO:TarHostile();
	local _Target_Health 																				= UnitHealth('target');
	local _Target_Percent_Health 																		= ConRO:PercentHealth('target');
	
--Resources
	local _Energy, _Energy_Max, _Energy_Percent															= ConRO:PlayerPower('Energy');
	local _Combo, _Combo_Max																			= ConRO:PlayerPower('Combo');

--Racials
	local _ArcaneTorrent, _ArcaneTorrent_RDY															= ConRO:AbilityReady(ids.Racial.ArcaneTorrent, timeShift);
	local _Shadowmeld, _Shadowmeld_RDY																	= ConRO:AbilityReady(ids.Racial.Shadowmeld, timeShift);
	
--Abilities
	local _Ambush, _Ambush_RDY																			= ConRO:AbilityReady(ids.Ass_Ability.Ambush, timeShift);
	local _Envenom, _Envenom_RDY																		= ConRO:AbilityReady(ids.Ass_Ability.Envenom, timeShift);
		local _Envenom_BUFF																					= ConRO:Aura(ids.Ass_Buff.Envenom, timeShift + 1);
	local _FanofKnives, _FanofKnives_RDY 																= ConRO:AbilityReady(ids.Ass_Ability.FanofKnives, timeShift);
		local _HiddenBlades_FORM, _HiddenBlades_COUNT														= ConRO:Form(ids.Ass_Buff.HiddenBlades);
	local _Garrote, _Garrote_RDY 																		= ConRO:AbilityReady(ids.Ass_Ability.Garrote, timeShift);
		local _Garrote_DEBUFF, _, _Garrote_DUR																= ConRO:TargetAura(ids.Ass_Debuff.Garrote, timeShift);
	local _Kick, _Kick_RDY 																				= ConRO:AbilityReady(ids.Ass_Ability.Kick, timeShift);
	local _Mutilate, _Mutilate_RDY 																		= ConRO:AbilityReady(ids.Ass_Ability.Mutilate, timeShift);
	--Poisons
		local _CripplingPoison_BUFF 																		= ConRO:Aura(ids.Ass_Buff.CripplingPoison, timeShift);
		local _DeadlyPoison_BUFF 																			= ConRO:Aura(ids.Ass_Buff.DeadlyPoison, timeShift);
		local _DeadlyPoison_DEBUFF																			= ConRO:TargetAura(ids.Ass_Debuff.DeadlyPoison, timeShift);
		local _InstantPoison_BUFF 																			= ConRO:Aura(ids.Ass_Buff.InstantPoison, timeShift);
		local _WoundPoison_BUFF 																			= ConRO:Aura(ids.Ass_Buff.WoundPoison, timeShift);
	local _PoisonedKnife, _PoisonedKnife_RDY															= ConRO:AbilityReady(ids.Ass_Ability.PoisonedKnife, timeShift);	
	local _Rupture, _Rupture_RDY																		= ConRO:AbilityReady(ids.Ass_Ability.Rupture, timeShift);		
		local _Rupture_DEBUFF, _, _Rupture_DUR																= ConRO:TargetAura(ids.Ass_Debuff.Rupture, timeShift);
	local _Shadowstep, _Shadowstep_RDY																	= ConRO:AbilityReady(ids.Ass_Ability.Shadowstep, timeShift);
		local _, _Shadowstep_RANGE																			= ConRO:Targets(ids.Ass_Ability.Shadowstep);
	local _Shiv, _Shiv_RDY																				= ConRO:AbilityReady(ids.Ass_Ability.Shiv, timeShift);
	local _SliceandDice, _SliceandDice_RDY																= ConRO:AbilityReady(ids.Ass_Ability.SliceandDice, timeShift);
		local _SliceandDice_BUFF, _, _SliceandDice_DUR														= ConRO:Aura(ids.Ass_Buff.SliceandDice, timeShift);
	local _Sprint, _Sprint_RDY 																			= ConRO:AbilityReady(ids.Ass_Ability.Sprint, timeShift);	
	local _Stealth, _Stealth_RDY 																		= ConRO:AbilityReady(ids.Ass_Ability.Stealth, timeShift);
	local _Subterfuge_Stealth, _, _Subterfuge_Stealth_CD												= ConRO:AbilityReady(ids.Ass_Talent.Subterfuge_Stealth, timeShift);
		local _Subterfuge_BUFF																				= ConRO:Aura(ids.Ass_Buff.Subterfuge, timeShift);	
		local _MasterAssassin_BUFF																			= ConRO:Aura(ids.Ass_Buff.MasterAssassin, timeShift);
	local _Vanish, _Vanish_RDY 																			= ConRO:AbilityReady(ids.Ass_Ability.Vanish, timeShift);
		local _Vanish_BUFF																					= ConRO:Aura(ids.Ass_Buff.Vanish, timeShift);
	local _Vendetta, _Vendetta_RDY 																		= ConRO:AbilityReady(ids.Ass_Ability.Vendetta, timeShift);
		local _Vendetta_DEBUFF																				= ConRO:TargetAura(ids.Ass_Debuff.Vendetta, timeShift);

	local _Blindside, _Blindside_RDY																	= ConRO:AbilityReady(ids.Ass_Talent.Blindside, timeShift);	
		local _Blindside_BUFF																				= ConRO:Aura(ids.Ass_Buff.Blindside, timeShift);
	local _Exsanguinate, _Exsanguinate_RDY, _Exsanguinate_CD, _Exsanguinate_MaxCD						= ConRO:AbilityReady(ids.Ass_Talent.Exsanguinate, timeShift);
	local _CrimsonTempest, _CrimsonTempest_RDY															= ConRO:AbilityReady(ids.Ass_Talent.CrimsonTempest, timeShift);
		local _CrimsonTempest_DEBUFF																		= ConRO:TargetAura(ids.Ass_Debuff.CrimsonTempest, timeShift + 2);	
	local _MarkedforDeath, _MarkedforDeath_RDY 															= ConRO:AbilityReady(ids.Ass_Talent.MarkedforDeath, timeShift);
		local _MarkedforDeath_DEBUFF																		= ConRO:TargetAura(ids.Ass_Debuff.MarkedforDeath, timeShift);
	
		local _ElaboratePlanning_BUFF	 																	= ConRO:Aura(ids.Ass_Buff.ElaboratePlanning, timeShift);	

	local _EchoingReprimand, _EchoingReprimand_RDY														= ConRO:AbilityReady(ids.Covenant_Ability.EchoingReprimand, timeShift);
		local _EchoingReprimand_2_BUFF																		= ConRO:Aura(ids.Covenant_Buff.EchoingReprimand_2, timeShift);
		local _EchoingReprimand_3_BUFF																		= ConRO:Aura(ids.Covenant_Buff.EchoingReprimand_3, timeShift);
		local _EchoingReprimand_4_BUFF																		= ConRO:Aura(ids.Covenant_Buff.EchoingReprimand_4, timeShift);
	local _Flagellation, _Flagellation_RDY																= ConRO:AbilityReady(ids.Covenant_Ability.Flagellation, timeShift);
		local _Flagellation_BUFF, _, _Flagellation_DUR														= ConRO:Aura(ids.Covenant_Buff.Flagellation, timeShift);
	local _SerratedBoneSpike, _SerratedBoneSpike_RDY													= ConRO:AbilityReady(ids.Covenant_Ability.SerratedBoneSpike, timeShift);
		local _SerratedBoneSpike_CHARGES, _SerratedBoneSpike_MaxCHARGES, _SerratedBoneSpike_CCD				= ConRO:SpellCharges(ids.Covenant_Ability.SerratedBoneSpike);
		local _SerratedBoneSpike_DEBUFF																		= ConRO:PersistentDebuff(ids.Covenant_Debuff.SerratedBoneSpike);
	local _Sepsis, _Sepsis_RDY																			= ConRO:AbilityReady(ids.Covenant_Ability.Sepsis, timeShift);
	local _Soulshape, _Soulshape_RDY																	= ConRO:AbilityReady(ids.Covenant_Ability.Soulshape, timeShift);

	local _DeathlyShadows_EQUIPPED																		= ConRO:ItemEquipped(ids.Legendary.DeathlyShadows_Legs) or ConRO:ItemEquipped(ids.Legendary.DeathlyShadows_Waist);

--Conditions
	local _is_moving 																					= ConRO:PlayerSpeed();
	local _enemies_in_melee, _target_in_melee															= ConRO:Targets("Melee");
	local _target_in_10yrds 																			= CheckInteractDistance("target", 3);
	
	local _is_stealthed																					= IsStealthed();	
	
		if tChosen[ids.Ass_Talent.Subterfuge] then
			_Stealth_RDY = _Stealth_RDY and _Subterfuge_Stealth_CD <= 0;
			_Stealth = ids.Ass_Talent.Subterfuge_Stealth;
		end
	
	local _Poison_applied = false;
		if _InstantPoison_BUFF then
			_Poison_applied = true;
		elseif _DeadlyPoison_BUFF then
			_Poison_applied = true;
		elseif _WoundPoison_BUFF then
			_Poison_applied = true;
		end

	local EchoingReprimand_COUNT = 0;
		if _EchoingReprimand_2_BUFF then
			EchoingReprimand_COUNT = 2;
		end
		if _EchoingReprimand_3_BUFF then
			EchoingReprimand_COUNT = 3;
		end
		if _EchoingReprimand_4_BUFF then
			EchoingReprimand_COUNT = 4;
		end
		
--Indicators		
	ConRO:AbilityInterrupt(_Kick, _Kick_RDY and ConRO:Interrupt());
	ConRO:AbilityPurge(_ArcaneTorrent, _ArcaneTorrent_RDY and _target_in_melee and ConRO:Purgable());
	ConRO:AbilityMovement(_Shadowstep, _Shadowstep_RDY and _Shadowstep_RANGE and not _target_in_melee);	
	ConRO:AbilityMovement(_Sprint, _Sprint_RDY and not _target_in_melee);	
	ConRO:AbilityMovement(_Soulshape, _Soulshape_RDY and not _target_in_melee);
	
	ConRO:AbilityBurst(_Vendetta, _Vendetta_RDY and _Rupture_DEBUFF and _Garrote_DEBUFF and _Energy <= (_Energy_Max - 30) and ConRO:BurstMode(_Vendetta));
	ConRO:AbilityBurst(_Vanish, _Vanish_RDY and _in_combat and not ConRO:TarYou() and ((_Combo >= _Combo_Max and not _Rupture_DEBUFF and tChosen[ids.Ass_Talent.Subterfuge]) or (tChosen[ids.Ass_Talent.Subterfuge] and not _Garrote_DEBUFF)) and ConRO:BurstMode(_Vanish));
	ConRO:AbilityBurst(_Flagellation, _Flagellation_RDY and ConRO:BurstMode(_Flagellation));
	ConRO:AbilityBurst(_Sepsis, _Sepsis_RDY and _Combo <= _Combo_Max - 1 and ConRO:BurstMode(_Sepsis));
	ConRO:AbilityBurst(_EchoingReprimand, _EchoingReprimand_RDY and _Combo <= _Combo_Max - 2 and ConRO:BurstMode(_EchoingReprimand));
	
--Warnings	
	ConRO:Warnings("Put lethal poison on your weapon!", not _Poison_applied and (_in_combat or _is_stealthed));
		
--Rotations	
	if not _in_combat then	
		if _Stealth_RDY and not _is_stealthed and not _Vanish_BUFF then
			return _Stealth;
		end

--		if _MarkedforDeath_RDY and _Combo < 5 then
--			return _MarkedforDeath;
--		end
		
		if _SliceandDice_RDY and not _SliceandDice_BUFF and _Combo >= 5 then
			return _SliceandDice;
		end
		
		if _Rupture_RDY and not _Rupture_DEBUFF and _Combo >= 5 then
			return _Rupture;
		end

		if _Mutilate_RDY and _Combo <= (_Combo_Max - 1) and tChosen[ids.Ass_Talent.MasterAssassin] then
			return _Mutilate;
		end
		
		if _Garrote_RDY then
			return _Garrote;
		end
	else
		if _PoisonedKnife_RDY and _Energy_Percent >= 90 and _enemies_in_melee == 0 then
			return _PoisonedKnife;
		end

		if _Flagellation_RDY and _Combo >= (_Combo_Max - 1) and ConRO:FullMode(_Flagellation) then
			return _Flagellation;
		end

		if _Sepsis_RDY and _Combo <= (_Combo_Max - 1) and _Rupture_DEBUFF and _Garrote_DEBUFF and not _is_stealthed and ConRO:FullMode(_Sepsis) then
			return _Sepsis;
		end

		if _EchoingReprimand_RDY and _Combo <= _Combo_Max - 2 and ConRO:FullMode(_EchoingReprimand) then
			return _EchoingReprimand;
		end

		if _SerratedBoneSpike_RDY and (not _SerratedBoneSpike_DEBUFF or _SerratedBoneSpike_CHARGES == _SerratedBoneSpike_MaxCHARGES) and _Combo <= _Combo_Max - 2 then
			return _SerratedBoneSpike;
		end
		
--		if _MarkedforDeath_RDY and _Combo == 0 and not _Subterfuge_BUFF and not _MasterAssassin_BUFF then
--			return _MarkedforDeath;
--		end
		
		if _Vendetta_RDY and _Rupture_DEBUFF and _Garrote_DEBUFF and not _is_stealthed and not _Subterfuge_BUFF and not _MasterAssassin_BUFF and ConRO:FullMode(_Vendetta) then
			return _Vendetta;
		end
		
		if _Vanish_RDY and not _is_stealthed and not _Subterfuge_BUFF and not _MasterAssassin_BUFF and not ConRO:TarYou() and ConRO:FullMode(_Vanish) then
			if tChosen[ids.Ass_Talent.Subterfuge] then			
				if tChosen[ids.Ass_Talent.Exsanguinate] then
					if (_Exsanguinate_RDY and _Combo <= _Combo_Max - 1) or not _Garrote_DEBUFF then
						return _Vanish;
					end
				else
					if not _Garrote_DEBUFF or (_Garrote_DEBUFF and _Garrote_DUR <= 6) then
						return _Vanish;
					end
				end
			elseif tChosen[ids.Ass_Talent.Nightstalker] then
				if tChosen[ids.Ass_Talent.Exsanguinate] then
					if not _Rupture_DEBUFF and _Exsanguinate_RDY and _Combo >= _Combo_Max - 1 then
						return _Vanish;
					end
				else
					if (not _Rupture_DEBUFF or (_Rupture_DEBUFF and _Rupture_DUR <= 7)) and _Combo >= _Combo_Max - 1 then
						return _Vanish;
					end
				end	
			else
				if _Rupture_DEBUFF and _Garrote_DEBUFF and _Vendetta_DEBUFF then
					return _Vanish;
				end
			end
		end
		
		if _Shiv_RDY and _Player_Level >= 58 then
			return _Shiv;
		end		
		
		if _Exsanguinate_RDY and not _is_stealthed and not _Subterfuge_BUFF and not _MasterAssassin_BUFF then
			if tChosen[ids.Ass_Talent.DeeperStratagem] then
				if _Rupture_DUR >= 29 and _Garrote_DUR >= 6 then
					return _Exsanguinate;
				end					
			else
				if _Rupture_DUR >= 25 and _Garrote_DUR >= 6 then
					return _Exsanguinate;
				end
			end
		end
		
		if _SliceandDice_RDY and not _SliceandDice_BUFF and _Combo >= 3 then
			return _SliceandDice;
		end		

		if _Envenom_RDY and (_Combo >= (_Combo_Max - 1) or _Combo == EchoingReprimand_COUNT) and (_Player_Level >= 56 and _SliceandDice_BUFF and _SliceandDice_DUR <= 2) then
			return _Envenom;
		end
		
		if _Rupture_RDY and (_Combo >= (_Combo_Max - 1) or _Combo == EchoingReprimand_COUNT) and _Exsanguinate_RDY then	
			return _Rupture;
		end

		if _Garrote_RDY and (not _Garrote_DEBUFF or (_Garrote_DEBUFF and _Garrote_DUR <= 3)) and not _MasterAssassin_BUFF then
			return _Garrote;
		end

		if _CrimsonTempest_RDY and not _CrimsonTempest_DEBUFF and (_Combo >= (_Combo_Max - 1) or _Combo == EchoingReprimand_COUNT) and ((ConRO_AutoButton:IsVisible() and _enemies_in_melee >= 2) or ConRO_AoEButton:IsVisible()) then
			return _CrimsonTempest;
		end
		
		if _Rupture_RDY and (_Combo >= (_Combo_Max - 1) or _Combo == EchoingReprimand_COUNT) and (not _Rupture_DEBUFF or (_Rupture_DEBUFF and _Rupture_DUR <= 7)) then	
			return _Rupture;
		end
	
		if _Envenom_RDY and (_Combo >= (_Combo_Max - 1) or _Combo == EchoingReprimand_COUNT) and not ebuff then
			return _Envenom;
		end

		if _FanofKnives_RDY and _Combo <= (_Combo_Max - 1) and ((ConRO_AutoButton:IsVisible() and _enemies_in_melee >= 3) or ConRO_AoEButton:IsVisible() or _HiddenBlades_COUNT >= 20) then
			return _FanofKnives;
		end

		if _Ambush_RDY and _Combo <= (_Combo_Max - 1) and _Blindside_BUFF then
			return _Ambush;
		end
		
		if _Mutilate_RDY and _Combo <= (_Combo_Max - 1) and ((ConRO_AutoButton:IsVisible() and _enemies_in_melee <= 2) or ConRO_SingleButton:IsVisible()) then
			return _Mutilate;
		end
	end
return nil;
end