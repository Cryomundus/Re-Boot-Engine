/// @description Initialize
event_inherited();
snd = noone;
respawnTime = 0;
asset_remove_tags(object_get_name(object_index),"ISolid",asset_object);

damage = 15;
knockBack = 10;//5;
knockBackSpeed = 3.5;//7;
damageImmuneTime = 60;

frame = 0;
frameCounter = 0;
frameSeq = array(2,3,4,3);

image_speed = 0;