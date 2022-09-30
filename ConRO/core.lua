local AceGUI = LibStub('AceGUI-3.0');
local lsm = LibStub('AceGUISharedMediaWidgets-1.0');
local media = LibStub('LibSharedMedia-3.0');
local ADDON_NAME, ADDON_TABLE = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version");
local addoninfo = 'Main Version: ' .. version;

BINDING_HEADER_ConRO = "ConRO Hotkeys"
BINDING_NAME_CONROUNLOCK = "Lock/Unlock ConRO"
BINDING_NAME_CONROTOGGLE = "Target Set Toggle (Single/AoE)"
BINDING_NAME_CONROBOSSTOGGLE = "Enemy Set Toggle (Burst/Full)"

ConRO = LibStub('AceAddon-3.0'):NewAddon('ConRO', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0');

ConRO.Textures = {
	['Skull'] = 'Interface\\AddOns\\ConRO\\images\\skull',
	['Starburst'] = 'Interface\\AddOns\\ConRO\\images\\starburst',
	['Shield'] = 'Interface\\AddOns\\ConRO\\images\\shield2',
	['Rage'] = 'Interface\\AddOns\\ConRO\\images\\rage',

	['Lightning'] = 'Interface\\AddOns\\ConRO\\images\\lightning',
	['MagicCircle'] = 'Interface\\AddOns\\ConRO\\images\\magiccircle',
	['Plus'] = 'Interface\\AddOns\\ConRO\\images\\plus',
	['DoubleArrow'] = 'Interface\\AddOns\\ConRO\\images\\arrow',
	
	['KozNicSquare'] = 'Interface\\AddOns\\ConRO\\images\\KozNic_square',
	['Circle'] = 'Interface\\AddOns\\ConRO\\images\\Circle',
};
ConRO.FinalTexture = nil;

ConRO.Colors = {
	Info = '|cFF1394CC',
	Error = '|cFFF0563D',
	Success = '|cFFBCCF02',
	[1] = '|cFFC79C6E',
	[2] = '|cFFF58CBA',
	[3] = '|cFFABD473',
	[4] = '|cFFFFF569',
	[5] = '|cFFFFFFFF',
	[6] = '|cFFC41F3B',
	[7] = '|cFF0070DE',
	[8] = '|cFF69CCF0',
	[9] = '|cFF9482C9',
	[10] = '|cFF00FF96',
	[11] = '|cFFFF7D0A',
	[12] = '|cFFA330C9',
}

ConRO.ClassRGB = {
	[1] = {r = 0.78,g = 0.61,b = 0.43, a = 1.00},
	[2] = {r = 0.96,g = 0.55,b = 0.73, a = 1.00},
	[3] = {r = 0.67,g = 0.83,b = 0.45, a = 1.00},
	[4] = {r = 1.00,g = 0.96,b = 0.41, a = 1.00},
	[5] = {r = 1.00,g = 1.00,b = 1.00, a = 1.00},
	[6] = {r = 0.77,g = 0.12,b = 0.23, a = 1.00},
	[7] = {r = 0.00,g = 0.44,b = 0.87, a = 1.00},
	[8] = {r = 0.25,g = 0.78,b = 0.92, a = 1.00},
	[9] = {r = 0.53,g = 0.53,b = 0.93, a = 1.00},
	[10] = {r = 0.00,g = 1.00,b = 0.60, a = 1.00},
	[11] = {r = 1.00,g = 0.49,b = 0.04, a = 1.00},
	[12] = {r = 0.64,g = 0.19,b = 0.79, a = 1.00},
}

ConRO.Classes = {
	[1] = 'Warrior',
	[2] = 'Paladin',
	[3] = 'Hunter',
	[4] = 'Rogue',
	[5] = 'Priest',
	[6] = 'DeathKnight',
	[7] = 'Shaman',
	[8] = 'Mage',
	[9] = 'Warlock',
	[10] = 'Monk',
	[11] = 'Druid',
	[12] = 'DemonHunter',
}

local defaultOptions = {
	profile = {
		_Disable_Info_Messages = true,
		_Intervals = 0.20,
		_Unlock_ConRO = true,

		_Spec_1_Enabled = true,
		_Spec_2_Enabled = true,
		_Spec_3_Enabled = true,
		_Spec_4_Enabled = true,
		
		_Damage_Overlay_Alpha = true,
		_Damage_Overlay_Color = {r = 0.8,g = 0.8,b = 0.8,a = 1},
		_Damage_Overlay_Size = 1,
		_Damage_Icon_Style = 1,
		_Damage_Alpha_Mode = 1,
		_Damage_Overlay_Class_Color = false,
		_Cooldown_Overlay_Color = {r = 1,g = 0.6,b = 0,a = 1},
		_Cooldown_Overlay_Size = 1,
		_Cooldown_Icon_Style = 2,
		_Cooldown_Alpha_Mode = 2,

		_Notifier_Overlay_Alpha = true,
				
		enableWindow = true,
		combatWindow = false,
		enableWindowCooldown = true,		
		enableWindowSpellName = false,
		enableWindowKeybinds = true,
		transparencyWindow = 0.6,
		windowIconSize = 50,
		flashIconSize = 50,
		
		_Hide_Toggle = false,
		toggleButtonSize = 1.2,
		toggleButtonOrientation = 2,
		_Burst_Threshold = 90,
	}
}	

local orientations = {
		"Vertical",
		"Horizontal",
}

local _Overlay_Styles = {
	'Skull',
	'Starburst',
	'Shield',
	'Rage',
	'Lightning',
	'MagicCircle',
	'Plus',
	'DoubleArrow',
	'KozNic Square',
	'Circle',
}

local _Alpha_Modes = {
	'BLEND',
	'ADD',
	'MOD',
	'ALPHAKEY',
	'DISABLE',
}

local _, _, classIdv = UnitClass('player');
local cversion = GetAddOnMetadata('ConRO_' .. ConRO.Classes[classIdv], 'Version');
local classinfo = " ";
	if cversion ~= nil then
		classinfo = ConRO.Classes[classIdv] .. ' Version: ' .. cversion;
	end

local options = {
	type = 'group',
	name = '-= |cffFFFFFFConRO  (Conflict Rotation Optimizer)|r =-',
	inline = false,
	childGroups = "tab",
	args = {
		versionPull = {
			order = 1,
			type = "description",
			width = "normal",
			name = addoninfo,
		},
		spacer2 = {
			order = 2,
			type = "description",
			width = "normal",
			name = "\n\n",
		},		
		authorPull = {
			order = 3,
			type = "description",
			width = "normal",
			name = "Author: Kontric",
		},
		cversionPull = {
			order = 4,
			type = "description",
			width = "full",
			name = classinfo,
		},
--Generic Addon Settings
		spacer10 = {
			order = 10,
			type = "description",
			width = "full",
			name = "\n\n",
		},
		_Disable_Info_Messages = {
			name = "Disable info messages",
			desc = "Enables / disables info messages, if you have issues with addon, make sure to deselect this.",
			type = "toggle",
			width = "normal",
			order = 11,
			set = function(info, val)
				ConRO.db.profile._Disable_Info_Messages = val;
			end,
			get = function(info) return ConRO.db.profile._Disable_Info_Messages end
		},
		spacer12 = {
			order = 12,
			type = "description",
			width = "normal",
			name = "\n\n",
		},		
		_Intervals = {
			name = "Interval in seconds",
			desc = "Sets how frequent rotation updates will be. Low value will result in fps drops.",
			type = "range",
			width = "normal",
			order = 13,
			hidden = true,
			min = 0.01,
			max = 2,
			set = function(info,val) ConRO.db.profile._Intervals = val end,
			get = function(info) return ConRO.db.profile._Intervals end
		},
		_Unlock_ConRO = {
			name = "Unlock ConRO",
			desc = "Make display windows movable.",
			type = "toggle",
			width = "normal",
			order = 14,
			set = function(info, val)
				ConRO.db.profile._Unlock_ConRO = val;
				ConROWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
			end,
			get = function(info) return ConRO.db.profile._Unlock_ConRO end
		},

--Class Settings
		classSettings = {
			type = 'group',
			name = 'Class Settings',
			order = 20,
			args = {
				_Spec_1_Enabled = {
					name = function() return "\124T".. select(4, GetSpecializationInfo(1)) ..":0\124t ".. select(2, GetSpecializationInfo(1)) end,
					desc = function() return select(3, GetSpecializationInfo(1)) end,
					type = "toggle",
					width = .80,
					order = 1,
					set = function(info, val)
						ConRO.db.profile._Spec_1_Enabled = val;
						
						ConRO:DisableRotation();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						
						if ConRO:HealSpec() then
							ConROWindow:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
						else
							ConROWindow:Hide();	
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_1_Enabled end
				},
				_Spec_2_Enabled = {
					name = function() return "\124T".. select(4, GetSpecializationInfo(2)) ..":0\124t ".. select(2, GetSpecializationInfo(2)) end,
					desc = function() return select(3, GetSpecializationInfo(2)) end,
					type = "toggle",
					width = .80,
					order = 2,
					set = function(info, val)
						ConRO.db.profile._Spec_2_Enabled = val;
						
						ConRO:DisableRotation();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						
						if ConRO:HealSpec() then
							ConROWindow:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
						else
							ConROWindow:Hide();	
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_2_Enabled end
				},
				_Spec_3_Enabled = {
					name = function() if GetNumSpecializations() >= 3 then return "\124T".. select(4, GetSpecializationInfo(3)) ..":0\124t ".. select(2, GetSpecializationInfo(3)); end end,
					desc = function() if GetNumSpecializations() >= 3 then return select(3, GetSpecializationInfo(3)); end end,
					type = "toggle",
					width = .80,
					order = 3,
					hidden = function() if GetNumSpecializations() >= 3 then return false; else return true; end end,
					set = function(info, val)
						ConRO.db.profile._Spec_3_Enabled = val;
						
						ConRO:DisableRotation();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						
						if ConRO:HealSpec() then
							ConROWindow:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
						else
							ConROWindow:Hide();	
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_3_Enabled end
				},
				_Spec_4_Enabled = {
					name = function() if GetNumSpecializations() >= 4 then return "\124T".. select(4, GetSpecializationInfo(4)) ..":0\124t ".. select(2, GetSpecializationInfo(4)); end end,
					desc = function() if GetNumSpecializations() >= 4 then return select(3, GetSpecializationInfo(4)); end end,
					type = "toggle",
					width = .80,
					order = 4,
					hidden = function() if GetNumSpecializations() >= 4 then return false; else return true; end end,
					set = function(info, val)
						ConRO.db.profile._Spec_4_Enabled = val;
						
						ConRO:DisableRotation();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						
						if ConRO:HealSpec() then
							ConROWindow:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
						else
							ConROWindow:Hide();	
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_4_Enabled end
				},
			},
		},

--Overlay Settings
		overlaySettings = {
			type = 'group',
			name = 'Overlay Settings',
			order = 21,
			args = {
				_Damage_Overlay_Alpha = {
					name = 'Show Damage Overlay',
					desc = 'Turn damage overlay on and off.',
					type = 'toggle',
					width = 'default',
					order = 3,
					set = function(info, val)
						ConRO.db.profile._Damage_Overlay_Alpha = val;
						if ConRO.db.profile._Damage_Overlay_Alpha then
							local _Frame_Tables_ConRO = {ConRO.DamageFrames, ConRO.CoolDownFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(1);
									end
								end
							end
						else
							local _Frame_Tables_ConRO = {ConRO.DamageFrames, ConRO.CoolDownFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(0);
									end
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Alpha end
				},				
				_Damage_Spacer = {
					type = "description",
					width = "full",
					name = "\n\n",
					order = 10,
				},			
				_Damage_Overlays = {
					type = "header",
					name = "Damage Overlays",
					order = 11,
				},
				_Damage_Overlay_Color = {
					name = 'Damage',
					desc = 'Change damage overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha and not ConRO.db.profile._Damage_Overlay_Class_Color then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 12,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Damage_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Damage_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				_Damage_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the damage overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .65,
					order = 13,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Damage_Overlay_Size = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Size end
				},
				_Damage_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the damage overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .70,
					order = 14,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Damage_Icon_Style = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then						
								if ConRO.db.profile._Damage_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
									overlay.texture:SetBlendMode('BLEND');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Icon_Style end
				},
				_Damage_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the damage texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .55,
					order = 15,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Damage_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then						
								if ConRO.db.profile._Damage_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Alpha_Mode end
				},
				_Damage_Overlay_Class_Color = {
					name = 'Class Colors',
					desc = 'Change damage overlays to class colors.',
					type = 'toggle',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .60,
					order = 16,
					set = function(info, val)
						ConRO.db.profile._Damage_Overlay_Class_Color = val;
						if val == true then
							local _, _, classId = UnitClass('player');
							local c = ConRO.ClassRGB[classId];
							for k, overlay in pairs(ConRO.DamageFrames) do
								if overlay ~= nil then
									overlay.texture:SetVertexColor(c.r, c.g, c.b);
									overlay.texture:SetAlpha(c.a);
								end
							end
						else
							local t = ConRO.db.profile._Damage_Overlay_Color;
							for k, overlay in pairs(ConRO.DamageFrames) do
								if overlay ~= nil then
									overlay.texture:SetVertexColor(t.r, t.g, t.b);
									overlay.texture:SetAlpha(t.a);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Class_Color end
				},
				_Cooldown_Overlay_Color = {
					name = 'Cooldown',
					desc = 'Change cooldown burst overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 17,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Cooldown_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Cooldown_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				_Cooldown_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the cooldown overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .65,
					order = 18,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Cooldown_Overlay_Size = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Overlay_Size end
				},				
				_Cooldown_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the cooldown overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .70,
					order = 19,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Cooldown_Icon_Style = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then						
								if ConRO.db.profile._Cooldown_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Icon_Style end
				},
				_Cooldown_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the cooldown texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .55,
					order = 20,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Cooldown_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then						
								if ConRO.db.profile._Cooldown_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Alpha_Mode end
				},
		},

--Display Window Settings
		displayWindowSettings = {
			type = "group",
			name = "Display Window Settings",
			order = 22,
			args = {
				enableWindow = {
					name = 'Enable Display Window',
					desc = 'Show movable display window.',
					type = 'toggle',
					width = 'default',
					order = 73,
					set = function(info, val)
						ConRO.db.profile.enableWindow = val;
						if val == true and not ConRO:HealSpec() then
							ConROWindow:Show();
						else
							ConROWindow:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindow end
				},
				combatWindow = {
					name = 'Only Display with Hostile',
					desc = 'Show display window only when hostile target selected.',
					type = 'toggle',
					width = 'default',
					order = 74,
					set = function(info, val)
						ConRO.db.profile.combatWindow = val;
						if val == true then
							ConROWindow:Hide();							
						else
							ConROWindow:Show();
						end
					end,
					get = function(info) return ConRO.db.profile.combatWindow end
				},
				enableWindowCooldown = {
					name = 'Enable Cooldown Swirl',
					desc = 'Show cooldown swirl on Display Windows. REQUIRES RELOAD',
					type = 'toggle',
					width = 'normal',
					order = 75,
					set = function(info, val)
						ConRO.db.profile.enableWindowCooldown = val;		
					end,
					get = function(info) return ConRO.db.profile.enableWindowCooldown end
				},
				enableWindowSpellName = {
					name = 'Show Spellname',
					desc = 'Show spellname above Display Windows.',
					type = 'toggle',
					width = 'normal',
					order = 77,
					set = function(info, val)
						ConRO.db.profile.enableWindowSpellName = val;
						if val == true then
							ConROWindow.font:Show();
						else 
							ConROWindow.font:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindowSpellName end
				},
				enableWindowKeybinds = {
					name = 'Show Keybind',
					desc = 'Show keybinds below Display Windows.',
					type = 'toggle',
					width = 'normal',
					order = 78,
					set = function(info, val)
						ConRO.db.profile.enableWindowKeybinds = val;
						if val == true then
							ConROWindow.fontkey:Show();
						else 
							ConROWindow.fontkey:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindowKeybinds end
				},
				transparencyWindow = {
					name = 'Window Transparency',
					desc = 'Change transparency of your windows and texts.',
					type = 'range',
					width = 'normal',
					order = 79,
					min = 0,
					max = 1,
					step = 0.01,
					set = function(info, val)
						ConRO.db.profile.transparencyWindow = val;
					end,
					get = function(info) return ConRO.db.profile.transparencyWindow end
				},	
				windowIconSize = {
					name = 'Display windows Icon size.',
					desc = 'Sets the size of the icon in your display windows. REQUIRES RELOAD',
					type = 'range',
					width = 'normal',
					order = 80,
					min = 20,
					max = 100,
					step = 2,
					set = function(info, val)
						ConRO.db.profile.windowIconSize = val;
					end,
					get = function(info) return ConRO.db.profile.windowIconSize end
				},
				flashIconSize = {
					name = 'Flasher Icon size.',
					desc = 'Sets the size of the icon that flashes for Interrupts and Purges.',
					type = 'range',
					width = 'normal',
					order = 81,
					min = 20,
					max = 100,
					step = 2,
					set = function(info, val)
						ConRO.db.profile.flashIconSize = val;
						ConROInterruptWindow:SetSize(ConRO.db.profile.flashIconSize * .25, ConRO.db.profile.flashIconSize * .25);
						ConROPurgeWindow:SetSize(ConRO.db.profile.flashIconSize * .25, ConRO.db.profile.flashIconSize * .25);
					end,
					get = function(info) return ConRO.db.profile.flashIconSize end
				},				
				spacer84 = {
					order = 84,
					type = "description",
					width = "normal",
					name = "\n\n",
				},
			},
		},
		},	
	}
}

