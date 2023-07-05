/// @description 

solids[0] = "ISolid";
solids[1] = "IMovingSolid";

shutterID = 0;

image_index = 0;
image_speed = 0;

shutterH = sprite_height - 16;
sSpeed = 1;
overrideHeight = 0;

image_xscale = 1;
image_yscale = 1;

frame = 1;

mBlock = instance_create_layer(x+lengthdir_x(shutterH+16,image_angle-90),y+lengthdir_y(shutterH+16,image_angle-90),"Collision",obj_MovingTile);
mBlock.image_angle = image_angle;
mBlock.image_yscale = -(scr_round(shutterH)/16);

tileObj = instance_create_layer(x,y,"Collision",obj_Tile);
tileObj.image_angle = image_angle;

block_list = ds_list_create();
function shutter_place_meeting(_x,_y)
{
	var num = instance_place_list(_x,_y,all,block_list,true);
	for(var i = 0; i < num; i++)
	{
		if(instance_exists(block_list[| i]) && asset_has_any_tag(block_list[| i].object_index,solids,asset_object))
		{
			if ((!instance_exists(tileObj) || block_list[| i] != tileObj) &&
				(!instance_exists(mBlock) || block_list[| i] != mBlock))
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

enum ShutterState
{
	Closed,
	Closing,
	Opened,
	Opening
}
state = ShutterState.Closed;
if(shutterH <= 0)
{
	state = ShutterState.Opened;
}

function Toggle()
{
	if(state == ShutterState.Closed)
	{
		state = ShutterState.Opening;
		audio_stop_sound(snd_ShutterGate);
		audio_play_sound(snd_ShutterGate,0,false);
	}
	if(state == ShutterState.Opened)
	{
		state = ShutterState.Closing;
		audio_stop_sound(snd_ShutterGate);
		audio_play_sound(snd_ShutterGate,0,false);
	}
}