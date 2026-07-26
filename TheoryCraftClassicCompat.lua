-- Compatibility helpers for the API namespace migration used by Classic Era
-- 1.15.9.  Keep these shims feature-detected so the addon can still load on
-- older Classic clients which provide the legacy globals.

local function PlayerSpellBank(bookType)
	if type(bookType) ~= "string" then
		return bookType
	end

	if Enum and Enum.SpellBookSpellBank then
		if bookType == "pet" then
			return Enum.SpellBookSpellBank.Pet
		end
		return Enum.SpellBookSpellBank.Player
	end

	return bookType
end

if not BOOKTYPE_SPELL and Enum and Enum.SpellBookSpellBank then
	BOOKTYPE_SPELL = Enum.SpellBookSpellBank.Player
end

if not BOOKTYPE_PET and Enum and Enum.SpellBookSpellBank then
	BOOKTYPE_PET = Enum.SpellBookSpellBank.Pet
end

if not GetAddOnMetadata and C_AddOns and C_AddOns.GetAddOnMetadata then
	GetAddOnMetadata = C_AddOns.GetAddOnMetadata
end

if not GetItemInfo and C_Item and C_Item.GetItemInfo then
	GetItemInfo = C_Item.GetItemInfo
end

if not GetItemStats and C_Item and C_Item.GetItemStats then
	GetItemStats = C_Item.GetItemStats
end

if not GetItemQualityColor and C_Item and C_Item.GetItemQualityColor then
	GetItemQualityColor = C_Item.GetItemQualityColor
end

if not GetSpellInfo and C_Spell and C_Spell.GetSpellInfo then
	function GetSpellInfo(spellIdentifier)
		if spellIdentifier == nil then return nil end
		local info = C_Spell.GetSpellInfo(spellIdentifier)
		if not info then return nil end
		return info.name, nil, info.iconID, info.castTime, info.minRange,
			info.maxRange, info.spellID, info.originalIconID
	end
end

if not GetSpellDescription and C_Spell and C_Spell.GetSpellDescription then
	GetSpellDescription = C_Spell.GetSpellDescription
end

if not GetSpellSubtext and C_Spell and C_Spell.GetSpellSubtext then
	GetSpellSubtext = C_Spell.GetSpellSubtext
end

if not GetSpellPowerCost and C_Spell and C_Spell.GetSpellPowerCost then
	GetSpellPowerCost = C_Spell.GetSpellPowerCost
end

if not GetNumSpellTabs and C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines then
	GetNumSpellTabs = C_SpellBook.GetNumSpellBookSkillLines
end

if not GetSpellTabInfo and C_SpellBook and C_SpellBook.GetSpellBookSkillLineInfo then
	function GetSpellTabInfo(index)
		local info = C_SpellBook.GetSpellBookSkillLineInfo(index)
		if not info then return nil end
		return info.name, info.iconID, info.itemIndexOffset,
			info.numSpellBookItems, info.isGuild, info.offSpecID,
			info.shouldHide, info.specID
	end
end

if not GetSpellBookItemName and C_SpellBook and C_SpellBook.GetSpellBookItemName then
	function GetSpellBookItemName(index, bookType)
		local spellBank = PlayerSpellBank(bookType)
		local name, subtext = C_SpellBook.GetSpellBookItemName(index, spellBank)
		if not name then return nil end

		local spellID
		if C_SpellBook.GetSpellBookItemInfo then
			local info = C_SpellBook.GetSpellBookItemInfo(index, spellBank)
			if info then
				spellID = info.spellID or info.actionID
				subtext = subtext or info.subName
			end
		end

		if (not subtext or subtext == "") and spellID
		   and C_Spell and C_Spell.GetSpellSubtext then
			subtext = C_Spell.GetSpellSubtext(spellID) or ""
		end
		return name, subtext or "", spellID
	end
end

if not UnitBuff and C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
	function UnitBuff(unitToken, index, filter)
		local auraData = C_UnitAuras.GetBuffDataByIndex(unitToken, index, filter)
		if not auraData then return nil end
		if AuraUtil and AuraUtil.UnpackAuraData then
			return AuraUtil.UnpackAuraData(auraData)
		end
		return auraData.name
	end
end

if not UnitDebuff and C_UnitAuras and C_UnitAuras.GetDebuffDataByIndex then
	function UnitDebuff(unitToken, index, filter)
		local auraData = C_UnitAuras.GetDebuffDataByIndex(unitToken, index, filter)
		if not auraData then return nil end
		if AuraUtil and AuraUtil.UnpackAuraData then
			return AuraUtil.UnpackAuraData(auraData)
		end
		return auraData.name
	end
end

if not UnitManaMax and UnitPowerMax then
	UnitManaMax = UnitPowerMax
end

if not gcinfo and collectgarbage then
	function gcinfo()
		return collectgarbage("count")
	end
end

-- GameTooltip:SetSpellBookItem was removed along with the legacy spellbook
-- API.  Resolve the slot to a spell ID and use the supported method instead.
function TheoryCraft_SetTooltipSpellBookItem(tooltip, index, bookType)
	if tooltip.SetSpellBookItem then
		tooltip:SetSpellBookItem(index, bookType)
		return true
	end

	local _, _, spellID = GetSpellBookItemName(index, bookType)
	if spellID and tooltip.SetSpellByID then
		tooltip:SetSpellByID(spellID)
		return true
	end

	return false
end