function ConRO:GetTexture()
	if self.db.profile.customTexture ~= '' and self.db.profile.customTexture ~= nil then
		self.FinalTexture = self.db.profile.customTexture;
		return self.FinalTexture;
	end

	self.FinalTexture = self.Textures[self.db.profile.texture];
	if self.FinalTexture == '' or self.FinalTexture == nil then
		self.FinalTexture = 'Interface\\Cooldown\\ping4';
	end

	return self.FinalTexture;
end

function ConRO:OnInitialize()
	LibStub('AceConfig-3.0'):RegisterOptionsTable('Conflict Rotation Optimizer', options, {'conflictrotationoptimizer'});
	self.db = LibStub('AceDB-3.0'):New('ConROPreferences', defaultOptions);
	self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('Conflict Rotation Optimizer', 'ConRO');
	self.DisplayWindowFrame();
	self.DisplayToggleFrame();
end

ConRO.DefaultPrint = ConRO.Print;
function ConRO:Print(...)
	if self.db.profile._Disable_Info_Messages then
		return;
	end
	ConRO:DefaultPrint(...);
end

function ConRO:EnableRotation()
	if self.NextSpell == nil or self.rotationEnabled then
		self:Print(self.Colors.Error .. 'Failed to enable addon!');
		return;
	end
	
	self.Fetch();
	self:CheckTalents();
	self:CheckPvPTalents();
	
	if self.ModuleOnEnable then
		self.ModuleOnEnable();
	end

	self:EnableRotationTimer();
	self.rotationEnabled = true;
