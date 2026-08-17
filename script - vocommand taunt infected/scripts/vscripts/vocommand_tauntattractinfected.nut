// L4D2 - TAUNTING AND LAUGHING ATTRACTS INFECTED

if (!("vocommand_tauntattractinfected" in getroottable()))
{
	::vocommand_tauntattractinfected <-
	{
		Settings = {
			vocal_range_taunt = 500
			vocal_range_laugh = 250
			vocal_range_scream = 1000
		}
		
		LastScenePlayed = {}
		ConfigPath = "vocalizercommands/taunt_infected.txt"
		IsLoopRunning = false
		
		function GenerateConfigFile()
		{
			if (FileToString(this.ConfigPath)) return;

			local content = "// Vocalizer Command Configuration\n";
			foreach (key, value in this.Settings)
			{
				content += key + " " + value + "\n";
			}
			
			StringToFile(this.ConfigPath, content);
			printl("Vocalizer: Created config at ems/" + this.ConfigPath);	
		}

		function LoadConfigFile()
		{
			local files = FileToString(this.ConfigPath);
			if(!files) return;

			local lines = split(files, "\n\r");
			foreach(line in lines)
			{
				line = strip(line);
				if(line == "" || line.slice(0, 2) == "//") continue;

				local pair = split(line, " ");
				if(pair.len() >= 2)
				{
					local key = strip(pair[0]);
					local val = strip(pair[1]);

					if(key in this.Settings)
					{
						this.Settings[key] = val.tointeger();
						printl("Vocalizer: " + key + " set to " + val);
					}
				}
			}
		}

		function OnTalking(player, sceneFile)
		{
			local scene = sceneFile.tolower();
			local rangeToUse = 0;

			if (scene.find("taunt") != null)
				rangeToUse = this.Settings.vocal_range_taunt;
			else if (scene.find("laugh") != null)
				rangeToUse = this.Settings.vocal_range_laugh;
			else if (scene.find("fall") != null || scene.find("deathscream") != null)
				rangeToUse = this.Settings.vocal_range_scream;

			if (rangeToUse > 0)
			{
				RushVictim(player, rangeToUse);
			}
		}

		function WatchPlayers()
		{
			local player = null;
			while (player = Entities.FindByClassname(player, "player"))
			{
				if (player.IsValid() && player.IsSurvivor() && !player.IsDead() && !player.IsIncapacitated())
				{
					local sceneEnt = player.GetCurrentScene();
					if (sceneEnt)
					{
						local entID = player.GetEntityIndex().tostring();
						local currentScene = NetProps.GetPropString(sceneEnt, "m_iszSceneFile");

						if (!(entID in LastScenePlayed) || LastScenePlayed[entID] != currentScene)
						{
							this.OnTalking(player, currentScene);
							LastScenePlayed[entID] <- currentScene;
						}
					}
					else
					{
						local entID = player.GetEntityIndex().tostring();
						if (entID in LastScenePlayed) LastScenePlayed[entID] = "";
					}
				}
			}
		}

		function OnGameEvent_round_start(params)
		{
			this.GenerateConfigFile();
			this.LoadConfigFile();

			if (!this.IsLoopRunning)
			{
				g_MapScript.ScriptedMode_AddUpdate(this.WatchPlayers.bindenv(this));
				this.IsLoopRunning = true;
				printl("Vocalizer Loop Started.");
			}
		}
		function OnGameEvent_player_say(params)
		{
			local player = GetPlayerFromUserID(params.userid);
			if (!player || player.IsDead() || !player.IsSurvivor()) return;

			local chat = params.text.tolower();
			
			if (chat.find("taunt,") == 0)
			{
				local parts = split(chat, ",");
				if (parts.len() >= 2)
				{
					local rangeStr = strip(parts[1]);
					
					try {
						local rangeValue = rangeStr.tointeger();
						if (rangeValue > 0)
						{
							RushVictim(player, rangeValue);
							// Optional: printl("Manual taunt: " + player.GetPlayerName() + " attracted infected within " + rangeValue + " units.");
						}
					} 
					catch(e) {
						return;
					}
				}
			}
		}
	}
}

__CollectGameEventCallbacks(vocommand_tauntattractinfected);
printl("--- TAUNT AGGRO SCRIPT LOADED SUCCESSFULLY ---");