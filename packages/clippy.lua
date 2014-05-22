local stack = {}
local kStackLimit = 10

local function SaveClip()
	local tdo = wx.wxTextDataObject("None")
	if wx.wxClipboard:Get():Open() then
		wx.wxClipboard:Get():GetData(tdo)
		wx.wxClipboard:Get():Close()
			
		local newclip = tdo:GetText()
		if newclip ~= "" then
			for i,oldclip in ipairs( stack ) do
				if newclip == oldclip then
					table.remove( stack, i )
					table.insert( stack, 1, newclip )
					stack[kStackLimit] = nil
					return
				end
			end
			table.insert( stack, 1, newclip )
			stack[kStackLimit] = nil
		end
	end
	
end
		
		
local function OpenClipList( editor )
	if editor:AutoCompActive() then
		editor:AutoCompCancel()
	end
	
	--if #stack == 0 then
	--	return
	--end
	
	editor:AutoCompSetSeparator(string.byte('\n'))
	editor:AutoCompSetTypeSeparator(0)
	
	local list, firstline, rem = {}
	for i,clip in ipairs(stack) do
		firstline, rem = string.match(clip,'([^\r\n]+)(.*)')
		if rem ~= "" then firstline = firstline .. "..." end
		list[#list+1] = i.."\t "..firstline
	end
	editor:UserListShow(2,table.concat(list,'\n')) 
	editor:AutoCompSelect( list[2] or "" )
	
	editor:AutoCompSetSeparator(string.byte(' '))
	editor:AutoCompSetTypeSeparator(string.byte('?'))
end


function PasteClip(i)
	local newclip = stack[i]
	local tdo = wx.wxTextDataObject(newclip)
	if wx.wxClipboard:Get():Open() then
		wx.wxClipboard:Get():SetData(tdo)
		wx.wxClipboard:Get():Close()
		
		if i ~= 1 then		
			table.remove( stack, i )
			table.insert( stack, 1, newclip )
			stack[kStackLimit] = nil
		end
		ide.frame:AddPendingEvent(wx.wxCommandEvent(wx.wxEVT_COMMAND_MENU_SELECTED, ID_PASTE))
		return true
	end
	return false
end
	
	

local function OnRegister()
	ID_CLIPPYSTACK = NewID()
	ide.frame:Connect( ID_CLIPPYSTACK, wx.wxEVT_COMMAND_MENU_SELECTED, 
		function( event )
			local editor = GetEditorWithFocus()
			
			-- if there is no editor, or if it's not the editor we care about,
			-- then allow normal processing to take place
			if editor == nil or
			 (editor:FindFocus() and editor:FindFocus():GetId() ~= editor:GetId()) or
			 editor:GetClassInfo():GetClassName() ~= 'wxStyledTextCtrl'
			then event:Skip(); return end
				
			OpenClipList(editor)
		end)	
end

local function OnEditCut( self, editor )
	if editor:GetSelectionStart() == editor:GetSelectionEnd()
	  then editor:LineCut() else editor:Cut() end
	SaveClip()	
	return false
end


local function OnEditCopy( self, editor )
	if editor:GetSelectionStart() == editor:GetSelectionEnd()
	  then editor:LineCopy() else editor:Copy() end
	SaveClip()
	return false
end

local function OnUserListSelection( self, event )
	if event:GetListType() == 2 then			
		local i = tonumber( event:GetText():sub(1,1) );
		PasteClip(i)
		return false
	end
end

local function AccumulateAcceleratorTable( self, tbl )
	tbl[#tbl+1] = wx.wxAcceleratorEntry(wx.wxACCEL_CTRL + wx.wxACCEL_SHIFT, ('V'):byte(), ID_CLIPPYSTACK )
end

return
{
	name = "Clippy",
	description = "Enables a stack-based clipboard which saves the last 10 entries",
	author = "sclark39",
	version = 0.1,
	onRegister = OnRegister,
	onEditCut = OnEditCut,
	onEditCopy = OnEditCopy,
	onUserListSelection = OnUserListSelection,
	AccumulateAcceleratorTable = AccumulateAcceleratorTable,
}
