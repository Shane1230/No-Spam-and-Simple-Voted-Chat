if NSSVC.Options.no_spam == true then

	function PrePlanningManager:mass_vote_on_plan(type, id)
		if Network:is_server() then
			self:server_mass_vote_on_plan(type, id)
		else
			managers.network:session():send_to_host("reserve_preplanning", type, id, 3)
		end
	end

	function PrePlanningManager:server_mass_vote_on_plan(type, id)
		for _, peer in pairs(managers.network:session():all_peers()) do
			self:no_spam_server(type, id, peer:id())
		end
	end

	function PrePlanningManager:no_spam_server(type, id, peer_id)
		local index = self:get_mission_element_index(id, type)
		local plan = tweak_data:get_raw_value("preplanning", "types", type, "plan")
		local plan_tweak_data = tweak_data:get_raw_value("preplanning", "plans", plan)

		if plan_tweak_data and self:can_vote_on_plan(type, peer_id) then
			self._players_votes[peer_id] = self._players_votes[peer_id] or {}
			self._players_votes[peer_id][plan] = {
				type,
				index
			}

			managers.network:session():send_to_peers_loaded("preplanning_reserved", type, id, peer_id, 2)
			print("[VOTED]", "plan", plan, "type", type, "peer_id", peer_id)

			self._saved_majority_votes = nil
			self._saved_vote_council = nil

			managers.menu_component:update_preplanning_element(nil, nil)
		end
	end

	function PrePlanningManager:_server_vote_on_plan(type, id, peer_id)
		local index = self:get_mission_element_index(id, type)
		local plan = tweak_data:get_raw_value("preplanning", "types", type, "plan")
		local plan_tweak_data = tweak_data:get_raw_value("preplanning", "plans", plan)

		if plan_tweak_data and self:can_vote_on_plan(type, peer_id) then
			self._players_votes[peer_id] = self._players_votes[peer_id] or {}
			self._players_votes[peer_id][plan] = {
				type,
				index
			}

			managers.network:session():send_to_peers_loaded("preplanning_reserved", type, id, peer_id, 2)
			print("[VOTED]", "plan", plan, "type", type, "peer_id", peer_id)

			self._saved_majority_votes = nil
			self._saved_vote_council = nil

			managers.menu_component:update_preplanning_element(nil, nil)
			
			if not self:get_can_rebuy_assets() then
				local peer = managers.network:session() and managers.network:session():peer(peer_id)

				if peer then
					local plan_text_id = self:get_category_name(plan_tweak_data.category)
					local type_text_id = self:get_type_name(type)
					local mission_elements = self:get_mission_elements_by_type(type)

					if mission_elements and #mission_elements > 1 then
						type_text_id = string.format("%s - %s", type_text_id, self:get_element_name_by_type_index(type, index))
					end

					plan_text_id = utf8.to_upper(plan_text_id)
					type_text_id = utf8.to_upper(type_text_id)

					managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("menu_chat_preplanning_vote_on_plan", {
						name = peer:name(),
						plan = plan_text_id,
						type = type_text_id
					}))
				end
			end
			
		end
	end

	function PrePlanningManager:client_vote_on_plan(type, id, peer_id)
		local index = self:get_mission_element_index(id, type)
		local plan = tweak_data:get_raw_value("preplanning", "types", type, "plan")
		local plan_tweak_data = tweak_data:get_raw_value("preplanning", "plans", plan)

		if plan_tweak_data then
			self._players_votes[peer_id] = self._players_votes[peer_id] or {}
			self._players_votes[peer_id][plan] = {
				type,
				index
			}

			print("[VOTED]", "plan", plan, "type", type, "peer_id", peer_id)

			self._saved_majority_votes = nil
			self._saved_vote_council = nil

			managers.menu_component:update_preplanning_element(nil, nil)
			
			if not self:get_can_rebuy_assets() then
				local peer = managers.network:session() and managers.network:session():peer(peer_id)

				if peer then
					local plan_text_id = self:get_category_name(plan_tweak_data.category)
					local type_text_id = self:get_type_name(type)
					local mission_elements = self:get_mission_elements_by_type(type)

					if mission_elements and #mission_elements > 1 then
						type_text_id = string.format("%s - %s", type_text_id, self:get_element_name_by_type_index(type, index))
					end

					plan_text_id = utf8.to_upper(plan_text_id)
					type_text_id = utf8.to_upper(type_text_id)

					managers.chat:feed_system_message(ChatManager.GAME, managers.localization:text("menu_chat_preplanning_vote_on_plan", {
						name = peer:name(),
						plan = plan_text_id,
						type = type_text_id
					}))
				end
			end
		end
	end
	
end