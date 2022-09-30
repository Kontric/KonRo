ConRO.Spells = {};
ConRO.Keybinds = {};
ConRO.Flags = {};
ConRO.SpellsGlowing = {};
ConRO.DamageFramePool = {};
ConRO.DamageFrames = {};
ConRO.CoolDownFramePool = {};
ConRO.CoolDownFrames = {};

local defaults = {
	["ConRO_Settings_Full"] = true,
	["ConRO_Settings_Burst"] = false,
	["ConRO_Settings_Auto"] = false,
	["ConRO_Settings_Single"] = true,
	["ConRO_Settings_AoE"] = false,
}
	
if ConRO:MeleeSpec() then
	defaults = {
		["ConRO_Settings_Full"] = true,
		["ConRO_Settings_Burst"] = false,
		["ConRO_Settings_Auto"] = true,
		["ConRO_Settings_Single"] = false,
		["ConRO_Settings_AoE"] = false,
	}
end

ConROCharacter = ConROCharacter or defaults;

function TTOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
	GameTooltip:SetText("ConRO Target Toggle")  -- This sets the top line of text, in gold.
	GameTooltip:AddLine('MACRO = "/ConROToggle"', 1, 1, 1, true)
	GameTooltip:AddLine(" ", 1, 1, 1, true)
	GameTooltip:AddLine("Auto", .2, 1, .2)
		GameTooltip:AddLine("Used for melee specs to auto detect the number of enemies in range. Must have nameplates turned on.", 1, 1, 1, true)	
	GameTooltip:AddLine("Single", 1, .2, .2)
		GameTooltip:AddLine("This will force single target rotation to focus and burn a target.", 1, 1, 1, true)
	GameTooltip:AddLine("AoE", 1, .2, .2)
		GameTooltip:AddLine("This will force AoE rotation for trash or Boss phases with frequent adds.", 1, 1, 1, true)
	GameTooltip:AddLine(" ", 1, 1, 1, true)
		GameTooltip:AddLine('"This can be toggled during combat as phases change."', 1, 1, 0, true)
	GameTooltip:Show()
end

function TTOnLeave(self)
	GameTooltip:Hide()
end

function ETOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
	GameTooltip:SetText("ConRO Rotation Toggle")  -- This sets the top line of text, in gold.
	GameTooltip:AddLine('MACRO = "/ConROBurstToggle"', 1, 1, 1, true)
	GameTooltip:AddLine(" ", 1, 1, 1, true)
	GameTooltip:AddLine("Burst Rotation", .2, 1, .2)
		GameTooltip:AddLine("This is for Boss fights where you want to decide when to use your cooldowns.", 1, 1, 1, true)
	GameTooltip:AddLine("Full Rotation", 1, .2, .2)
		GameTooltip:AddLine("Can be used for placing long cooldowns into the recommended rotation.", 1, 1, 1, true)
	GameTooltip:AddLine(" ", 1, 1, 1, true)
		GameTooltip:AddLine('"This can be toggled during combat as phases change."', 1, 1, 0, true)
	GameTooltip:Show()
end

function ETOnLeave(self)
	GameTooltip:Hide()
end

function TWOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
	GameTooltip:SetText("ConRO Window")  -- This sets the top line of text, in gold.
	GameTooltip:AddLine("", .2, 1, .2)
		GameTooltip:AddLine("This window displays the next suggested ability in your rotation.", 1, 1, 1, true)
	GameTooltip:Show()
end

function TWOnLeave(self)
	GameTooltip:Hide()
end

function ConRO:SlashUnlock()
	if not ConRO.db.profile._Unlock_ConRO then
		ConRO.db.profile._Unlock_ConRO = true;
	else
		ConRO.db.profile._Unlock_ConRO = false;
	end
	
	ConROWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
				
end

