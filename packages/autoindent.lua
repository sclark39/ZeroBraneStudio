local function CountIndent( editor, char )
  local spaces, pspaces, pdiff = {}, 0, 0
  for line = 0, math.min(100, editor:GetLineCount())-1 do
    local tspaces = #(editor:GetLine(line):match("^["..char.."]*"))
    local tdiff = math.abs(tspaces-pspaces)
    if tdiff > 0 then pdiff = tdiff end
    if pdiff > 0 and pdiff <= 8 then spaces[pdiff] = (spaces[pdiff] or 0) + 1 end
    pspaces = tspaces
  end

  local maxv, maxn = 0
  for n,v in pairs(spaces) do if v > maxv then maxn, maxv = n, v end end
  
  return maxn, maxv
end

return {
  name = "Auto-indent based on source code",
  description = "Sets editor indentation based on file text analysis.",
  author = "Paul Kulchenko",
  version = 0.1,

  onEditorLoad = function(self, editor)
	local numSpaces, numSpacesCount = CountIndent(editor, " ")
	local numTabs, numTabsCount = CountIndent(editor, "\t")
	
    if numTabsCount > numSpacesCount then		
      numSpaces = nil
	else
      numTabs = nil
	end
	
	local useTabs,indent
	if numSpaces then
      useTabs,indent = false, numSpaces or 2
	elseif numTabs then
      useTabs,indent = true, ide:GetConfig().editor.tabwidth or 2
	else
      useTabs,indent = ide:GetConfig().editor.usetabs or false, ide:GetConfig().editor.tabwidth or 2		
	end
    
    editor:SetUseTabs(useTabs)
    editor:SetIndent(indent)
    --DisplayOutputLn( "Auto-Indent Set To "..tostring(indent).." using "..(useTabs and "Tabs" or "Spaces") )
  end,
}
