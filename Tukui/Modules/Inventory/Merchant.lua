local T, C, L = unpack((select(2, ...)))

local Inventory = T["Inventory"]
local Merchant = CreateFrame("Frame")
local strmatch = string.match
local BlizzardMerchantClick = MerchantItemButton_OnModifiedClick
local Popups = T.Popups
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemLink = C_Container and C_Container.GetContainerItemLink or GetContainerItemLink
local GetContainerItemID = C_Container and C_Container.GetContainerItemID or GetContainerItemID
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem

function Merchant:SellJunk()
	local Cost = 0
	
	for Bag = 0, 4 do
		for Slot = 1, GetContainerNumSlots(Bag) do
			local Link, ID = GetContainerItemLink(Bag, Slot), GetContainerItemID(Bag, Slot)

			if (Link and ID and type(Link) == "string") then
				local Price = 0
				local Mult1 = select(11, GetItemInfo(Link))
				local Mult2
				
				if T.Retail or T.MoP then
					local Table = GetContainerItemInfo(Bag, Slot)
					
					if Table and Table.stackCount then
						Mult2 = Table.stackCount
					end
				else
					Mult2 = select(2, GetContainerItemInfo(Bag, Slot))
				end

				if (Mult1 and Mult2) then
					Price = Mult1 * Mult2
				end

				if (select(3, GetItemInfo(Link)) == 0 and Price > 0) then
					UseContainerItem(Bag, Slot)
					PickupMerchantItem()
					Cost = Cost + Price
				end
			end
		end
	end

	if (Cost > 0) then
		local Gold, Silver, Copper = math.floor(Cost / 10000) or 0, math.floor((Cost % 10000) / 100) or 0, Cost % 100

		DEFAULT_CHAT_FRAME:AddMessage(L.Merchant.SoldTrash.." |cffffffff"..Gold..L.DataText.GoldShort.." |cffffffff"..Silver..L.DataText.SilverShort.." |cffffffff"..Copper..L.DataText.CopperShort..".", 0255, 255, 0)
	end
end

function Merchant:AutoRepair()
	if (CanMerchantRepair()) then
		local Cost, Possible = GetRepairAllCost()

		if (Cost > 0) then
			if Possible then
				RepairAllItems()

				local Copper = Cost % 100
				local Silver = math.floor((Cost % 10000) / 100)
				local Gold = math.floor(Cost / 10000)
				DEFAULT_CHAT_FRAME:AddMessage(L.Merchant.RepairCost.." |cffffffff"..Gold..L.DataText.GoldShort.." |cffffffff"..Silver..L.DataText.SilverShort.." |cffffffff"..Copper..L.DataText.CopperShort..".", 255, 255, 0)
			else
				DEFAULT_CHAT_FRAME:AddMessage(L.Merchant.NotEnoughMoney, 255, 0, 0)
			end
		end
	end
end

function Merchant:OnEvent(event)
	if C.Misc.AutoSellJunk then
		Merchant:SellJunk()
	end

	if C.Misc.AutoRepair then
		Merchant:AutoRepair()
	end
end

function Merchant:MerchantClick(...)
	if (IsAltKeyDown()) then
		local MaxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))

		if (MaxStack and MaxStack > 1) then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end

	BlizzardMerchantClick(self, ...)
end

function Merchant:Enable()
	self:RegisterEvent("MERCHANT_SHOW")
	self:SetScript("OnEvent", self.OnEvent)

	MerchantItemButton_OnModifiedClick = self.MerchantClick
end

function Merchant:Disable()
	self:UnregisterEvent("MERCHANT_SHOW")
	self:SetScript("OnEvent", nil)

	MerchantItemButton_OnModifiedClick = BlizzardMerchantClick
end

Inventory.Merchant = Merchant
