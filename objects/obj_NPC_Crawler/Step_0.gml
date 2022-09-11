/// @description AI Behavior
event_inherited();
if(PauseAI())
{
	exit;
}

var rot = rotation2;

var xcheck = max(abs(velX),1),
	ycheck = max(abs(velY),1);
var collideAny = (lhc_place_collide(xcheck,0) || lhc_place_collide(-xcheck,0) || lhc_place_collide(0,ycheck) || lhc_place_collide(0,-ycheck) ||
				lhc_place_collide(xcheck,ycheck) || lhc_place_collide(-xcheck,ycheck) || lhc_place_collide(xcheck,-ycheck) || lhc_place_collide(-xcheck,-ycheck));

if(instance_exists(obj_ScreenShaker) && obj_ScreenShaker.active && colEdge != Edge.Bottom && !lhc_place_collide(0,ycheck))
{
	collideAny = false;
}

if(!collideAny)
{
	colEdge = Edge.None;
}

if(colEdge == Edge.None)
{
	if(abs(scr_wrap(rotation2,-180,180)) < 90)
	{
		rotation2 = scr_wrap(-90*moveDir,0,360);
	}
	
	velX = 0;
	velY += min(fGrav,max(fallSpeedMax-velY,0));
	
	if(collideAny)
	{
		if(lhc_place_collide(0,ycheck))
		{
			colEdge = Edge.Bottom;
		}
		else if(lhc_place_collide(0,-ycheck))
		{
			colEdge = Edge.Top;
		}
		else if(lhc_place_collide(xcheck,0))
		{
			colEdge = Edge.Right;
		}
		else if(lhc_place_collide(-xcheck,0))
		{
			colEdge = Edge.Left;
		}
	}
}

if(lhc_place_collide(0,0))
{
	var flag3 = false;
	var dirX = 0, dirY = 0;
	if(!lhc_collision_line(bbox_right+1,bbox_top,bbox_right+1,bbox_bottom,"ISolid",true,true))
	{
		dirX = 1;
	}
	else if(!lhc_collision_line(bbox_left-1,bbox_top,bbox_left-1,bbox_bottom,"ISolid",true,true))
	{
		dirX = -1;
	}
	else
	{
		//dirX *= -1;
		flag3 = true;
	}
			
	if(!lhc_collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,"ISolid",true,true))
	{
		dirY = 1;
	}
	else if(!lhc_collision_line(bbox_left,bbox_top-1,bbox_right,bbox_top-1,"ISolid",true,true) || flag3)
	{
		dirY = -1;
	}
	else
	{
		//dirY *= -1;
	}
			
	velX = mSpeed*dirX;
	velY = mSpeed*dirY;
	x += velX;
	y += velY;
}
else
{
	var bottom_rot = 0,
	left_rot = 270,
	top_rot = 180,
	right_rot = 90;
			
	switch(colEdge)
	{
		case Edge.Bottom:
		{
			velX = mSpeed*moveDir;
			velY = 1;
			rotation2 = bottom_rot;
			break;
		}
		case Edge.Left:
		{
			velX = -1;
			velY = mSpeed*moveDir;
			rotation2 = left_rot;
			break;
		}
		case Edge.Top:
		{
			velX = -mSpeed*moveDir;
			velY = -1;
			rotation2 = top_rot;
			break;
		}
		case Edge.Right:
		{
			velX = 1;
			velY = -mSpeed*moveDir;
			rotation2 = right_rot;
			break;
		}
	}
	var slope = GetEdgeSlope(colEdge,2);
	if(instance_exists(slope))
	{
		rotation2 = scr_GetSlopeAngle(slope);
	}
	
	fVelX = velX;
	fVelY = velY;
	Collision_Crawler(fVelX,fVelY,3,3,false,true);
}

var rot2 = scr_round(rotation2);
rotation2 = scr_wrap(rot,0,360);
var rot3 = abs(rotation2 - rot2),
	rotRate = radtodeg(0.2) * mSpeed;
if(rotation2 > rot2)
{
	if(rot3 > 180)
	{
		rotation2 += rotRate;
	}
	else
	{
		rotation2 = max(rotation2-rotRate,rot2);
	}
}
if(rotation2 < rot2)
{
	if(rot3 > 180)
	{
		rotation2 -= rotRate;
	}
	else
	{
		rotation2 = min(rotation2+rotRate,rot2);
	}
}
rotation = scr_round(rotation2/5.625)*5.625;