SLASH_CONRO1 = '/ConRO'
SLASH_CONROUNLOCK1 = '/ConROlock'
SLASH_CONROA1 = '/ConROtoggle'
SLASH_CONROB1 = '/ConROBurstToggle'
SlashCmdList["CONRO"] = function() InterfaceOptionsFrame_OpenToCategory('ConRO'); InterfaceOptionsFrame_OpenToCategory('ConRO'); end
SlashCmdList["CONROUNLOCK"] = function() ConRO:SlashUnlock() end
SlashCmdList["CONROA"] = function() ConRO:SlashToggle() end -- Slash Command List
SlashCmdList["CONROB"] = function() ConRO:SlashBurstToggle() end -- Slash Command List

function ConRO:DisplayWindowFrame()
	local frame = CreateFrame("Frame", "ConROWindow", UIParent);
		frame:SetMovable(true);
		frame:SetClampedToScreen(true);
		frame:RegisterForDrag("LeftButton");
		frame:SetScript("OnEnter", TWOnEnter);
		frame:SetScript("OnLeave", TWOnLeave);
		frame:SetScript("OnDragStart", function(self)
			if ConRO.db.profile._Unlock_ConRO then
				frame:StartMoving()
			end
		end)
		frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
		frame:EnableMouse(ConRO.db.profile._Unlock_ConRO);
		
		frame:SetPoint("CENTER", -200, 50);
		frame:SetSize(ConRO.db.profile.windowIconSize, ConRO.db.profile.windowIconSize);
		frame:SetFrameStrata('MEDIUM');
		frame:SetFrameLevel('5');
		frame:SetAlpha(ConRO.db.profile.transparencyWindow);		
		if ConRO.db.profile.combatWindow or ConRO:HealSpec() then
			frame:Hide();
		elseif not ConRO.db.profile.enableWindow then
			frame:Hide();
		else
			frame:Show();
		end
	local t = frame.texture;
		if not t then
			t = frame:CreateTexture("ARTWORK");
			t:SetTexture('Interface\\AddOns\\ConRO\\images\\Bigskull');
			t:SetBlendMode('BLEND');
			frame.texture = t;
		end
		
		t:SetAllPoints(frame)

	local fontstring = frame.font;
		if not fontstring then
			fontstring = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
			fontstring:SetText(" ");
			local _, Class = UnitClass("player");
			local Color = RAID_CLASS_COLORS[Class];
			fontstring:SetTextColor(Color.r, Color.g, Color.b, 1);
			fontstring:SetPoint('BOTTOM', frame, 'TOP', 0, 2);
			fontstring:SetWidth(ConRO.db.profile.windowIconSize / 1.25 + 30);
			fontstring:SetHeight(ConRO.db.profile.windowIconSize / 1.25);
			fontstring:SetJustifyV("BOTTOM");
			frame.font = fontstring;
		end
		
		if ConRO.db.profile.enableWindowSpellName then
			fontstring:Show();
		else 
			fontstring:Hide();
		end
	
	local fontkey = frame.fontkey;
		if not fontkey then
			fontkey = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
			fontkey:SetText(" ");
			fontkey:SetPoint('TOP', frame, 'BOTTOM', 0, -2);
			fontkey:SetTextColor(1, 1, 1, 1);
			frame.fontkey = fontkey;
		end
		if ConRO.db.profile.enableWindowKeybinds or ConRO.db.profile._Unlock_ConRO then
			fontkey:Show();
		else 
			fontkey:Hide();
		end
	
	local cd = CreateFrame("Cooldown", "ConROWindowCooldown", frame, "CooldownFrameTemplate")
		cd:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		cd:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
		cd:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		cd:RegisterEvent("UNIT_SPELLCAST_SENT");
		cd:RegisterEvent("UNIT_SPELLCAST_START");
		cd:RegisterEvent("UNIT_SPELLCAST_DELAYED");
		cd:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        cd:RegisterEvent("UNIT_SPELLCAST_FAILED");
		cd:RegisterEvent("UNIT_SPELLCAST_START");
		cd:RegisterEvent("UNIT_SPELLCAST_STOP");
		
		cd:SetAllPoints(frame);
		cd:SetFrameStrata('MEDIUM');
		cd:SetFrameLevel('7');			
		if ConRO.db.profile.enableWindowCooldown then
			cd:SetScript("OnEvent",function(self)
				local gcdStart, gcdDuration = GetSpellCooldown(61304)
				local _, _, _, startTimeMS, endTimeMS = UnitCastingInfo('player');
				local _, _, _, startTimeMSchan, endTimeMSchan = UnitChannelInfo('player');
				if not (endTimeMS or endTimeMSchan) then
					cd:SetCooldown(gcdStart, gcdDuration)
				elseif endTimeMSchan then
					local chanStart  = startTimeMSchan / 1000;
					local chanDuration = endTimeMSchan/1000 - GetTime();
					cd:SetCooldown(chanStart, chanDuration)
				else
					local spStart  = startTimeMS / 1000;
					local spDuration = endTimeMS/1000 - GetTime();
					cd:SetCooldown(spStart, spDuration)			
				end
			end)
		end