end

function ConRO:EnableRotationTimer()
	self.RotationTimer = self:ScheduleRepeatingTimer('InvokeNextSpell', self.db.profile._Intervals);
end

function ConRO:DisableRotation()
	if not self.rotationEnabled then
		return;
	end
--self:Print(self.Colors.Success .. 'Disabled Rotation.');
	self:DisableRotationTimer();
	self:DestroyDamageOverlays();
	self:DestroyCoolDownOverlays();
	self.Spell = nil;
	self.rotationEnabled = false;
end

function ConRO:DisableRotationTimer()
	if self.RotationTimer then
		self:CancelTimer(self.RotationTimer);
	end
end

function ConRO:OnEnable()
	self:RegisterEvent('PLAYER_TARGET_CHANGED');
	self:RegisterEvent('PLAYER_TALENT_UPDATE');
	self:RegisterEvent('ACTIONBAR_SLOT_CHANGED');
	self:RegisterEvent('PLAYER_REGEN_DISABLED');
	self:RegisterEvent('PLAYER_REGEN_ENABLED');	
	self:RegisterEvent('PLAYER_ENTERING_WORLD');
	self:RegisterEvent('UPDATE_SHAPESHIFT_FORM');
	self:RegisterEvent('UPDATE_STEALTH');
	
	self:RegisterEvent('ACTIONBAR_HIDEGRID');
	self:RegisterEvent('ACTIONBAR_PAGE_CHANGED');
	self:RegisterEvent('LEARNED_SPELL_IN_TAB');
	self:RegisterEvent('CHARACTER_POINTS_CHANGED');
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED');
	self:RegisterEvent('UPDATE_MACROS');
	self:RegisterEvent('VEHICLE_UPDATE');

	self:RegisterEvent('UNIT_ENTERED_VEHICLE');
	self:RegisterEvent('UNIT_EXITED_VEHICLE');
	self:RegisterEvent('PLAYER_CONTROL_LOST');
	self:RegisterEvent('PLAYER_CONTROL_GAINED');	

	self:RegisterEvent('PET_BATTLE_OPENING_START');
	self:RegisterEvent('PET_BATTLE_OVER');

	self:Print(self.Colors.Info .. 'Initialized');
