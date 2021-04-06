/// @decription scr_LoadGame
/// @param savefile
function scr_LoadGame() {

	var file = argument[0];

	global.currentPlayFile = file;

	// destroy these just in case
	instance_destroy(obj_Player);
	instance_destroy(obj_Camera);

	if(file_exists(scr_GetFileName(file)))
	{
		try
		{
			var _wrapper = scr_LoadJSONFromFile(scr_GetFileName(file));
			var _list = _wrapper[? "ROOT"];
	
			var _map = _list[| 0];
		
			var rm = _map[? "room"];
			room_goto(asset_get_index(rm));
		
			with(instance_create_layer(0,0,"Player",obj_Player))
			{
				x = _map[? "x"];
				y = _map[? "y"];
				
				water_init(0);
			
				energyMax = _map[? "energyMax"];
				energy = _map[? "energy"];
				missileMax = _map[? "missileMax"];
				missileStat = _map[? "missileStat"];
				superMissileMax = _map[? "superMissileMax"];
				superMissileStat = _map[? "superMissileStat"];
				powerBombMax = _map[? "powerBombMax"];
				powerBombStat = _map[? "powerBombStat"];

				for(var i = 0; i < array_length(suit); i++)
				{
					suit[i] = _map[? "suit"+string(i)];
				}
				for(var i = 0; i < array_length(hasSuit); i++)
				{
					hasSuit[i] = _map[? "hasSuit"+string(i)];
				}
	
				for(var i = 0; i < array_length(boots); i++)
				{
					boots[i] = _map[? "boots"+string(i)];
				}
				for(var i = 0; i < array_length(hasBoots); i++)
				{
					hasBoots[i] = _map[? "hasBoots"+string(i)];
				}
	
				for(var i = 0; i < array_length(misc); i++)
				{
					misc[i] = _map[? "misc"+string(i)];
				}
				for(var i = 0; i < array_length(hasMisc); i++)
				{
					hasMisc[i] = _map[? "hasMisc"+string(i)];
				}
	
				for(var i = 0; i < array_length(beam); i++)
				{
					beam[i] = _map[? "beam"+string(i)];
				}
				for(var i = 0; i < array_length(hasBeam); i++)
				{
					hasBeam[i] = _map[? "hasBeam"+string(i)];
				}
	
				for(var i = 0; i < array_length(item); i++)
				{
					item[i] = _map[? "item"+string(i)];
				}
				for(var i = 0; i < array_length(hasItem); i++)
				{
					//ds_map_add(_map, "hasItem"+string(i), hasItem[i]);
					hasItem[i] = _map[? "hasItem"+string(i)];
				}
			
				instance_create_layer(x-(global.resWidth/2),y-(global.resHeight/2),"Camera",obj_Camera);
			}
	
			var _map_map = _list[| 1];
			ds_grid_read(global.mapReveal_Debug, _map_map[? "mapReveal_Debug"]);
	
			var _worldFlags_map = _list[| 2];
			global.currentPlayTime = _worldFlags_map[? "currentPlayTime"];
	
	
			ds_map_destroy(_wrapper);
	
			show_debug_message("Game file "+string(file)+" loaded");
		}
		catch(_exception)
		{
			show_debug_message(_exception.message);
			show_debug_message(_exception.longMessage);
			show_debug_message(_exception.script);
			show_debug_message(_exception.stacktrace);
		}
		/*finally
		{
			room_goto(rm_debug01);
			var sx = 80,
				sy = 694;
			instance_create_layer(sx,sy,"Player",obj_Player);
			instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
		}*/
	}
	else
	{
		room_goto(rm_debug01);
		var sx = 80,
			sy = 694;
		instance_create_layer(sx,sy,"Player",obj_Player);
		instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
		
		ds_grid_clear(global.mapReveal_Debug,false);
	}
}