end

function ConRO:FindKeybinding(id)
	local keybind;
	if self.Keybinds[id] ~= nil then
		for k, button in pairs(self.Keybinds[id]) do
			for i = 1, 12 do
				if button == 'MultiBarBottomLeftButton' .. i then
					button = 'MULTIACTIONBAR1BUTTON' .. i;
				elseif button == 'MultiBarBottomRightButton' .. i then
					button = 'MULTIACTIONBAR2BUTTON' .. i;
				elseif button == 'MultiBarRightButton' .. i then
					button = 'MULTIACTIONBAR3BUTTON' .. i;
				elseif button == 'MultiBarLeftButton' .. i then
					button = 'MULTIACTIONBAR4BUTTON' .. i;
				end
				
				keybind = GetBindingKey(button);				
			end
		end
	end

	return keybind;
end

function ConRO:CreateDamageOverlay(parent, id)
	local frame = tremove(self.DamageFramePool);
	if not frame then
		frame = CreateFrame('Frame', 'ConRO_DamageOverlay_' .. id, parent);
	end

	frame:SetParent(parent);
	frame:SetFrameStrata('MEDIUM');
	frame:SetFrameLevel('20');
	frame:SetPoint('CENTER', 0, 0);
	frame:SetWidth(parent:GetWidth() * 1.6);
	frame:SetHeight(parent:GetHeight() * 1.6);
	frame:SetScale(ConRO.db.profile._Damage_Overlay_Size);
	if ConRO.db.profile._Damage_Overlay_Alpha == true then
		frame:SetAlpha(1);
	else
		frame:SetAlpha(0);
	end

	local t = frame.texture;
	if not t then
		t = frame:CreateTexture('GlowDamageOverlay', 'OVERLAY');
		if ConRO.db.profile._Damage_Icon_Style == 1 then
			t:SetTexture(ConRO.Textures.Skull);
		elseif ConRO.db.profile._Damage_Icon_Style == 2 then
			t:SetTexture(ConRO.Textures.Starburst);
		elseif ConRO.db.profile._Damage_Icon_Style == 3 then
			t:SetTexture(ConRO.Textures.Shield);
		elseif ConRO.db.profile._Damage_Icon_Style == 4 then
			t:SetTexture(ConRO.Textures.Rage);
		elseif ConRO.db.profile._Damage_Icon_Style == 5 then
			t:SetTexture(ConRO.Textures.Lightning);
		elseif ConRO.db.profile._Damage_Icon_Style == 6 then
			t:SetTexture(ConRO.Textures.MagicCircle);
		elseif ConRO.db.profile._Damage_Icon_Style == 7 then
			t:SetTexture(ConRO.Textures.Plus);
		elseif ConRO.db.profile._Damage_Icon_Style == 8 then
			t:SetTexture(ConRO.Textures.DoubleArrow);
		elseif ConRO.db.profile._Damage_Icon_Style == 9 then
			t:SetTexture(ConRO.Textures.KozNicSquare);
		elseif ConRO.db.profile._Damage_Icon_Style == 10 then
			t:SetTexture(ConRO.Textures.Circle);
		end
		if ConRO.db.profile._Damage_Alpha_Mode == 1 then
			t:SetBlendMode('BLEND');
		elseif ConRO.db.profile._Damage_Alpha_Mode == 2 then
			t:SetBlendMode('ADD');
		elseif ConRO.db.profile._Damage_Alpha_Mode == 3 then
			t:SetBlendMode('MOD');
		elseif ConRO.db.profile._Damage_Alpha_Mode == 4 then
			t:SetBlendMode('ALPHAKEY');
		elseif ConRO.db.profile._Damage_Alpha_Mode == 5 then
			t:SetBlendMode('DISABLE');
		end
		frame.texture = t;
	end

	t:SetAllPoints(frame);
	local color = ConRO.db.profile._Damage_Overlay_Color;
	if ConRO.db.profile._Damage_Overlay_Class_Color then
		local _, _, classId = UnitClass('player');
		color = ConRO.ClassRGB[classId];
	end
						
	t:SetVertexColor(color.r, color.g, color.b);
	t:SetAlpha(color.a);

	tinsert(self.DamageFrames, frame);
	return frame;