end

function ConRO:PLAYER_TALENT_UPDATE()
--self:Print(self.Colors.Success .. 'Talent');
	self:DisableRotation();
	self:LoadModule();
	self:EnableRotation();
	
	if ConRO:HealSpec() then
		ConROWindow:Hide();
	elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
		ConROWindow:Show();
	else
		ConROWindow:Hide();	
	end
end

function ConRO:ACTIONBAR_HIDEGRID()
	if self.rotationEnabled then
		if self.fetchTimer then
			self:CancelTimer(self.fetchTimer);
		end
		self.fetchTimer = self:ScheduleTimer('Fetch', 0.5);
	end

	self:DestroyCoolDownOverlays();
end

function ConRO:UNIT_ENTERED_VEHICLE(event, unit)
--	self:Print(self.Colors.Success .. 'Vehicle!');
	if unit == 'player' and self.ModuleLoaded then
		self:DisableRotation();
	end
end

function ConRO:UNIT_EXITED_VEHICLE(event, unit)
--self:Print(self.Colors.Success .. 'Vehicle!');
	if unit == 'player' then
		self:DisableRotation();
		self:EnableRotation();
	end
end

function ConRO:PET_BATTLE_OPENING_START()
--	self:Print(self.Colors.Success .. 'Pet Battle Started!');

	self:DisableRotation();
	ConROWindow:Hide();
