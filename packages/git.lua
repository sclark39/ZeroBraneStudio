local P = 
{
	name = "Git Integration",
	description = "Add a menu with commonly used Git/Gitk/TortoiseGit commands",
	author = "sclark39",
	version = 0.1,
	dependencies = 0.60,
}


-- %tgit : path to TortoiseGitProc.exe
-- %gitk : path to gitk
-- %git  : path to git
-- %pr   : path of project root
-- %fp   : selected file's path

function P.onAppLoad(...)
	local frame = ide.frame
	local menuBar = frame.menuBar


	local exes = 
	{ 
		gitk = 'C:\\Windows\\System32\\cmd.exe /c start gitk',
		tgit = '"C:\\Program Files\\TortoiseGit\\bin\\TortoiseGitProc.exe"',
	}

	local gitCmdDef =
	{
		{ 'ID_GIT_DIFF', 	TR("&Diff"),		'%tgit /command:diff /path:"%fp"' 		},
		{ 'ID_GIT_REVERT', 	TR("&Revert"),		'%tgit /command:revert /path:"%fp"' 	},
		{ 'ID_GIT_CLEANUP', TR("&Cleanup"),		'%tgit /command:cleanup /path:"%pr"'	},
		{ 'ID_GIT_HISTORY', TR("&History"),		'%gitk "%fp"'							},
		{},
		{ 'ID_GIT_SWITCH',  TR("Switch"),		'%tgit /command:switch /path:"%pr"'		},
		{ 'ID_GIT_SHOWLOG', TR("Show &Log"),	'%tgit /command:log /path:"%pr"'		},
		{},
		{ 'ID_GIT_COMMIT', 	TR("&Commit"),		'%tgit /command:commit /path:"%pr"' 	},
		{ 'ID_GIT_SYNC', 	TR("&Sync"), 		'%tgit /command:sync /path:"%pr"' 		},
	}

	local gitCmds = {}
	local gitMenuDef = {}
	for i,v in ipairs(gitCmdDef) do
		if #v == 0 then
			gitMenuDef[i] = {}
		else
			local id = NewID()
			_G[v[1]] = id	
			gitCmds[id] = v[3]
			gitMenuDef[i] = { id, v[2]..KSC(id) }
		end
	end
		
	local gitMenu = wx.wxMenu( gitMenuDef )
	menuBar:Insert(3,gitMenu, TR("&Git"))

	for id,cmddef in pairs(gitCmds) do
	  frame:Connect(id, wx.wxEVT_COMMAND_MENU_SELECTED,
		function()
			
			local editor = GetEditor()
			local proj = ide:GetProject() or ""
			local doc = editor and ide.openDocuments[editor:GetId()]
		
			local targets = 
			{
				pr = proj or "",
				fp = doc and doc.filePath or ""
			}
			
			local cmd = cmddef
			for esub,epath in pairs(exes) do
				cmd = cmd:gsub( '%%'..esub, epath )
			end		
			for tsub,tpath in pairs(targets) do
				cmd = cmd:gsub('%%'..tsub, tpath )
			end
			local cwd = wx.wxGetCwd()
			wx.wxSetWorkingDirectory( targets.pr )
			--DisplayOutputLn( "Running '"..cmd.."'" )
			wx.wxExecute(cmd, wx.wxEXEC_ASYNC)
			wx.wxSetWorkingDirectory( cwd )
		end)
	end
end

return P