end

function ConRO:CreateCoolDownOverlay(parent, id)
	local frame = tremove(self.CoolDownFramePool);
	if not frame then
		frame = CreateFrame('Frame', 'ConRO_CoolDownOverlay_' .. id, parent);
	end

	frame:SetParent(parent);
	frame:SetFrameStrata('MEDIUM');
	frame:SetFrameLevel('20')
	frame:SetPoint('CENTER', 0, 0);
	frame:SetWidth(parent:GetWidth() * 1.6);
	frame:SetHeight(parent:GetHeight() * 1.6);
	frame:SetScale(ConRO.db.profile._Cooldown_Overlay_Size)
	if ConRO.db.profile._Damage_Overlay_Alpha == true then
		frame:SetAlpha(1);
	else
		frame:SetAlpha(0);
	end

	local t = frame.texture;
	if not t then
		t = frame:CreateTexture('AbilityBurstOverlay', 'OVERLAY');
		if ConRO.db.profile._Cooldown_Icon_Style == 1 then
			t:SetTexture(ConRO.Textures.Skull);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 2 then
			t:SetTexture(ConRO.Textures.Starburst);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 3 then
			t:SetTexture(ConRO.Textures.Shield);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 4 then
			t:SetTexture(ConRO.Textures.Rage);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 5 then
			t:SetTexture(ConRO.Textures.Lightning);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 6 then
			t:SetTexture(ConRO.Textures.MagicCircle);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 7 then
			t:SetTexture(ConRO.Textures.Plus);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 8 then
			t:SetTexture(ConRO.Textures.DoubleArrow);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 9 then
			t:SetTexture(ConRO.Textures.KozNicSquare);
		elseif ConRO.db.profile._Cooldown_Icon_Style == 10 then
			t:SetTexture(ConRO.Textures.Circle);
		end
		if ConRO.db.profile._Cooldown_Alpha_Mode == 1 then
			t:SetBlendMode('BLEND');
		elseif ConRO.db.profile._Cooldown_Alpha_Mode == 2 then
			t:SetBlendMode('ADD');
		elseif ConRO.db.profile._Cooldown_Alpha_Mode == 3 then
			t:SetBlendMode('MOD');
		elseif ConRO.db.profile._Cooldown_Alpha_Mode == 4 then
			t:SetBlendMode('ALPHAKEY');
		elseif ConRO.db.profile._Cooldown_Alpha_Mode == 5 then
			t:SetBlendMode('DISABLE');
		end
		frame.texture = t;
	end

	t:SetAllPoints(frame);
	local color = ConRO.db.profile._Cooldown_Overlay_Color;
	t:SetVertexColor(color.r, color.g, color.b);
	t:SetAlpha(color.a);
	
	tinsert(self.CoolDownFrames, frame);
	return frame;
