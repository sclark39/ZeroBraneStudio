local IMG_DIRECTORY = 0

 return
 {
	name = "Filetree Whitespace Select",
	description = "Allow clicking next to an item's name to select it",
	author = "sclark39",
	version = 0.1, 
	onFiletreeLDown = 
		function(self, tree, event, item_id ) 
			local selectmask =
				wx.wxTREE_HITTEST_ONITEMRIGHT +
				wx.wxTREE_HITTEST_ONITEMLABEL +
				wx.wxTREE_HITTEST_ONITEMINDENT
			
			local expanddirmask = 
				wx.wxTREE_HITTEST_ONITEMINDENT						
				
			local mask = tree:GetItemImage(item_id) == IMG_DIRECTORY and dirmask or filemask		
			local item_id, flags = tree:HitTest(event:GetPosition())
			
			if item_id then				
				if tree:GetItemImage(item_id) == IMG_DIRECTORY then
					if bit.band(flags, expanddirmask) > 0 then
						tree:Toggle(item_id)
						tree:SelectItem(item_id)
						return false
					end
				end
														
				if bit.band(flags, selectmask) > 0 then
					tree:SelectItem(item_id)
					tree:SetFocus()
					return false
				end
			end
			
			event:Skip()
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
