/// @description Initialize
event_inherited();

damageType = DmgType.Charge;
freezeType = 0;

dmgDelay = 0;

isCharge = true;
isWave = true;
isPlasma = true;

particleType = -1;

multiHit = true;
tileCollide = false;

//npcDeathType = 3;

image_speed = 0;
image_index = 0;

frame = 0;
frameCounter = 0;
frameSeq = array(0,0,1,1,2,3,4);

function OnDamageNPC(damage,npc)
{
	var posX = npc.x+npc.deathOffsetX,
		posY = npc.y+npc.deathOffsetY;
	part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partFlareFX,1);
}