end

function ConRO:DestroyDamageOverlays()
	local frame;
	for key, frame in pairs(self.DamageFrames) do
		frame:GetParent().ConRODamageOverlays = nil;
		frame:ClearAllPoints();
		frame:Hide();
		frame:SetParent(UIParent);
		frame.width = nil;
		frame.height = nil;
		frame.alpha = nil;
	end
	for key, frame in pairs(self.DamageFrames) do
		tinsert(self.DamageFramePool, frame);
		self.DamageFrames[key] = nil;
	end
end

function ConRO:DestroyCoolDownOverlays()
	local frame;
	for key, frame in pairs(self.CoolDownFrames) do
		frame:GetParent().ConROCoolDownOverlays = nil;
		frame:ClearAllPoints();
		frame:Hide();
		frame:SetParent(UIParent);
		frame.width = nil;
		frame.height = nil;
		frame.alpha = nil;
	end
	for key, frame in pairs(self.CoolDownFrames) do
		tinsert(self.CoolDownFramePool, frame);
		self.CoolDownFrames[key] = nil;
	end
end

function ConRO:UpdateButtonGlow()
	local LAB;
	local LBG;
	local origShow;
	local noFunction = function() end;

	if IsAddOnLoaded('ElvUI') then
		LAB = LibStub:GetLibrary('LibActionButton-1.0-ElvUI');
		LBG = LibStub:GetLibrary('LibButtonGlow-1.0');
		origShow = LBG.ShowOverlayGlow;
	elseif IsAddOnLoaded('Bartender4') then
		LAB = LibStub:GetLibrary('LibActionButton-1.0');
	end

	if self.db.profile.disableButtonGlow then
		ActionBarActionEventsFrame:UnregisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW');
		if LAB then
			LAB.eventFrame:UnregisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW');
		end

		if LBG then
			LBG.ShowOverlayGlow = noFunction;
		end
	else
		ActionBarActionEventsFrame:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW');
		if LAB then
			LAB.eventFrame:RegisterEvent('SPELL_ACTIVATION_OVERLAY_GLOW_SHOW');
		end

		if LBG then
			LBG.ShowOverlayGlow = origShow;
		end
	end
end

function ConRO:DamageGlow(button, id)
	if button.ConRODamageOverlays and button.ConRODamageOverlays[id] then
		button.ConRODamageOverlays[id]:Show();
	else
		if not button.ConRODamageOverlays then
			button.ConRODamageOverlays = {};
		end

		button.ConRODamageOverlays[id] = self:CreateDamageOverlay(button, id);
		button.ConRODamageOverlays[id]:Show();
	end
end

function ConRO:CoolDownGlow(button, id)
	if button.ConROCoolDownOverlays and button.ConROCoolDownOverlays[id] then
		button.ConROCoolDownOverlays[id]:Show();
	else
		if not button.ConROCoolDownOverlays then
			button.ConROCoolDownOverlays = {};
		end

		button.ConROCoolDownOverlays[id] = self:CreateCoolDownOverlay(button, id);
		button.ConROCoolDownOverlays[id]:Show();
	end
end

function ConRO:HideDamageGlow(button, id)
	if button.ConRODamageOverlays and button.ConRODamageOverlays[id] then
		button.ConRODamageOverlays[id]:Hide();
	end
end

function ConRO:HideCoolDownGlow(button, id)
	if button.ConROCoolDownOverlays and button.ConROCoolDownOverlays[id] then
		button.ConROCoolDownOverlays[id]:Hide();
	end
end

function ConRO:UpdateRotation()	
	self = ConRO;

	self:FetchBlizzard();
	
	if IsAddOnLoaded('Bartender4') then
		self:FetchBartender4();
	end

	if IsAddOnLoaded('ButtonForge') then
		self:FetchButtonForge();
	end
	
	if IsAddOnLoaded('ElvUI') then
		self:FetchElvUI();
	end
	
	if IsAddOnLoaded('Dominos') then
		self:FetchDominos();
	end
	
    if IsAddOnLoaded('DiabolicUI') then
        self:FetchDiabolic();
    end
 
    if IsAddOnLoaded('AzeriteUI') then
        self:FetchAzeriteUI();
    end
	
	if IsAddOnLoaded('ls_UI') then
        self:FetchLSUI();
    end	
