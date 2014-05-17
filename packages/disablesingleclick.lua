local IMG_DIRECTORY = 0

 return
 {
	name = "Filetree Whitespace Select",
	description = "Allow clicking next to an item's name to select it",
	author = "sclark39",
	version = 0.1, 
	onFiletreeLDown = 
		function(self, tree, event, item_id ) 
			--local mask = wx.wxTREE_HITTEST_ONITEMINDENT
			--	+ wx.wxTREE_HITTEST_ONITEMICON + wx.wxTREE_HITTEST_ONITEMRIGHT
			--local item_id, flags = tree:HitTest(event:GetPosition())
			if item_id then -- and bit.band(flags, mask) > 0 then
				tree:SelectItem(item_id)
				tree:SetFocus()
			else  
			--	event:Skip()
			end
			return false
		end,
	onFiletreeLDClick = 
		function (self, tree, event, item_id)
			if tree:GetItemImage(item_id) == IMG_DIRECTORY then
				tree:Toggle(item_id)
				tree:SelectItem(item_id)
			else
				tree:ActivateItem(item_id)
			end
			return false
		end,
}