end

function ConRO:PET_BATTLE_OVER()
--	self:Print(self.Colors.Success .. 'Pet Battle Over!');

	self:DisableRotation();
	self:EnableRotation();

	if ConRO.db.profile.enableWindow and (ConRO.db.profile.combatWindow or ConRO:HealSpec()) and ConRO:TarHostile() then
		ConROWindow:Show();	
	elseif ConRO.db.profile.enableWindow and not (ConRO.db.profile.combatWindow or ConRO:HealSpec()) then
		ConROWindow:Show();		
	else
		ConROWindow:Hide();			
	end
	
end

function ConRO:PLAYER_CONTROL_LOST()
--	self:Print(self.Colors.Success .. 'Lost Control!');
		self:DisableRotation();
end

function ConRO:PLAYER_CONTROL_GAINED()
	if not C_PetBattles.IsInBattle() then
--		self:Print(self.Colors.Success .. 'Control Gained!');

		self:DisableRotation();
		self:EnableRotation();
	end
end

function ConRO:PLAYER_ENTERING_WORLD()
	self:UpdateButtonGlow();
	if not self.rotationEnabled then
		self:Print(self.Colors.Success .. 'Auto enable on login!');
		self:Print(self.Colors.Info .. 'Loading class module');
		self:LoadModule();
		self:EnableRotation();
	end