end

function ConRO:AddButton(spellID, button, hotkey)
	if spellID then
		if self.Spells[spellID] == nil then
			self.Spells[spellID] = {};
		end
		tinsert(self.Spells[spellID], button);
		
		if self.Keybinds[spellID] == nil then
			self.Keybinds[spellID] = {};
		end

		tinsert(self.Keybinds[spellID], hotkey);
	end
end

function ConRO:AddStandardButton(button, hotkey)
	local type = button:GetAttribute('type');
	if type then
		local actionType = button:GetAttribute(type);
		local id;
		local spellId;

        if type == 'action' then
            local slot = button:GetAttribute('action');
            if not slot or slot == 0 then
                slot = button:GetPagedID();
            end
            if not slot or slot == 0 then
                slot = button:CalculateAction();
            end
 
            if HasAction(slot) then
                type, id = GetActionInfo(slot);
            else
                return;
            end
        end
 
        if type == 'macro' then
            spellId = GetMacroSpell(id);
            if not spellId then
                return;
            end
        elseif type == 'item' then
            spellId = id;
        elseif type == 'spell' then
            spellId = select(7, GetSpellInfo(id));
        end

		self:AddButton(spellId, button, hotkey);
	end
end

function ConRO:Fetch()
	self = ConRO;
	if self.rotationEnabled then
		self:DisableRotationTimer();
	end
	self.Spell = nil;

	self:GlowClear();
	self.Spells = {};
	self.Keybinds = {};
	self.Flags = {};
	self.SpellsGlowing = {};

	self:FetchBlizzard();

	if IsAddOnLoaded('Bartender4') then
		self:FetchBartender4();
	end

	if IsAddOnLoaded('ButtonForge') then
		self:FetchButtonForge();
	end
	
	if IsAddOnLoaded('ElvUI') then
		self:FetchElvUI();
	end
	
	if IsAddOnLoaded('Dominos') then
		self:FetchDominos();
	end
	
    if IsAddOnLoaded('DiabolicUI') then
        self:FetchDiabolic();
    end
 
    if IsAddOnLoaded('AzeriteUI') then
        self:FetchAzeriteUI();
    end
	
    if IsAddOnLoaded('ls_UI') then
        self:FetchLSUI();
    end	

	if self.rotationEnabled then
		self:EnableRotationTimer();
		self:InvokeNextSpell();
	end
end

function ConRO:FetchBlizzard()
	local ActionBarsBlizzard = {'Stance', 'PetAction', 'Action', 'MultiBarBottomLeft', 'MultiBarBottomRight', 'MultiBarRight', 'MultiBarLeft'};
	for _, barName in pairs(ActionBarsBlizzard) do
		if barName == 'Stance' then
			local x = GetNumShapeshiftForms();
			for i = 1, x do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'SHAPESHIFTBUTTON' .. i;
				local spellID = select(4, GetShapeshiftFormInfo(i));
				self:AddButton(spellID, button, hotkey);
			end
		elseif barName == 'PetAction' then
			for i = 1, 10 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = barName .. 'Button' .. i;
				local spellID = select(7, GetPetActionInfo(i));
				self:AddButton(spellID, button, hotkey);
			end	
		else
			for i = 1, 12 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = barName .. 'Button' .. i;
				self:AddStandardButton(button, hotkey);
			end
		end
	end
end

