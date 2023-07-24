if NSSVC.Options.simple_chat == true then
	Hooks:Add("LocalizationManagerPostInit", "vote", function(loc)
		LocalizationManager:add_localized_strings({
			menu_chat_preplanning_vote_on_plan = "$name; | $type;" -- $name voted on the $plan: $type
		})
	end)
end