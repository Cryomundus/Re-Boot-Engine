/// @description Code
scr_OpenDoor(x,y,0);
scr_BreakBlock(x,y,1);

scr_DamageNPC(x,y,damage,damageType,0,-1,4);

instance_destroy();