function ConRO:FetchElvUI()
	for x = 10, 1, -1 do
		for i = 1, 12 do
			local button = _G['ElvUI_Bar' .. x .. 'Button' .. i];
				if button == 'ElvUI_Bar1Button' .. i then
					hotkey = 'ACTIONBUTTON' .. i;
				elseif button == 'ElvUI_Bar2Button' .. i then
					hotkey = 'MULTIACTIONBAR2BUTTON' .. i;
				elseif button == 'ElvUI_Bar3Button' .. i then
					hotkey = 'MULTIACTIONBAR1BUTTON' .. i;
				elseif button == 'ElvUI_Bar4Button' .. i then
					hotkey = 'MULTIACTIONBAR4BUTTON' .. i;
				elseif button == 'ElvUI_Bar5Button' .. i then
					hotkey = 'MULTIACTIONBAR3BUTTON' .. i;
				elseif button == 'ElvUI_Bar6Button' .. i then
					hotkey = 'ELVUIBAR6BUTTON' .. i;
				elseif button == 'ElvUI_Bar7Button' .. i then
					hotkey = 'EXTRABAR7BUTTON' .. i;
				elseif button == 'ElvUI_Bar8Button' .. i then
					hotkey = 'EXTRABAR8BUTTON' .. i;
				elseif button == 'ElvUI_Bar9Button' .. i then
					hotkey = 'EXTRABAR9BUTTON' .. i;
				elseif button == 'ElvUI_Bar10Button' .. i then
					hotkey = 'EXTRABAR10BUTTON' .. i;
				end			

				if button then
					self:AddStandardButton(button, hotkey);
				end
		end
	end
end
					
function ConRO:DefFetchElvUI()
	for x = 10, 1, -1 do
		for i = 1, 12 do
			local button = _G['ElvUI_Bar' .. x .. 'Button' .. i];
				if button == 'ElvUI_Bar1Button' .. i then
					hotkey = 'ACTIONBUTTON' .. i;
				elseif button == 'ElvUI_Bar2Button' .. i then
					hotkey = 'MULTIACTIONBAR2BUTTON' .. i;
				elseif button == 'ElvUI_Bar3Button' .. i then
					hotkey = 'MULTIACTIONBAR1BUTTON' .. i;
				elseif button == 'ElvUI_Bar4Button' .. i then
					hotkey = 'MULTIACTIONBAR4BUTTON' .. i;
				elseif button == 'ElvUI_Bar5Button' .. i then
					hotkey = 'MULTIACTIONBAR3BUTTON' .. i;
				elseif button == 'ElvUI_Bar6Button' .. i then
					hotkey = 'ELVUIBAR6BUTTON' .. i;
				elseif button == 'ElvUI_Bar7Button' .. i then
					hotkey = 'EXTRABAR7BUTTON' .. i;
				elseif button == 'ElvUI_Bar8Button' .. i then
					hotkey = 'EXTRABAR8BUTTON' .. i;
				elseif button == 'ElvUI_Bar9Button' .. i then
					hotkey = 'EXTRABAR9BUTTON' .. i;
				elseif button == 'ElvUI_Bar10Button' .. i then
					hotkey = 'EXTRABAR10BUTTON' .. i;
				end			

				if button then
					self:DefAddStandardButton(button, hotkey);
				end
		end
	end
end

function ConRO:FetchBartender4()
	local ActionBarsBartender4 = {'BT4','BT4Stance', 'BT4Pet'};
	for _, barName in pairs(ActionBarsBartender4) do
		if barName == 'BT4Stance' then
			local x = GetNumShapeshiftForms();
			for i = 1, x do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4StanceButton' .. i .. ':LeftButton';
				local spellID = select(4, GetShapeshiftFormInfo(i));
				self:AddButton(spellID, button, hotkey);
			end
		elseif barName == 'BT4Pet' then
			for i = 1, 10 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4PetButton' .. i .. ':LeftButton';
				local spellID = select(7, GetPetActionInfo(i));
				self:AddButton(spellID, button, hotkey);
			end	
		else
			for i = 1, 120 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4Button' .. i .. ':LeftButton';
				if button then
					self:AddStandardButton(button, hotkey);
				end
			end
		end
	end
end

