local defaults =
{
	dir = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\natural selection 2\\";
	runasmod = true;
	modroot = "output";
    args = "";
}
	

function ns2config( key )
	if ide.config.ns2 and ide.config.ns2[key] ~= nil then
		return ide.config.ns2[key]
	end
	return defaults[key]
end


local interpreter = {
  name = "NS2",
  description = "Natural Selection 2",
  api = {"baselib", "sample"},
  frun = function(self,wfilename,rundebug)	  
	local ns2dir = ns2config 'dir'
	local workDir
	local args = ""
	if ns2config 'runasmod' then
		workDir = MergeFullPath(ide:GetProject(), ns2config 'modroot' )
		if not wx.wxDirExists( workDir ) then
			workDir = string.sub( ide:GetProject(), 1, -2 )
		end
		args = string.format( '-game "%s" %s', workDir, ns2config 'args' )
		CommandLineRun(	'"'.. ns2dir .. 'ns2.exe" '..args, ns2dir, true, false)
	else
		workDir = string.sub( ide:GetProject(), 1, -2 )
        
        do
            DisplayOutputLn( MergeFullPath( workDir, "directories.txt" ) )
            local f = io.open( MergeFullPath( workDir, "directories.txt" ), "w+" )
            f:write( ns2dir )
            f:close()
        end
        
		args = string.format( '%s', ns2config 'args' )
		CommandLineRun(	'"'.. ns2dir .. 'ns2.exe" '..args, workDir, true, false)
	end
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