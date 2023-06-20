/// @description 

if(global.gamePaused)
{
	exit;
}

var sfxFlag = false,
	dustFlag = false;
var player = instance_place(x-2,y,obj_Player);
if(!instance_exists(player))
{
	player = instance_place(x+2,y,obj_Player);
}
if(pushState == PushState.Push && instance_exists(player) && player.isPushing && player.pushBlock == id && abs(fVelX) > 0)
{
	with(player)
	{
		var vx = pushMove[pushFrameSequence[scr_floor(frame[Frame.Push])]];
		sfxFlag = (vx >= 3);
		dustFlag = (vx >= 2);
	}
}

var nonPushFlag = (pushState != PushState.Push && abs(fVelX) > 1);
if(grounded && (nonPushFlag || sfxFlag))
{
	if(moveSnd == noone || !audio_is_playing(moveSnd) || sndStopped)
	{
		audio_stop_sound(moveSnd);
		moveSnd = audio_play_sound(snd_PushBlock_Move,0,false);
		audio_sound_loop(moveSnd,true);
		audio_sound_loop_start(moveSnd,0);
		audio_sound_loop_end(moveSnd,0.115);
		sndStopped = false;
	}
}
else if(audio_is_playing(moveSnd))
{
	audio_sound_loop(moveSnd,false);
	sndStopped = true;
}

if(grounded && (nonPushFlag || dustFlag) && !InWater)
{
	var dustX = irandom_range(bbox_left-2,x-5);
	if(sign(velX) == -1)
	{
		dustX = irandom_range(x+5,bbox_right+2);
	}
	if(irandom(1) == 0)
	{
		dustX = irandom_range(bbox_left-2,bbox_right+2);
	}
	part_particles_create(obj_Particles.partSystemB,dustX,irandom_range(bbox_bottom-2,bbox_bottom+1),obj_Particles.bDust[0],1);
}

if(pushState == PushState.None)
{
	var frict = 0.5;
	if(!grounded)
	{
		frict = 0.125;
	}
	if(InWater)
	{
		frict = 0.75;
		if(!grounded)
		{
			frict = 0.375;
		}
	}
	if(velX > 0)
	{
		velX = max(velX-frict,0);
	}
	if(velX < 0)
	{
		velX = min(velX+frict,0);
	}
}

fGrav = grav[InWater];

if(!grounded)
{
    velY = min(velY+fGrav, 7);
}

fVelX = velX;
fVelY = velY;

Collision_Normal(fVelX,fVelY,15,15,true);

var downSlope = GetEdgeSlope(Edge.Bottom);
var downSlopeFlag = (place_meeting(x,y+2,downSlope) && downSlope.image_yscale > 1 && 
					((downSlope.image_xscale > 0 && bbox_left > downSlope.bbox_left) || (downSlope.image_xscale < 0 && bbox_right < downSlope.bbox_right)));
if(!entity_place_collide(0,1) || downSlopeFlag)
{
	grounded = ((bbox_bottom+1) >= room_height);
}

//if(scr_WithinCamRange())
//{
	pushblock_water();
//}

mBlock.UpdatePosition(position.X-16,position.Y-16);

var passthruCheck = SkipOwnMovingTile(instance_place_list(scr_round(x),scr_round(y),all,block_list,true),true);
if (passthruCheck)
{
	passthru = min(passthru+1,passthruMax);
}
else
{
	passthru = 0;
}
passthroughMovingSolids = (passthru >= passthruMax);
if(passthroughMovingSolids)
{
	array_resize(solids,1);
	solids[0] = "ISolid";
	solids[1] = "IPlayer";
}
else
{
	solids[0] = "ISolid";
	solids[1] = "IMovingSolid";
	solids[2] = "IPlayer";
}

if(pushState == PushState.Push)
{
	velX = 0;
}

pushState = PushState.None;