function ConRO:DefFetchBartender4()
	local ActionBarsBartender4 = {'BT4','BT4Stance', 'BT4Pet'};
	for _, barName in pairs(ActionBarsBartender4) do
		if barName == 'BT4Stance' then
			local x = GetNumShapeshiftForms();
			for i = 1, x do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4StanceButton' .. i .. ':LeftButton';
				local spellID = select(4, GetShapeshiftFormInfo(i));
				self:DefAddButton(spellID, button, hotkey);
			end
		elseif barName == 'BT4Pet' then
			for i = 1, 10 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4PetButton' .. i .. ':LeftButton';
				local spellID = select(7, GetPetActionInfo(i));
				self:DefAddButton(spellID, button, hotkey);
			end	
		else
			for i = 1, 120 do
				local button = _G[barName .. 'Button' .. i];
				local hotkey = 'CLICK BT4Button' .. i .. ':LeftButton';
				if button then
					self:DefAddStandardButton(button, hotkey);
				end
			end
		end
	end
end

function ConRO:Dump()
	local s = '';
	for k, v in pairs(self.Spells) do
		s = s .. ', ' .. k;
	end
	print(s);
end

function ConRO:FindSpell(spellID)
	return self.Spells[spellID];
end

function ConRO:AbilityBurstIndependent(_Spell_ID)
	if self.Spells[_Spell_ID] ~= nil then
		for k, button in pairs(self.Spells[_Spell_ID]) do
			self:CoolDownGlow(button, _Spell_ID);
		end
	end
end

function ConRO:ClearAbilityBurstIndependent(_Spell_ID)
	if self.Spells[_Spell_ID] ~= nil then
		for k, button in pairs(self.Spells[_Spell_ID]) do
			self:HideCoolDownGlow(button, _Spell_ID);
		end
	end
end

function ConRO:AbilityBurst(_Spell, _Condition)
	local incombat = UnitAffectingCombat('player');
	
	if self.Flags[_Spell] == nil then
		self.Flags[_Spell] = false;
	end
	if _Condition and incombat then
		self.Flags[_Spell] = true;
		self:AbilityBurstIndependent(_Spell);		
	else
		self.Flags[_Spell] = false;
		self:ClearAbilityBurstIndependent(_Spell);
	end
end

function ConRO:GlowSpell(spellID)
	local spellName = GetSpellInfo(spellID);
	
	if self.Spells[spellID] ~= nil then
		for k, button in pairs(self.Spells[spellID]) do
			self:DamageGlow(button, 'next');
		end
		self.SpellsGlowing[spellID] = 1;
	else
		if UnitAffectingCombat('player') and not (spellID == 162794 or spellID == 188499 or spellID == 205448) then
			if spellName ~= nil then
				self:Print(self.Colors.Error .. 'Spell not found on action bars: ' .. ' ' .. spellName .. ' ' .. '(' .. spellID .. ')');
			else
				local itemName = GetItemInfo(spellID);
				if itemName ~= nil then
					self:Print(self.Colors.Error .. 'Item not found on action bars: ' .. ' ' .. itemName .. ' ' .. '(' .. spellID .. ')');
				end
			end
		end
		ConRO:ButtonFetch();
	end
end

function ConRO:GlowNextSpell(spellID)
	self:GlowClear();
	self:GlowSpell(spellID);
end

function ConRO:GlowClear()
	for spellID, v in pairs(self.SpellsGlowing) do
		if v == 1 then
			for k, button in pairs(self.Spells[spellID]) do
				self:HideDamageGlow(button, 'next');
			end
			self.SpellsGlowing[spellID] = 0;
		end
	end
end

local function TTOnEnter(self)
  GameTooltip:SetOwner(self, "ConROButtonFrame")
  GameTooltip:SetText("tooltipTitle")  -- This sets the top line of text, in gold.
  GameTooltip:AddLine("This is the contents of my tooltip", 1, 1, 1)
  GameTooltip:Show()
end

local function TTOnLeave(self)
  GameTooltip:Hide()
end