end

function ConRO:PLAYER_TARGET_CHANGED()
--	self:Print(self.Colors.Success .. 'Target Changed!');
	
	if self.rotationEnabled then
		if (UnitIsFriend('player', 'target')) then
			return;
		else
			self:InvokeNextSpell();
		end

		if ConRO.db.profile.enableWindow and (ConRO.db.profile.combatWindow or ConRO:HealSpec()) and ConRO:TarHostile() then
			ConROWindow:Show();	
		elseif ConRO.db.profile.enableWindow and not (ConRO.db.profile.combatWindow or ConRO:HealSpec()) then
			ConROWindow:Show();		
		else
			ConROWindow:Hide();			
		end
		
	end
end

function ConRO:PLAYER_REGEN_DISABLED()
	if not self.rotationEnabled and not UnitHasVehicleUI("player") then
		self:Print(self.Colors.Success .. 'Auto enable on combat!');
		self:Print(self.Colors.Info .. 'Loading class module');
		self:LoadModule();
		self:EnableRotation();
	end
end

function ConRO:ButtonFetch()
	if self.rotationEnabled then
		if self.fetchTimer then
			self:CancelTimer(self.fetchTimer);
		end
		self.fetchTimer = self:ScheduleTimer('Fetch', 0.5);
	end
end

