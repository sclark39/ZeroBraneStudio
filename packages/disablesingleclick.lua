local IMG_DIRECTORY = 0

 return
 {
	name = "Filetree Whitespace Select",
	description = "Allow clicking next to an item's name to select it",
	author = "sclark39",
	version = 0.1, 
	onFiletreeLDown = 
		function(self, tree, event, item_id ) 
			if item_id then
			  tree:SelectItem(item_id)
			  tree:SetFocus()
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
