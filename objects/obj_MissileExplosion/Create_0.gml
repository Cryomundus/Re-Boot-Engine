event_inherited();
//isMissile = true;
type = ProjType.Missile;
multiHit = true;
//image_xscale = 0.6;
//image_yscale = 0.6;
part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.explosion[1],1);

damageType = DmgType.Explosive;
damageSubType[1] = true;
damageSubType[5] = true;