ConRO.ACTIONBAR_SLOT_CHANGED = ConRO.ButtonFetch;
ConRO.PLAYER_REGEN_ENABLED = ConRO.ButtonFetch;
ConRO.ACTIONBAR_PAGE_CHANGED = ConRO.ButtonFetch;
ConRO.UPDATE_SHAPESHIFT_FORM = ConRO.ButtonFetch;
ConRO.UPDATE_STEALTH = ConRO.ButtonFetch;
ConRO.LEARNED_SPELL_IN_TAB = ConRO.ButtonFetch;
ConRO.CHARACTER_POINTS_CHANGED = ConRO.ButtonFetch;
ConRO.PLAYER_SPECIALIZATION_CHANGED = ConRO.ButtonFetch;
ConRO.ACTIVE_TALENT_GROUP_CHANGED = ConRO.ButtonFetch;
ConRO.UPDATE_MACROS = ConRO.ButtonFetch;
ConRO.VEHICLE_UPDATE = ConRO.ButtonFetch;

function ConRO:InvokeNextSpell()
	local oldSkill = self.Spell;

	local timeShift, currentSpell, gcd = ConRO:EndCast();
	
	self.Spell = self:NextSpell(timeShift, currentSpell, gcd, self.PlayerTalents, self.PvPTalents);
