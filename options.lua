_G.NSSVC = _G.NSSVC or {}
NSSVC.Mod_Path = ModPath
NSSVC.Save_Path = SavePath .. "No_spam_and_simple.txt"
NSSVC.Options = {}

function NSSVC:save()
    local file = io.open(self.Save_Path, "w+")
    if file then
		file:write(json.encode(self.Options))
		file:close()
    end
end

function NSSVC:load()
    local file = io.open(self.Save_Path, "r")
    local data
    if file then
		data = json.decode(file:read("*all"))
		file:close()
    end
    for k, v in pairs(data or {}) do
		self.Options [k] = v
    end
end

if not NSSVC.default then
	NSSVC:load()
	if NSSVC.Options.no_spam == nil then
		NSSVC.Options.no_spam = true
		NSSVC:save()
	end
	if NSSVC.Options.simple_chat == nil then
		NSSVC.Options.simple_chat = true
		NSSVC:save()
	end
	NSSVC:load()
	NSSVC.default = true
end

if RequiredScript == "lib/managers/menumanager" then

	Hooks:Add("LocalizationManagerPostInit", "NSSVC_loc", function(loc)
		loc:load_localization_file(NSSVC.Mod_Path .. "loc/english.txt")
		for _, filename in pairs(file.GetFiles(NSSVC.Mod_Path .. "loc/")) do
			local str = filename:match('^(.*).txt$')
			if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
				loc:load_localization_file(NSSVC.Mod_Path .. "loc/" .. filename)
				break
			end
		end
	end)

	local menu_id_main = "NSSVC.Options"
	Hooks:Add("MenuManagerSetupCustomMenus", "NSSVC_Options", function(menu_manager, nodes)
		MenuHelper:NewMenu(menu_id_main)
	end)

	Hooks:Add("MenuManagerPopulateCustomMenus", "NSSVC_Options", function(menu_manager, nodes)
		NSSVC:load()
		
		MenuCallbackHandler.NSSVC_toggle = function(self, item)
			NSSVC.Options [item:name()] = (item:value() == "on")
			NSSVC:save()
		end

		MenuHelper:AddToggle({
			id = "no_spam",
			title = "NSSVC_no_spam_title",
			desc = "NSSVC_no_spam_desc",
			callback = "NSSVC_toggle",
			value = NSSVC.Options.no_spam,
			menu_id = menu_id_main,
			priority = 2
		})
		MenuHelper:AddToggle({
			id = "simple_chat",
			title = "NSSVC_simple_chat_title",
			desc = "NSSVC_simple_chat_desc",
			callback = "NSSVC_toggle",
			value = NSSVC.Options.simple_chat,
			menu_id = menu_id_main,
			priority = 1
		})
	end)

	Hooks:Add("MenuManagerBuildCustomMenus", "NSSVC_Options", function(menu_manager, nodes)
		nodes[menu_id_main] = MenuHelper:BuildMenu("NSSVC.Options", { area_bg = "half" })
		MenuHelper:AddMenuItem(nodes["blt_options"], menu_id_main, "NSSVC_menu_main_title", "NSSVC_menu_main_desc")
	end)

end