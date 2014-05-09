local interpreter = {
  name = "NS2",
  description = "Natural Selection 2",
  api = {"baselib", "sample"},
  frun = function(self,wfilename,rundebug)
	local NS2Dir =  "C:\\Program Files (x86)\\Steam\\steamapps\\common\\natural selection 2\\"
	--local workDir = self:fworkdir(wfilename)
	local workDir = MergeFullPath(ide:GetProject(), "output")
	if not wx.wxDirExists( workDir ) then
		workDir = string.sub( ide:GetProject(), 1, -2 )
	end
    CommandLineRun(	'"'.. NS2Dir .. 'ns2.exe" -game "' ..workDir.. '"', NS2Dir, true, false)
  end,
  fprojdir = function(self,wfilename)  
    return wfilename:GetPath(wx.wxPATH_GET_VOLUME)
  end,
  fworkdir = function (self,wfilename)
    return ide.config.path.projectdir or wfilename:GetPath(wx.wxPATH_GET_VOLUME)
  end,  
  hasdebugger = true,
  skipcompile = true,  
}

return {
  name = "NS2 Interpreter",
  description = "Lets do this...",
  author = "sclark39",
  version = 0.1,

  onRegister = function(self)
    -- add interpreter with name "sample"
    ide:AddInterpreter("ns2", interpreter)
  end,

  onUnRegister = function(self)
    -- remove interpreter with name "sample"
    ide:RemoveInterpreter("ns2")
  end,
}