--	ConRO:UpdateRotation();
--	ConRO:UpdateButtonGlow();
	local spellName, _, spellTexture = GetSpellInfo(self.Spell);

	if (oldSkill ~= self.Spell or oldSkill == nil) and self.Spell ~= nil then
		self:GlowNextSpell(self.Spell);
		ConROWindow.fontkey:SetText(ConRO:FindKeybinding(self.Spell));
		if spellName ~= nil then
			ConROWindow.texture:SetTexture(spellTexture);
			ConROWindow.font:SetText(spellName);
		else
			local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(self.Spell);
			ConROWindow.texture:SetTexture(itemTexture);
			ConROWindow.font:SetText(itemName);
		end
	end
	
	if self.Spell == nil and oldSkill ~= nil then
		self:GlowClear();
		ConROWindow.texture:SetTexture('Interface\\AddOns\\ConRO\\images\\Bigskull');
		ConROWindow.font:SetText(" ");
		ConROWindow.fontkey:SetText(" ");
	end
end

function ConRO:LoadModule()
	local _, _, classId = UnitClass('player');
	
	if self.Classes[classId] == nil then
		self:Print(self.Colors.Error, 'Invalid player class, please contact author of addon.');
		return;
	end

	local module = 'ConRO_' .. self.Classes[classId];
	local _, _, _, loadable, reason = GetAddOnInfo(module);
	
	if IsAddOnLoaded(module) then
		local mode = ConRO:CheckSpecialization();
		
		self:EnableRotationModule(mode);
		return;
	end

	if reason == 'MISSING' or reason == 'DISABLED' then
		self:Print(self.Colors.Error .. 'Could not find class module ' .. module .. ', reason: ' .. reason);
		return;
	end

	LoadAddOn(module)

	local mode = ConRO:CheckSpecialization();

	self:EnableRotationModule(mode);
	self:Print(self.Colors[classId] .. self.Description);

	self:Print(self.Colors.Info .. 'Finished Loading class module');
	self.ModuleLoaded = true;
end

function ConRO:CheckSpecialization()
	local mode = GetSpecialization();
	local _Player_Level = UnitLevel("player");
		if _Player_Level <= 9 then
			mode = 0;
		end
		if mode == nil then
			mode = 0;		
		elseif mode >= 5 then
			mode = 0;		
		end
		
	return mode;
end

function ConRO:HealSpec()
	local _, _, classId = UnitClass('player');
	local specId = ConRO:CheckSpecialization();
	--[[[1] = 'Warrior',
		[2] = 'Paladin',
		[3] = 'Hunter',
		[4] = 'Rogue',
		[5] = 'Priest',
		[6] = 'DeathKnight',
		[7] = 'Shaman',
		[8] = 'Mage',
		[9] = 'Warlock',
		[10] = 'Monk',
		[11] = 'Druid',
		[12] = 'DemonHunter',]]
		
	if (classId == 2 and specId == 1) or
	(classId == 5 and specId == 2) or
	(classId == 7 and specId == 3) or
	(classId == 10 and specId == 2) or
	(classId == 11 and specId == 4)	then
		return true;
	end
	return false;
end

function ConRO:MeleeSpec()
	local _, _, classId = UnitClass('player');
	local specId = ConRO:CheckSpecialization();
	--[[[1] = 'Warrior',
		[2] = 'Paladin',
		[3] = 'Hunter',
		[4] = 'Rogue',
		[5] = 'Priest',
		[6] = 'DeathKnight',
		[7] = 'Shaman',
		[8] = 'Mage',
		[9] = 'Warlock',
		[10] = 'Monk',
		[11] = 'Druid',
		[12] = 'DemonHunter',]]
		
	if classId == 1 or classId == 2 or (classId == 3 and specId == 3) or classId == 4 or classId == 6 or (classId == 7 and specId == 2) or classId == 10 or (classId == 11 and (specId == 2 or specId == 3)) or classId == 12 then
		return true;
	end
	return false;
end