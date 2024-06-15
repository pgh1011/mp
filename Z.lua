local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local gPlayers = game:GetService("Players")

local HWID = RbxAnalyticsService:GetClientId()
local plr = gPlayers.LocalPlayer
local name = plr.Name
local userid = plr.UserId
local serverid = game.JobId

local httprequest = (syn and syn.request)
	or http and http.request
	or http_request
	or (delta and delta.request)
	or request

local function sendInfoMessage(massage)
	local webhookUrl = "https://discord.com/api/webhooks/1218190317526712420/s_5gw2LlXDrjNUF20CoNmlWQzlErqPc5u2sBkdLxcbY-_-h23RRawWI2gDnja-Rz9g3x"

	local embedMessage = {
		embeds = {{
			title = massage,
			fields = {
				{ name = "Name", value = name, inline = true },
			},
			color = 0x00FF00 
		}}
	}

	httprequest({
		Url = webhookUrl,
		Method = "POST",
		Headers = { ["content-type"] = "application/json" },
		Body = HttpService:JSONEncode(embedMessage)
	})
end

local function run()
	local function partMatchesProximityPrompt(part, objectText)
		local prompt = part:FindFirstChildOfClass("ProximityPrompt")
		return prompt and prompt.ObjectText == objectText
	end
	local HttpService = game:GetService("HttpService")
	local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
	local HWID = RbxAnalyticsService:GetClientId()
	
	local plr = gPlayers.LocalPlayer
	local name = plr.Name
	local userid = plr.UserId
	local serverid = game.JobId
	local httprequest = (syn and syn.request)
		or http and http.request
		or http_request
		or (delta and delta.request)
		or request

	local function getitem(names)
		for i = 1 , 20 do
			wait(0.5)
			fireproximityprompt(names)
		end
	end
	local function teleport()
		HttpService = game:GetService("HttpService")
		PlaceId, JobId = game.PlaceId, game.JobId
		httprequest = (syn and syn.request) or (http and http.request) or http_request or (delta and delta.request) or request
		TeleportService = game:GetService("TeleportService")

		if httprequest then
			local servers = {}
			local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", PlaceId)})
			local body = HttpService:JSONDecode(req.Body)
			if body and body.data then
				for i, v in next, body.data do
					if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
						table.insert(servers, 1, v.id)
					end
				end
			end
			if #servers > 0 then
				TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], gPlayers.LocalPlayer)
			else

			end
		end
	end
	local function findMatchingModelWithPrompt(objectText)
		for _, model in pairs(workspace.Game.Entities.ItemPickup:GetChildren()) do
			if model:IsA("Model") then
				local matchingPart = nil
				for _, part in pairs(model:GetDescendants()) do
					if part:IsA("Part") or part:IsA("MeshPart") then
						if partMatchesProximityPrompt(part, objectText) then
							matchingPart = part
							break
						end
					end
				end
				if matchingPart then
					return model, matchingPart
				end
			end
		end
		return nil, nil
	end

	local objectText = "Money Printer"

	while true do
		local matchingModel, matchingPart = findMatchingModelWithPrompt(objectText)
		if matchingModel and matchingPart then
			local teleportPosition = matchingPart.Position
			local player = gPlayers.LocalPlayer
			local character = player.Character
			local humanoid = character:WaitForChild("Humanoid")
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local prompt = matchingPart:FindFirstChildOfClass("ProximityPrompt")

			if humanoidRootPart and prompt then

				local moveDirection = Vector3.new(0, 0, 1)
				local moveSpeed = 16 
				humanoid:Move(moveDirection * moveSpeed) 
				humanoidRootPart.CFrame = CFrame.new(teleportPosition)

				getitem(prompt)
			end
			wait(5)
			sendInfoMessage("머프 찾음 ㄷㄷ")
			teleport()
		else
			teleport()
			print("Matching model or part with 'Money Printer' ProximityPrompt not found.")
		end
		wait(0.1)
	end

end
run()
