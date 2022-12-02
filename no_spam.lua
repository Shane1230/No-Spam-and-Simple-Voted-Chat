function PrePlanningManager:mass_vote_on_plan(type, id)
	if Network:is_server() then
		self:server_mass_vote_on_plan(type, id)
	else
		self:client_mass_vote_on_plan(type, id)
	end
end

function PrePlanningManager:server_mass_vote_on_plan(type, id)
	for _, peer in pairs(managers.network:session():all_peers()) do
		self:no_spam_server(type, id, peer:id())
	end
end

function PrePlanningManager:client_mass_vote_on_plan(type, id)
	for _, peer in pairs(managers.network:session():all_peers()) do
		self:no_spam_client(type, id, peer:id())
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


function PrePlanningManager:no_spam_client(type, id, peer_id)
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
	end
end